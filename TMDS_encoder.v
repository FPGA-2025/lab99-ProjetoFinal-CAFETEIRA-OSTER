// (c) fpga4fun.com & KNJN LLC 2013

////////////////////////////////////////////////////////////////////////
// Módulo responsável por codificar os dados de vídeo para o padrão TMDS (HDMI/DVI)
module TMDS_encoder(
	input clk, // Clock de 250 MHz
	input [7:0] VD,  // Dados de vídeo (vermelho, verde ou azul)
	input [1:0] CD,  // Dados de controle (sincronismo)
	input VDE,  // Habilita dados de vídeo: se 0, transmite controle; se 1, transmite vídeo
	output reg [9:0] TMDS = 0 // Saída codificada TMDS (10 bits)
);

// Conta o número de bits '1' nos dados de vídeo
wire [3:0] Nb1s = {3'b0, VD[0]} + {3'b0, VD[1]} + {3'b0, VD[2]}
	+ {3'b0, VD[3]} + {3'b0, VD[4]} + {3'b0, VD[5]}
	+ {3'b0, VD[6]} + {3'b0, VD[7]};
// Define se a codificação será XNOR ou XOR, para minimizar transições
wire XNOR = (Nb1s>4'd4) || (Nb1s==4'd4 && VD[0]==1'b0);

// Gera os bits intermediários da codificação TMDS
// Cada QM representa um estágio da codificação
wire QM0, QM1, QM2, QM3, QM4, QM5, QM6, QM7, QM8;
assign QM0= VD[0];
assign QM1= QM0 ^ VD[1] ^ XNOR;
assign QM2= QM1 ^ VD[2] ^ XNOR;
assign QM3= QM2 ^ VD[3] ^ XNOR;
assign QM4= QM3 ^ VD[4] ^ XNOR;
assign QM5= QM4 ^ VD[5] ^ XNOR;
assign QM6= QM5 ^ VD[6] ^ XNOR;
assign QM7= QM6 ^ VD[7] ^ XNOR;
assign QM8= ~XNOR;
// Junta todos os bits intermediários em um vetor
wire [8:0] q_m = { QM8, QM7, QM6, QM5, QM4, QM3, QM2, QM1, QM0 };

// Acumulador de balanceamento de bits para minimizar interferência
reg [3:0] balance_acc = 0;
// Calcula o balanceamento dos bits (diferença entre 1s e 0s)
wire [3:0] balance = {3'b0, q_m[0]} + {3'b0, q_m[1]} + {3'b0, q_m[2]}
	+ {3'b0, q_m[3]} + {3'b0, q_m[4]} + {3'b0, q_m[5]}
	+ {3'b0, q_m[6]} + {3'b0, q_m[7]} - 4'd4;
// Verifica se o sinal de balanceamento mudou de sinal
wire balance_sign_eq = (balance[3] == balance_acc[3]);
// Decide se deve inverter os bits para manter o balanceamento
wire invert_q_m = (balance==0 || balance_acc==0) ? ~q_m[8] : balance_sign_eq;

// Calcula o novo valor do acumulador de balanceamento
wire [3:0] balance_acc_inc = balance
	- {3'b0,
	   ({q_m[8] ^ ~balance_sign_eq} & ~(balance==0 || balance_acc==0)) };
wire [3:0] balance_acc_new = invert_q_m ? balance_acc-balance_acc_inc : balance_acc+balance_acc_inc;
// Gera o dado TMDS final para vídeo
wire [9:0] TMDS_data = {invert_q_m, q_m[8], q_m[7:0] ^ {8{invert_q_m}}};
// Gera o dado TMDS para sinais de controle (sincronismo)
wire [9:0] TMDS_code = CD[1] ? (CD[0] ? 10'b1010101011 : 10'b0101010100) : (CD[0] ? 10'b0010101011 : 10'b1101010100);

// Seleciona entre dados de vídeo ou controle para transmitir
always @(posedge clk) TMDS <= VDE ? TMDS_data : TMDS_code;
// Atualiza o acumulador de balanceamento
always @(posedge clk) balance_acc <= VDE ? balance_acc_new : 4'h0;
endmodule

////////////////////////////////////////////////////////////////////////
