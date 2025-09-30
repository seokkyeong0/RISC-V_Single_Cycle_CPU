`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/22 15:21:40
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input  logic clk,
    input  logic d_wr_en,
    input  logic [ 2:0] store_type,
    input  logic [ 2:0] load_type,
    input  logic [31:0] dAddr,
    input  logic [31:0] dWdata,
    output logic [31:0] dRdata
);

    // stack pointer (400)
    logic [31:0] data_mem [0:100];

    initial begin
        $readmemh("data.mem", data_mem);
    end

    always_comb begin
        dRdata = data_mem[dAddr[31:2]];
        case (load_type)
            3'b000: begin 
                case (dAddr[1:0])
                    2'b00: dRdata = {{24{data_mem[dAddr[31:2]][7]}}, data_mem[dAddr[31:2]][7:0]};
                    2'b01: dRdata = {{24{data_mem[dAddr[31:2]][15]}}, data_mem[dAddr[31:2]][15:8]};
                    2'b10: dRdata = {{24{data_mem[dAddr[31:2]][23]}}, data_mem[dAddr[31:2]][23:16]};
                    2'b11: dRdata = {{24{data_mem[dAddr[31:2]][31]}}, data_mem[dAddr[31:2]][31:24]};
                endcase
            end
            3'b001: begin 
                case (dAddr[1:0])
                    2'b00: dRdata = {{16{data_mem[dAddr[31:2]][15]}}, data_mem[dAddr[31:2]][15:0]};
                    2'b10: dRdata = {{16{data_mem[dAddr[31:2]][31]}}, data_mem[dAddr[31:2]][31:16]};
                endcase
            end
            3'b010: begin
                dRdata = data_mem[dAddr[31:2]][31:0];
            end
            3'b100: begin 
                case (dAddr[1:0])
                    2'b00: dRdata = {24'b0, data_mem[dAddr[31:2]][7:0]};
                    2'b01: dRdata = {24'b0, data_mem[dAddr[31:2]][15:8]};
                    2'b10: dRdata = {24'b0, data_mem[dAddr[31:2]][23:16]};
                    2'b11: dRdata = {24'b0, data_mem[dAddr[31:2]][31:24]};
                endcase
            end
            3'b101: begin 
                case (dAddr[1:0])
                    2'b00: dRdata = {16'b0, data_mem[dAddr[31:2]][15:0]};
                    2'b10: dRdata = {16'b0, data_mem[dAddr[31:2]][31:16]};
                endcase
            end
        endcase
    end

    always_ff @(posedge clk) begin
    if (d_wr_en) begin
        case (store_type)
            3'b000: begin // STB
                case (dAddr[1:0])
                    2'b00: data_mem[dAddr[31:2]][  7:0]  <= dWdata[7:0];
                    2'b01: data_mem[dAddr[31:2]][ 15:8]  <= dWdata[7:0];
                    2'b10: data_mem[dAddr[31:2]][23:16]  <= dWdata[7:0];
                    2'b11: data_mem[dAddr[31:2]][31:24]  <= dWdata[7:0];
                endcase
            end
            3'b001: begin // STH
                case (dAddr[1:0])
                    2'b00: data_mem[dAddr[31:2]][ 15:0]  <= dWdata[15:0];
                    2'b10: data_mem[dAddr[31:2]][31:16]  <= dWdata[15:0];
                endcase
            end
            3'b010: begin // STW
                data_mem[dAddr[31:2]][31:0] <= dWdata[31:0];
            end
        endcase
    end
end
endmodule
