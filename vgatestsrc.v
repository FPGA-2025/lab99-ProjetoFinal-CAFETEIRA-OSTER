
`default_nettype none

// Módulo responsável por gerar padrões de barras de cor para teste de vídeo
module vgatestsrc(
	input wire i_pixclk, i_reset, // Clock de pixel e reset
	// Entradas externas: largura, altura, controle de leitura e sincronismo
	input wire [HW-1:0] i_width,
	input wire [VW-1:0] i_height,
	input wire i_rd, i_newline, i_newframe,
	input wire key_click, // Pulso para trocar estado
	// Saída: pixel RGB gerado
	output reg [(BPP-1):0] o_pixel
);
	// Parâmetros: profundidade de cor e resolução máxima
	parameter BITS_PER_COLOR = 4, HW=12, VW=12;
	//localparam para facilitar manipulação de bits
	localparam BPC = BITS_PER_COLOR,
			  BITS_PER_PIXEL = 3 * BPC,
			  BPP = BITS_PER_PIXEL;




	// Definição das cores básicas
	wire [BPP-1:0] white, black;
	assign white = {(BPP){1'b1}}; // Branco
	assign black = {(BPP){1'b0}}; // Preto

	// Máquina de estados: 0-25 para letras A-Z
	reg [4:0] state;
	always @(posedge i_pixclk or posedge i_reset) begin
		if (i_reset)
			state <= 0;
		else if (key_click)
			state <= (state == 25) ? 0 : state + 1;
	end

	// Controle de posição horizontal e vertical dos pixels
	reg [HW-1:0] hpos;
	reg [VW-1:0] ypos;
	always @(posedge i_pixclk)
		if ((i_reset)||(i_newframe)) begin
			ypos  <= 0;
		end else if (i_newline) begin
			ypos <= ypos + 1'b1;
		end
	initial hpos  = 0;
	always @(posedge i_pixclk)
		if ((i_reset)||(i_newline)) begin
			hpos <= 0;
		end else if (i_rd) begin
			hpos <= hpos + 1'b1;
		end



	// ROM simples de bitmaps para letras A-Z (8x8)
	reg [7:0] font_rom [0:25][0:7];
	`include "font_rom.v"

	// Parâmetros para centralizar letra
	localparam FONT_W = 64;
	localparam FONT_H = 64;
	localparam FONT_ROM_W = 8;
	localparam FONT_ROM_H = 8;
	localparam X0 = 288;
	localparam Y0 = 208;

	reg [7:0] font_row;
	reg font_pixel;

	always @(posedge i_pixclk)
		if (i_newline)
			o_pixel <= black; // Linha nova: borda branca
		else if (i_rd)
		begin
			begin
				// Verifica se está na área da letra
				if (hpos >= X0 && hpos < X0+FONT_W && ypos >= Y0 && ypos < Y0+FONT_H) begin
					// Calcula posição no bitmap
					font_row = font_rom[state][(ypos-Y0)/8];
					font_pixel = font_row[7-((hpos-X0)/8)];
					if (font_pixel)
						o_pixel <= {8'hFF,8'hFF,8'hFF}; // Branco para pixel da letra
					else
						o_pixel <= {8'h00,8'h00,8'h00}; // Preto para fundo
				end else begin
					o_pixel <= black; // fundo preto
				end
			end
		end

endmodule

