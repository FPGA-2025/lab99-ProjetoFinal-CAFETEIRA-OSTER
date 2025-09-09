`default_nettype none

// Módulo principal do projeto HDMI Test Pattern para ULX3S 25F
module ULX3S_25F (
  input clk_25mhz, // Clock de entrada de 25 MHz
  output [3:0] gpdi_dp, gpdi_dn, // Sinais diferenciais para HDMI (TMDS)
  output wifi_gpio0, // GPIO para WiFi, usado para evitar reboot da placa
  output led, // LED L2
  output [3:0] kb_C, // Colunas do teclado
  input  [3:0] kb_L // Linhas do teclado
);

  // Instancia o teclado matricial 4x4
  wire led_on;
  wire key_click;
  keyboard keyboard_instance(
    .clk(clk_25mhz),
    .reset(reset),
    .led_on(led_on),
    .kb_C(kb_C),
    .kb_L(kb_L),
    .key_click(key_click)
  );

  // LED L2 acende se qualquer tecla for pressionada
  assign led = led_on;

  // Mantém o pino gpio0 em nível alto para evitar que a placa reinicie
  assign wifi_gpio0 = 1'b1;

  // Declaração dos sinais de clock internos
  wire clk_25MHz, clk_250MHz;
  // Instancia o módulo de geração de clocks
  clock clock_instance(
      .clkin_25MHz(clk_25mhz), // Clock de entrada
      .clk_25MHz(clk_25MHz),   // Clock de pixel (vídeo)
      .clk_250MHz(clk_250MHz)  // Clock TMDS (10x do pixel)
  );

  // Sinais para as cores RGB
  wire [7:0] red, grn, blu;
  wire [23:0] pixel; // Pixel completo (8 bits por cor)
  // Separa os canais de cor do sinal de pixel
  assign red= pixel[23:16];
  assign grn= pixel[15:8];
  assign blu= pixel[7:0];

  // Sinais de saída do HDMI
  wire o_red;
  wire o_grn;
  wire o_blu;
  wire o_rd, o_newline, o_newframe;

  // Lógica de reset: linha que fica baixa por 16 ciclos de clock
  reg [2:0] reset_cnt = 0;
  wire reset = ~reset_cnt[2];
  always @(posedge clk_25mhz)
    if (reset) reset_cnt <= reset_cnt + 1;

  // Instancia o módulo HDMI, responsável por gerar os sinais TMDS
  llhdmi llhdmi_instance(
    .i_tmdsclk(clk_250MHz), // Clock TMDS
    .i_pixclk(clk_25MHz),   // Clock de pixel
    .i_reset(reset),        // Reset
    .i_red(red), .i_grn(grn), .i_blu(blu), // Entradas de cor
    .o_rd(o_rd), .o_newline(o_newline), .o_newframe(o_newframe), // Controle de leitura de pixels
    .o_red(o_red), .o_grn(o_grn), .o_blu(o_blu) // Saídas TMDS codificadas
  );

  // Instancia o gerador de padrões de vídeo (barras, gradientes, etc)
  vgatestsrc #(.BITS_PER_COLOR(8))
    vgatestsrc_instance(
      .i_pixclk(clk_25MHz), // Clock de pixel
      .i_reset(reset),      // Reset
      .i_width(640), .i_height(480), // Resolução do vídeo
      .i_rd(o_rd), .i_newline(o_newline), .i_newframe(o_newframe), // Controle de leitura
      .key_click(key_click), // Pulso de clique do teclado
      .o_pixel(pixel) // Saída do pixel gerado
    );

  // Instancia buffers diferenciais para enviar os sinais TMDS para o HDMI
  OBUFDS OBUFDS_red(.I(o_red), .O(gpdi_dp[2]), .OB(gpdi_dn[2]));   // Canal vermelho
  OBUFDS OBUFDS_grn(.I(o_grn), .O(gpdi_dp[1]), .OB(gpdi_dn[1]));  // Canal verde
  OBUFDS OBUFDS_blu(.I(o_blu), .O(gpdi_dp[0]), .OB(gpdi_dn[0]));  // Canal azul
  OBUFDS OBUFDS_clock(.I(clk_25MHz), .O(gpdi_dp[3]), .OB(gpdi_dn[3])); // Clock de vídeo


endmodule
