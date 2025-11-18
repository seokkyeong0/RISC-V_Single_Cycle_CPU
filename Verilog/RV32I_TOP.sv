`timescale 1ns / 1ps
module RV32I_TOP (
    input logic clk,
    input logic reset,
    output logic dbg_instr,
    output logic dbg_pc,
    output logic dbg_busAddr
);
    logic [31:0] instr_code, instr_rAddr;
    logic [31:0] dAddr, dWdata, dRdata;
    logic [ 2:0] store_type, load_type;
    logic d_wr_en;

    assign dbg_instr    = instr_code[0];
    assign dbg_pc       = instr_rAddr[0];
    assign dbg_busAddr  = dAddr[0];

    RV32I_Core U_RV32I_CPU(.*);
    instr_mem U_Instr_Mem(.*);
    data_mem U_Data_Mem(.*);
endmodule
