`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/20 11:43:12
// Design Name: 
// Module Name: RV32I_Core
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


module RV32I_Core (
    input  logic clk,
    input  logic reset,
    input  logic [31:0] instr_code,
    input  logic [31:0] dRdata,
    output logic [31:0] instr_rAddr,
    output logic        d_wr_en,
    output logic [31:0] dAddr,
    output logic [31:0] dWdata,
    output logic [ 2:0] store_type,
    output logic [ 2:0] load_type
);
    logic [3:0] alu_controls;
    logic [2:0] RegWdataSel;
    logic reg_wr_en, aluSrcMuxSel, branch, jal, jalr;

    control_unit U_Control_Unit (.*);
    datapath U_Data_Path (.*);
endmodule
