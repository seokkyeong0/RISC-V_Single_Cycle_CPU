`timescale 1ns / 1ps

module instr_mem (
    input  logic [31:0] instr_rAddr,
    output logic [31:0] instr_code
);
    logic [31:0] rom [0:127];

    initial begin
        $readmemh("instruction.mem", rom);
    end

    assign instr_code = rom[instr_rAddr[31:2]];
endmodule
