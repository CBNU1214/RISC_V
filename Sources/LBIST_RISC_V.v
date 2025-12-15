`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/12 08:10:34
// Design Name: 
// Module Name: LBIST_RISC_V
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


module LBIST_RISC_V(
    input clk,
    input nRst,
    input test_start,
    output test_done,
    output P_F
    );
    
    wire TPG;
    wire PC_restart;
    wire CPU_restart;
    wire inst_end;
    wire [31:0] PC;
    wire [31:0] test_pattern;
    wire [11:0] random_value_1;
    wire [11:0] random_value_2;
    wire [31:0] test_value;
    
    LBIST_Controller LC0(.clk(clk), .nRst(nRst), .test_start(test_start),
 .TPG(TPG),
 .PC_restart(PC_restart),
 .inst_end(inst_end),
 .test_done(test_done), .CPU_restart(CPU_restart));
    
    LBIST_TPG LTPG0(.clk(clk), .nRst(nRst), .TPG(TPG), .PC(PC), .test_pattern(test_pattern), .random_value_1(random_value_1), .random_value_2(random_value_2));
    
    LBIST_ORA LORA0(
.clk(clk),
 .nRst(nRst),
 .inst_end(inst_end),
 .random_value_1(random_value_1),
 .random_value_2(random_value_2),
 .mem_value(test_value),
 .P_F
(P_F));
    
    RISC_V U0(.clk(clk), .nRst(nRst), .test_start(test_start), .PC_restart(PC_restart), .inst_end(inst_end), .test_pattern(test_pattern), .test_value(test_value), .PC(PC), .CPU_restart(CPU_restart));
    
    
endmodule
