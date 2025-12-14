`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/06 05:09:01
// Design Name: 
// Module Name: tb_RISC_V
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


module tb_RISC_V(

    );
    
    reg clk;
    reg nRst;
    
    RISC_V U0(.clk(clk), .nRst(nRst));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        nRst = 0;
        #12
        nRst = 1;
        #100
        $finish;
    end
endmodule
