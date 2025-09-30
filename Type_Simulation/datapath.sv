`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/22 10:50:37
// Design Name: 
// Module Name: datapath
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

`include "define.sv"

module datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instr_code,
    input  logic [ 3:0] alu_controls,
    input  logic        reg_wr_en,
    input  logic        aluSrcMuxSel,
    input  logic [ 2:0] RegWdataSel,
    input  logic        branch,
    input  logic        jal,
    input  logic        jalr,
    input  logic [31:0] dRdata,
    output logic [31:0] instr_rAddr,
    output logic [31:0] dAddr,
    output logic [31:0] dWdata
);

    logic [31:0] w_regfile_rd1, w_regfile_rd2, w_alu_result;
    logic [31:0] w_imm_Ext, w_aluSrcMux_out, w_RegWdataout, w_pc_MuxOut, w_pc_Next;
    logic [31:0] w_aui_jalr_result, w_jalr_result;
    logic pc_MuxSel, b_taken;

    assign dAddr = w_alu_result;
    assign dWdata = w_regfile_rd2;
    assign pc_MuxSel = jal | (branch & b_taken);

    mux_2x1 U_JALR_Mux(
        .sel(jalr),
        .x0(instr_rAddr),   
        .x1(w_regfile_rd1),       
        .y(w_jalr_result)
    );
    
    mux_2x1 U_PC_MUX (
        .sel(pc_MuxSel),
        .x0(w_pc_Next),
        .x1(w_aui_jalr_result),
        .y(w_pc_MuxOut)
    );

    adder U_PC_ADDER(
        .a   (32'd4),
        .b   (instr_rAddr),
        .sum (w_pc_Next)
    );

    adder U_AJ_ADDER(
        .a   (w_imm_Ext),
        .b   (w_jalr_result),
        .sum (w_aui_jalr_result)
    );

    program_counter U_PC (
        .clk        (clk),
        .reset      (reset),
        .pc_Next    (w_pc_MuxOut),
        .pc         (instr_rAddr)
    );

    register_file U_REG_FILE (
        .clk         (clk),
        .RA1         (instr_code[19:15]),  // read address 1
        .RA2         (instr_code[24:20]),  // read address 2
        .WA          (instr_code[11:7]),   // write address
        .reg_wr_en   (reg_wr_en),          // write enable
        .WData       (w_RegWdataout),      // write data
        .RD1         (w_regfile_rd1),      // read data 1
        .RD2         (w_regfile_rd2)       // read data 2
    );

    mux_5x1 U_RegWdataMux (
        .sel(RegWdataSel),
        .x0(w_alu_result),  
        .x1(dRdata),        
        .x2(w_imm_Ext),      
        .x3(w_aui_jalr_result),
        .x4(w_pc_Next),
        .y(w_RegWdataout)
    );

    ALU U_ALU (
        .a(w_regfile_rd1),
        .b(w_aluSrcMux_out),
        .alu_controls(alu_controls),
        .alu_result(w_alu_result),
        .b_taken(b_taken)
    );

    mux_2x1 U_AluSrcMux(
        .sel(aluSrcMuxSel),
        .x0(w_regfile_rd2),   // 0 : regFile R2
        .x1(w_imm_Ext),       // 1 : imm [31:0]
        .y(w_aluSrcMux_out)   // to ALU R2
    );

    extend U_Extend (
        .instr_code(instr_code),
        .imm_Ext(w_imm_Ext)
    );

endmodule

module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] pc_Next,
    output logic [31:0] pc
);
    register U_PC_REG (
        .clk(clk),
        .reset(reset),
        .d(pc_Next),
        .q(pc)
    );
endmodule

module register (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] d,
    output logic [31:0] q
);

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule

module register_file (
    input  logic        clk,
    input  logic [ 4:0] RA1,           // read address 1
    input  logic [ 4:0] RA2,           // read address 2
    input  logic [ 4:0] WA,            // write address
    input  logic        reg_wr_en,     // write enable
    input  logic [31:0] WData,         // write data
    output logic [31:0] RD1,           // read data 1
    output logic [31:0] RD2            // read data 2
);

    logic [31:0] reg_file [0:31];  // 32bit 32개.

    initial begin
        reg_file[0]  = 32'd0;

        // R-type Reg
        reg_file[1]  = 32'd3;
        reg_file[2]  = 32'd5;

        reg_file[3]  = 32'd0;
        reg_file[4]  = 32'd1;

        reg_file[5]  = 32'd8;
        reg_file[6]  = 32'd2;

        reg_file[7]  = 32'd8;
        reg_file[8]  = 32'd2;

        reg_file[9]  = 32'hfffffff0;
        reg_file[10] = 32'd4;

        reg_file[11] = 32'd4294967295;
        reg_file[12] = 32'd1;

        reg_file[13] = 32'd4294967295;
        reg_file[14] = 32'd1;

        reg_file[15] = 32'd6;
        reg_file[16] = 32'd3;

        reg_file[17] = 32'd6;
        reg_file[18] = 32'd3;

        reg_file[19] = 32'd6;
        reg_file[20] = 32'd3;

        reg_file[21] = 32'd0;

        // Store Reg
        reg_file[22] = 32'd4;
        reg_file[23] = 32'd8;
        reg_file[24] = 32'd12;
        reg_file[25] = 32'h12345678;

        // Load Reg
        reg_file[26] = 32'd26;
        reg_file[27] = 32'd27;
        reg_file[28] = 32'd28;
        reg_file[29] = 32'd29;
        reg_file[30] = 32'd30;
        reg_file[31] = 32'd31;
    end

    always_ff @(posedge clk) begin
        if (reg_wr_en) begin
            reg_file[WA] <= WData;
        end
    end

    // register address = 0 is zero to return
    assign RD1 = (RA1 != 0) ? reg_file[RA1] : 0;
    assign RD2 = (RA2 != 0) ? reg_file[RA2] : 0;

