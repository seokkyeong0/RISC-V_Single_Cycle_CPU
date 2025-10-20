`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/22 10:41:42
// Design Name: 
// Module Name: define
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Opcode list
`define OP_R_TYPE   7'b0110011 // R-type
`define OP_S_TYPE   7'b0100011 // S-type
`define OP_IL_TYPE  7'b0000011 // I-type + Load
`define OP_IR_TYPE  7'b0010011 // I-type + Calc(Imm)
`define OP_B_TYPE   7'b1100011 // B-Type
`define OP_LUI_TYPE 7'b0110111 // U-Type (LUI)
`define OP_AUI_TYPE 7'b0010111 // U-Type (AUIPC)
`define OP_JAL_TYPE 7'b1101111 // J-Type (JAL)
`define OP_JAR_TYPE 7'b1100111 // I-Type (JALR)

// R-type or IR-Type Command
`define ADD  4'b0000
`define SUB  4'b1000
`define SLL  4'b0001
`define SRL  4'b0101
`define SRA  4'b1101
`define SLT  4'b0010
`define SLTU 4'b0011
`define XOR  4'b0100
`define OR   4'b0110
`define AND  4'b0111

// S-type Command
`define STB 3'b000
`define STH 3'b001
`define STW 3'b010

// IL-type Command
`define LB  3'b000
`define LH  3'b001
`define LW  3'b010
`define LBU 3'b100
`define LHU 3'b101

// B-type Command
`define BEQ  3'b000
`define BNE  3'b001
`define BLT  3'b100
`define BGE  3'b101
`define BLTU 3'b110
`define BGEU 3'b111