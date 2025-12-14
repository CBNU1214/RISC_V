`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/06 00:37:02
// Design Name: 
// Module Name: Hazard_detection_unit
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


module Hazard_detection_unit(
    input ID_EX_MemRead,
    input [4:0] ID_EX_rd,
    input [4:0] rs1,
    input [4:0] rs2,
    output Control_Mux,
    output IF_ID_Write,
    output PCWrite
    );
    
    assign Control_Mux = (ID_EX_MemRead && ((ID_EX_rd == rs1) || (ID_EX_rd == rs2)))?0:1;
    assign IF_ID_Write = (ID_EX_MemRead && ((ID_EX_rd == rs1) || (ID_EX_rd == rs2)))?0:1;
    assign PCWrite = (ID_EX_MemRead && ((ID_EX_rd == rs1) || (ID_EX_rd == rs2)))?0:1;
endmodule
