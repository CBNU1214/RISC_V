`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/06 02:45:29
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] data1, data2,
    input [3:0] ALU_control,
    output reg [31:0] ALU_result 
    );
    
    always @(*) begin
        case(ALU_control)
        4'b0000: ALU_result = data1 & data2;
        4'b0001: ALU_result = data1 | data2;
        4'b0010: ALU_result = data1 + data2;
        4'b0011: ALU_result = data1 ^ data2;
        4'b0100: ALU_result = data1 << data2;
        4'b0101: ALU_result = data1 >> data2;
        4'b0110: ALU_result = data1 - data2;
        4'b0111: ALU_result = data1 >>> data2;
        default: ALU_result = 0;
        endcase
    end
endmodule