endmodule

module ALU (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [ 3:0] alu_controls,
    output logic [31:0] alu_result,
    output logic        b_taken
);
    
    // calculation
    always_comb begin
        case (alu_controls)
            `ADD:    alu_result = a + b;
            `SUB:    alu_result = a - b;
            `SLL:    alu_result = a << b[4:0];
            `SRL:    alu_result = a >> b[4:0];
            `SRA:    alu_result = $signed(a) >>> b[4:0];
            `SLT:    alu_result = ($signed(a) < $signed(b)) ? 1 : 0;
            `SLTU:   alu_result = (a < b) ? 1 : 0;
            `XOR:    alu_result = a ^ b;
            `OR :    alu_result = a | b;
            `AND:    alu_result = a & b;
            default: alu_result = 32'bx;
        endcase
    end

    // branch
    always_comb begin
        case (alu_controls[2:0])
            `BEQ:  b_taken = ($signed(a) == $signed(b)) ? 1 : 0;
            `BNE:  b_taken = ($signed(a) != $signed(b)) ? 1 : 0;
            `BLT:  b_taken = ($signed(a) <  $signed(b)) ? 1 : 0;
            `BGE:  b_taken = ($signed(a) >= $signed(b)) ? 1 : 0;
            `BLTU: b_taken = (a <  b) ? 1 : 0;
            `BGEU: b_taken = (a >= b) ? 1 : 0;
            default: b_taken = 1'b0;
        endcase
    end
endmodule

module extend (
    input  logic [31:0] instr_code,
    output logic [31:0] imm_Ext   
);

    wire [6:0] opcode = instr_code[6:0];
    wire [2:0] funct3 = instr_code[14:12];

    always_comb begin
        case (opcode)
            `OP_R_TYPE:   imm_Ext = 32'bx;
            `OP_S_TYPE:   imm_Ext = {{20{instr_code[31]}}, instr_code[31:25], instr_code[11:7]};
            `OP_IL_TYPE:  imm_Ext = {{20{instr_code[31]}}, instr_code[31:20]};
            `OP_IR_TYPE:  imm_Ext = {{20{instr_code[31]}}, instr_code[31:20]};
            `OP_B_TYPE:   imm_Ext = {{20{instr_code[31]}}, instr_code[7], instr_code[30:25], instr_code[11:8], 1'b0};
            `OP_LUI_TYPE: imm_Ext = {instr_code[31:12], {12{instr_code[31]}}};
            `OP_AUI_TYPE: imm_Ext = {instr_code[31:12], {12{instr_code[31]}}};
            `OP_JAL_TYPE: imm_Ext = {{12{instr_code[31]}}, instr_code[19:12], instr_code[20], instr_code[30:21], 1'b0};
            `OP_JAR_TYPE: imm_Ext = {{20{instr_code[31]}}, instr_code[31:20]};
            default: imm_Ext = 32'bx;
        endcase
    end    
endmodule

module mux_2x1 (
    input  logic        sel,
    input  logic [31:0] x0,   // 0 : regFile R2
    input  logic [31:0] x1,   // 1 : imm [31:0]
    output logic [31:0] y     // to ALU R2
);
    assign y = (sel) ? x1 : x0;
endmodule

module mux_5x1 (
    input  logic [ 2:0] sel,
    input  logic [31:0] x0,   
    input  logic [31:0] x1,
    input  logic [31:0] x2,
    input  logic [31:0] x3,
    input  logic [31:0] x4,   
    output logic [31:0] y     
);
    always_comb begin
        case (sel)
            3'b000: y = x0;
            3'b001: y = x1;
            3'b010: y = x2;
            3'b011: y = x3;
            3'b100: y = x4;
            default: y = 32'bx; 
        endcase
    end
endmodule

module adder (
    input  logic [31:0] a   ,
    input  logic [31:0] b   ,
    output logic [31:0] sum 
);
    assign sum = a + b;
endmodule