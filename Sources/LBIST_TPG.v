`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/12 00:22:16
// Design Name: 
// Module Name: LBIST_TPG
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


module LBIST_TPG(
    input clk,
    input nRst,
    input TPG,
    input [31:0] PC,
    output [31:0] test_pattern,
    output reg [11:0] random_value_1,
    output reg [11:0] random_value_2
    );

    reg [11:0] LFSR;
    reg [1:0] cnt;
    reg [31:0] test_inst [0:15];
    
    wire feedback = LFSR[11] ^ LFSR[10] ^ LFSR[9] ^ LFSR[3];
    
    initial begin
        test_inst[2] = 32'h0020_81B3;
        test_inst[3] = 32'h4020_8233;
        test_inst[4] = 32'h0020_F2B3;
        test_inst[5] = 32'h0020_E333;
        test_inst[6] = 32'h0010_9393;
        test_inst[7] = 32'h0011_5413;
        test_inst[8] = 32'h0010_2023;
        test_inst[9] = 32'h0020_2223;
        test_inst[10] = 32'h0030_2423;
        test_inst[11] = 32'h0040_2623;
        test_inst[12] = 32'h0050_2823;
        test_inst[13] = 32'h0060_2A23;
        test_inst[14] = 32'h0070_2C23;
        test_inst[15] = 32'h0080_2E23;
    end

    always @(posedge clk or negedge nRst) begin
        if (!nRst)
            LFSR <= 12'hACE;       // 초기 seed 값
        else
            LFSR <= {LFSR[10:0], feedback};
    end
    
    always @(posedge clk or negedge nRst) begin
        if (!(nRst & TPG)) begin
            random_value_1 <= 0;
            random_value_2 <= 0;
            cnt <= 0;
        end
        else begin
            if(cnt == 2) cnt <= cnt;
            else if(cnt == 1) begin
                cnt <= 2;
                random_value_2 <= LFSR;
            end
            else begin
                cnt <= 1;
                random_value_1 <= LFSR;
            end
        end
    end
    
    always @(random_value_1 or random_value_2) begin
        test_inst[0] = {random_value_1, 20'h00093};
        test_inst[1] = {random_value_2, 20'h00113};
    end
    
    assign test_pattern = (TPG)?test_inst[PC]:0;
    
endmodule
