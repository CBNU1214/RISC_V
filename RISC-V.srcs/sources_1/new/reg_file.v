`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/05 06:07:38
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input clk,
    input nRst,
    input [4:0] rs1, rs2, rd,
    input RegWrite,
    input [31:0] rd_data,
    output [31:0] rs1_data, rs2_data 
    );
    
    reg [31:0] regs [0:31];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : init_regs
            initial regs[i] = 0;
        end
    endgenerate
    
    assign rs1_data = regs[rs1];
    assign rs2_data = regs[rs2];
    
    always @(negedge clk) begin
        if(RegWrite)
            regs[rd] <= rd_data;
    end    
endmodule
