`timescale 1ns / 1ps
`include "define.sv"

module control_unit (
    input  logic [31:0] instr_code,
    output logic [ 3:0] alu_controls,
    output logic [ 2:0] store_type,
    output logic [ 2:0] load_type,
    output logic        aluSrcMuxSel,
    output logic        reg_wr_en,
    output logic        d_wr_en,
    output logic [ 2:0] RegWdataSel,
    output logic        branch,
    output logic        jal,
    output logic        jalr
);

    wire [6:0] funct7 = instr_code[31:25];
    wire [2:0] funct3 = instr_code[14:12];
    wire [6:0] opcode = instr_code[6:0];

    logic [8:0] controls;
    assign {jalr, jal, RegWdataSel[2:0], aluSrcMuxSel, reg_wr_en, d_wr_en, branch} = controls;

    always_comb begin
        case (opcode)
            // jalr, jal, RegWdataSel[2:0], aluSrcMuxSel, reg_wr_en, d_wr_en, branch
            `OP_R_TYPE:   controls = 9'b00_000_0100; // R-type
            `OP_S_TYPE:   controls = 9'b00_000_1010; // S-type
            `OP_IL_TYPE:  controls = 9'b00_001_1100; // IL-type
            `OP_IR_TYPE:  controls = 9'b00_000_1100; // IR-type
            `OP_B_TYPE:   controls = 9'b00_000_0001; // B-type
            `OP_LUI_TYPE: controls = 9'b00_010_0100; // U-type (LUI)
            `OP_AUI_TYPE: controls = 9'b00_011_0100; // U-type (AUI)
            `OP_JAL_TYPE: controls = 9'b01_100_0100; // J-type (JAL)
            `OP_JAR_TYPE: controls = 9'b11_100_0100; // I-type (JALR)
            default:      controls = 9'b00_000_0000;
        endcase
    end

    always_comb begin
        case (opcode)
            // {funct7[5], funct3[2:0]}
            `OP_R_TYPE:  alu_controls = {funct7[5], funct3}; // R-type
            `OP_S_TYPE:  alu_controls = `ADD; // S-type
            `OP_IL_TYPE: alu_controls = `ADD; // IL-type
            `OP_IR_TYPE: begin // IR-type
                if ({funct7[5], funct3} == 4'b1101)begin
                    alu_controls = {1'b1, funct3};
                end else begin
                    alu_controls = {1'b0, funct3};
                end
            end
            `OP_B_TYPE: alu_controls = {1'b0, funct3}; // B-type
            default:    alu_controls = 4'bx;
        endcase
    end

    // S-Type Control (Store Type)
    always_comb begin
        case (opcode)
            `OP_S_TYPE: begin
                case (funct3)
                    3'b000: store_type = `STB;
                    3'b001: store_type = `STH;
                    3'b010: store_type = `STW;
                    default: store_type = 3'bx;
                endcase
            end
            default: store_type = 3'bx;
        endcase
    end

    // IL-Type Control (Load Type)
    always_comb begin
        case (opcode)
            `OP_IL_TYPE: begin
                case (funct3)
                    3'b000: load_type = `LB;
                    3'b001: load_type = `LH;
                    3'b010: load_type = `LW;
                    3'b100: load_type = `LBU;
                    3'b101: load_type = `LHU;
                    default: load_type = 3'bx;
                endcase
            end
            default: load_type = 3'bx;
        endcase
    end
endmodule
