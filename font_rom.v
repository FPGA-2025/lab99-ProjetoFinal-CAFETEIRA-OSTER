// Simple 8x8 bitmap ROM for letters A-Z (state 0 = 'A', 1 = 'B', ... 25 = 'Z')
// Each entry is 8 bytes (rows). Bit 7 is the leftmost pixel.
initial begin
    // A
    font_rom[0][0] = 8'h18; font_rom[0][1] = 8'h24; font_rom[0][2] = 8'h42; font_rom[0][3] = 8'h42;
    font_rom[0][4] = 8'h7E; font_rom[0][5] = 8'h42; font_rom[0][6] = 8'h42; font_rom[0][7] = 8'h42;
    // B
    font_rom[1][0] = 8'h7C; font_rom[1][1] = 8'h42; font_rom[1][2] = 8'h42; font_rom[1][3] = 8'h7C;
    font_rom[1][4] = 8'h42; font_rom[1][5] = 8'h42; font_rom[1][6] = 8'h42; font_rom[1][7] = 8'h7C;
    // C
    font_rom[2][0] = 8'h3C; font_rom[2][1] = 8'h42; font_rom[2][2] = 8'h40; font_rom[2][3] = 8'h40;
    font_rom[2][4] = 8'h40; font_rom[2][5] = 8'h42; font_rom[2][6] = 8'h3C; font_rom[2][7] = 8'h00;
    // D
    font_rom[3][0] = 8'h78; font_rom[3][1] = 8'h44; font_rom[3][2] = 8'h42; font_rom[3][3] = 8'h42;
    font_rom[3][4] = 8'h42; font_rom[3][5] = 8'h44; font_rom[3][6] = 8'h78; font_rom[3][7] = 8'h00;
    // E
    font_rom[4][0] = 8'h7E; font_rom[4][1] = 8'h40; font_rom[4][2] = 8'h40; font_rom[4][3] = 8'h7C;
    font_rom[4][4] = 8'h40; font_rom[4][5] = 8'h40; font_rom[4][6] = 8'h7E; font_rom[4][7] = 8'h00;
    // F
    font_rom[5][0] = 8'h7E; font_rom[5][1] = 8'h40; font_rom[5][2] = 8'h40; font_rom[5][3] = 8'h7C;
    font_rom[5][4] = 8'h40; font_rom[5][5] = 8'h40; font_rom[5][6] = 8'h40; font_rom[5][7] = 8'h00;
    // G
    font_rom[6][0] = 8'h3C; font_rom[6][1] = 8'h42; font_rom[6][2] = 8'h40; font_rom[6][3] = 8'h4E;
    font_rom[6][4] = 8'h42; font_rom[6][5] = 8'h42; font_rom[6][6] = 8'h3C; font_rom[6][7] = 8'h00;
    // H
    font_rom[7][0] = 8'h42; font_rom[7][1] = 8'h42; font_rom[7][2] = 8'h42; font_rom[7][3] = 8'h7E;
    font_rom[7][4] = 8'h42; font_rom[7][5] = 8'h42; font_rom[7][6] = 8'h42; font_rom[7][7] = 8'h00;
    // I
    font_rom[8][0] = 8'h7E; font_rom[8][1] = 8'h18; font_rom[8][2] = 8'h18; font_rom[8][3] = 8'h18;
    font_rom[8][4] = 8'h18; font_rom[8][5] = 8'h18; font_rom[8][6] = 8'h7E; font_rom[8][7] = 8'h00;
    // J
    font_rom[9][0] = 8'h1E; font_rom[9][1] = 8'h04; font_rom[9][2] = 8'h04; font_rom[9][3] = 8'h04;
    font_rom[9][4] = 8'h44; font_rom[9][5] = 8'h44; font_rom[9][6] = 8'h38; font_rom[9][7] = 8'h00;
    // K
    font_rom[10][0] = 8'h42; font_rom[10][1] = 8'h44; font_rom[10][2] = 8'h48; font_rom[10][3] = 8'h70;
    font_rom[10][4] = 8'h48; font_rom[10][5] = 8'h44; font_rom[10][6] = 8'h42; font_rom[10][7] = 8'h00;
    // L
    font_rom[11][0] = 8'h40; font_rom[11][1] = 8'h40; font_rom[11][2] = 8'h40; font_rom[11][3] = 8'h40;
    font_rom[11][4] = 8'h40; font_rom[11][5] = 8'h40; font_rom[11][6] = 8'h7E; font_rom[11][7] = 8'h00;
    // M
    font_rom[12][0] = 8'h42; font_rom[12][1] = 8'h66; font_rom[12][2] = 8'h5A; font_rom[12][3] = 8'h5A;
    font_rom[12][4] = 8'h42; font_rom[12][5] = 8'h42; font_rom[12][6] = 8'h42; font_rom[12][7] = 8'h00;
    // N
    font_rom[13][0] = 8'h42; font_rom[13][1] = 8'h62; font_rom[13][2] = 8'h52; font_rom[13][3] = 8'h4A;
    font_rom[13][4] = 8'h46; font_rom[13][5] = 8'h42; font_rom[13][6] = 8'h42; font_rom[13][7] = 8'h00;
    // O
    font_rom[14][0] = 8'h3C; font_rom[14][1] = 8'h42; font_rom[14][2] = 8'h42; font_rom[14][3] = 8'h42;
    font_rom[14][4] = 8'h42; font_rom[14][5] = 8'h42; font_rom[14][6] = 8'h3C; font_rom[14][7] = 8'h00;
    // P
    font_rom[15][0] = 8'h7C; font_rom[15][1] = 8'h42; font_rom[15][2] = 8'h42; font_rom[15][3] = 8'h7C;
    font_rom[15][4] = 8'h40; font_rom[15][5] = 8'h40; font_rom[15][6] = 8'h40; font_rom[15][7] = 8'h00;
    // Q
    font_rom[16][0] = 8'h3C; font_rom[16][1] = 8'h42; font_rom[16][2] = 8'h42; font_rom[16][3] = 8'h42;
    font_rom[16][4] = 8'h4A; font_rom[16][5] = 8'h44; font_rom[16][6] = 8'h3A; font_rom[16][7] = 8'h00;
    // R
    font_rom[17][0] = 8'h7C; font_rom[17][1] = 8'h42; font_rom[17][2] = 8'h42; font_rom[17][3] = 8'h7C;
    font_rom[17][4] = 8'h48; font_rom[17][5] = 8'h44; font_rom[17][6] = 8'h42; font_rom[17][7] = 8'h00;
    // S
    font_rom[18][0] = 8'h3C; font_rom[18][1] = 8'h42; font_rom[18][2] = 8'h40; font_rom[18][3] = 8'h3C;
    font_rom[18][4] = 8'h02; font_rom[18][5] = 8'h42; font_rom[18][6] = 8'h3C; font_rom[18][7] = 8'h00;
    // T
    font_rom[19][0] = 8'h7E; font_rom[19][1] = 8'h18; font_rom[19][2] = 8'h18; font_rom[19][3] = 8'h18;
    font_rom[19][4] = 8'h18; font_rom[19][5] = 8'h18; font_rom[19][6] = 8'h18; font_rom[19][7] = 8'h00;
    // U
    font_rom[20][0] = 8'h42; font_rom[20][1] = 8'h42; font_rom[20][2] = 8'h42; font_rom[20][3] = 8'h42;
    font_rom[20][4] = 8'h42; font_rom[20][5] = 8'h42; font_rom[20][6] = 8'h3C; font_rom[20][7] = 8'h00;
    // V
    font_rom[21][0] = 8'h42; font_rom[21][1] = 8'h42; font_rom[21][2] = 8'h42; font_rom[21][3] = 8'h42;
    font_rom[21][4] = 8'h42; font_rom[21][5] = 8'h24; font_rom[21][6] = 8'h18; font_rom[21][7] = 8'h00;
    // W
    font_rom[22][0] = 8'h42; font_rom[22][1] = 8'h42; font_rom[22][2] = 8'h42; font_rom[22][3] = 8'h5A;
    font_rom[22][4] = 8'h5A; font_rom[22][5] = 8'h66; font_rom[22][6] = 8'h42; font_rom[22][7] = 8'h00;
    // X
    font_rom[23][0] = 8'h42; font_rom[23][1] = 8'h24; font_rom[23][2] = 8'h18; font_rom[23][3] = 8'h18;
    font_rom[23][4] = 8'h18; font_rom[23][5] = 8'h24; font_rom[23][6] = 8'h42; font_rom[23][7] = 8'h00;
    // Y
    font_rom[24][0] = 8'h42; font_rom[24][1] = 8'h24; font_rom[24][2] = 8'h18; font_rom[24][3] = 8'h18;
    font_rom[24][4] = 8'h18; font_rom[24][5] = 8'h18; font_rom[24][6] = 8'h18; font_rom[24][7] = 8'h00;
    // Z
    font_rom[25][0] = 8'h7E; font_rom[25][1] = 8'h02; font_rom[25][2] = 8'h04; font_rom[25][3] = 8'h08;
    font_rom[25][4] = 8'h10; font_rom[25][5] = 8'h20; font_rom[25][6] = 8'h7E; font_rom[25][7] = 8'h00;
end
