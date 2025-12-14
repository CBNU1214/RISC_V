`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/05 05:22:54
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    input [31:0] inst,
    output reg [6:0] opcode,
    output reg [4:0] rd,
    output reg [2:0] func3,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [6:0] func7,
    output reg [31:0] immed
    );
    
    always @(*) begin
        case(inst[6:0])
        7'b0110011: begin
            rd = inst[11:7];
            rs2 = inst[24:20];
            func7 = inst[31:25];
            immed = 0;
        end
        7'b0000011: begin
            rd = inst[11:7];
            immed = {{20{inst[31]}}, inst[31:20]};
            rs2 = 0;
            func7 = 0;
        end
        7'b0100011: begin
            rs2 = inst[24:20];
            immed = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            rd = 0;
            func7 = 0;
        end
        endcase
        opcode = inst[6:0];
        func3 = inst[14:12];
        rs1 = inst[19:15];
    end    
endmodule
