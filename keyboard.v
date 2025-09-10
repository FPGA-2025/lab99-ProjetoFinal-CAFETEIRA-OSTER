

`default_nettype none

// Módulo para teclado matricial 4x4
// Varre as colunas do teclado, detecta se alguma tecla foi pressionada
// e acende o LED se qualquer tecla estiver pressionada
module keyboard (
	input clk,                // Clock principal
	input reset,              // Reset síncrono
	output reg led_on,        // Sinal para acender o LED
	output reg [3:0] kb_C,    // Saídas para as colunas do teclado (ativa uma por vez)
	input      [3:0] kb_L,    // Entradas das linhas do teclado (leitura das teclas)
	output reg key_click,     // Pulso: 1 ciclo quando qualquer tecla é pressionada
	output reg [4:0] key_index // Índice da tecla pressionada (0-15)
);
	reg [3:0] col;            // Índice da coluna atualmente ativada
	reg [15:0] key_matrix;    // Matriz que guarda o estado das 16 teclas
	reg prev_any_key;         // Guarda estado anterior de qualquer tecla
	reg [4:0] key_index_reg;  // Registro para key_index
	integer i;

	// Função para mapear coordenada (col, row) para índice da letra
	function [4:0] coord_to_letter;
		input [1:0] col_in;
		input [1:0] row_in;
		begin
			// Mapeamento: c1 l1 -> A (0), c1 l2 -> B (1), c2 l1 -> C (2), etc.
			// Para sequencial por linha: row*4 + col
			coord_to_letter = {row_in, col_in}; // row*4 + col
		end
	endfunction

	// Scanner simples: varre as colunas do teclado
	// A cada ciclo de clock, ativa uma coluna e lê as linhas
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			// Inicializa tudo ao reset
			col <= 0;
			key_matrix <= 0;
			kb_C <= 4'b1111; // Todas as colunas desativadas (ativo baixo)
			led_on <= 0;
			prev_any_key <= 0;
			key_click <= 0;
		end else begin
			// Avança para a próxima coluna
			col <= col + 1;
			// Ativa apenas a coluna atual (ativo baixo)
			kb_C <= ~(1 << col);
			// Para cada linha, verifica se a tecla está pressionada
			// Se kb_L[i] estiver em nível baixo, a tecla está pressionada
			for (i = 0; i < 4; i = i + 1) begin
				if (~kb_L[i]) // ativo baixo: tecla pressionada
					key_matrix[col*4 + i] <= 1; // Marca tecla como pressionada
				else
					key_matrix[col*4 + i] <= 0; // Marca tecla como não pressionada
			end
			// Liga o LED se qualquer tecla estiver pressionada
			if (|key_matrix)
				led_on <= 1;
			else
				led_on <= 0;

			// Atualiza key_index: pega o índice da primeira tecla pressionada
			key_index = 0;
			for (i = 0; i < 16; i = i + 1) begin
				if (key_matrix[i]) begin
					key_index <= i;
				end
			end

			// Detecta borda de subida: clique
			if ((|key_matrix) && !prev_any_key)
				key_click <= 1;
			else
				key_click <= 0;
			prev_any_key <= |key_matrix;
		end
	end
endmodule
