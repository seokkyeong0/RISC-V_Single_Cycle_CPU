`timescale 1ns / 1ps
module RV32I_TOP (
    input logic clk,
    input logic reset
);
    logic [31:0] instr_code, instr_rAddr;
    logic [31:0] dAddr, dWdata, dRdata;
    logic [ 2:0] store_type, load_type;
    logic d_wr_en;

    RV32I_Core U_RV32I_CPU(.*);
    instr_mem U_Instr_Mem(.*);
    data_mem U_Data_Mem(.*);
endmodule

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
