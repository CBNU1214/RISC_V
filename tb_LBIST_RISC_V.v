`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/12 08:27:10
// Design Name: 
// Module Name: tb_LBIST_RISC_V
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


module tb_LBIST_RISC_V(

    );
    
    reg clk;
    reg nRst;
    reg test_start;
    wire test_done;
    wire P_F;
    
    LBIST_RISC_V T0(clk, nRst, test_start, test_done, P_F);
   
    always #5 clk = ~clk;
   
    initial begin
        clk = 0;
        nRst = 0;
        test_start = 0;
        #20
        nRst = 1;
        #20
        test_start = 1;
        #500
        test_start = 0;
        #30
        test_start = 1;
        #500
        $finish;
    end
endmodule
