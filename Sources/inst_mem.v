`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/05 04:28:15
// Design Name: 
// Module Name: inst_mem
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


module inst_mem(
    input nRst,
    input [31:0] addr,
    output reg [31:0] inst
    );
    
    reg [7:0] memory [0:127];
    
    initial begin
        $readmemh("inst_mem.mem", memory);
    end
    
    always @(*) begin
        if(!nRst)
            inst = 0;
        else 
            inst = {memory[addr[6:0] + 3], memory[addr[6:0] + 2], memory[addr[6:0] + 1], memory[addr[6:0] + 0]};
    end
    
endmodule
