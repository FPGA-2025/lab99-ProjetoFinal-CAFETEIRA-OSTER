
`default_nettype none

// Módulo responsável por gerar padrões de vídeo e codificá-los em TMDS para HDMI
module pattern(
    input i_tmdsclk, // Clock TMDS (alta frequência)
    input i_pixclk,  // Clock de pixel (vídeo)
    output red, grn, blu, // Sinais RGB do pixel
    output o_rd, // Sinal de leitura de pixel
    output o_TMDS_red, o_TMDS_grn, o_TMDS_blu // Sinais TMDS codificados para HDMI
);

  // Sinais para as cores RGB
  wire [7:0] red, grn, blu;
  wire [23:0] pixel; // Pixel completo (8 bits por cor)
  // Separa os canais de cor do sinal de pixel
  assign red= pixel[23:16];
  assign grn= pixel[15:8];
  assign blu= pixel[7:0];

  /* verilator lint_off UNUSED */
  // Sinais auxiliares para simulação/verificação
  wire o_red;
  wire o_grn;
  wire o_blu;
  wire [9:0] o_TMDS_red, o_TMDS_grn, o_TMDS_blu; // Sinais TMDS codificados
  /* verilator lint_on UNUSED */
  wire o_rd, o_newline, o_newframe; // Controle de leitura e sincronismo

  // Lógica de reset: linha que fica baixa por 16 ciclos de clock de pixel
  reg [2:0] reset_cnt = 0;
  wire reset = ~reset_cnt[2];
  always @(posedge i_pixclk)
    if (reset) reset_cnt <= reset_cnt + 1;

  // Instancia o módulo HDMI, responsável por gerar os sinais TMDS e controle
  llhdmi llhdmi_instance(
    .i_tmdsclk(i_tmdsclk), // Clock TMDS
    .i_pixclk(i_pixclk),   // Clock de pixel
    .i_reset(reset),       // Reset
    .i_red(red), .i_grn(grn), .i_blu(blu), // Entradas de cor
    .o_rd(o_rd), .o_newline(o_newline), .o_newframe(o_newframe), // Controle de leitura
    .o_TMDS_red(o_TMDS_red), .o_TMDS_grn(o_TMDS_grn), .o_TMDS_blu(o_TMDS_blu), // Saídas TMDS
    .o_red(o_red), .o_grn(o_grn), .o_blu(o_blu) // Saídas RGB codificadas
  );

  // Instancia o gerador de padrões de vídeo (barras, gradientes, etc)
  vgatestsrc #(.BITS_PER_COLOR(8))
    vgatestsrc_instance(
      .i_pixclk(i_pixclk), // Clock de pixel
      .i_reset(reset),     // Reset
      .i_width(640), .i_height(480), // Resolução do vídeo
      .i_rd(o_rd), .i_newline(o_newline), .i_newframe(o_newframe), // Controle de leitura
      .o_pixel(pixel) // Saída do pixel gerado
    );

endmodule
