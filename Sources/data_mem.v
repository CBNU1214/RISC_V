`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/06 03:19:55
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
    input clk,
    input MemWrite, MemRead,
    input [31:0] adress,
    input [31:0] Write_data,
    input inst_end,
    output [31:0] test_value,
    output [31:0] Read_data
    );
    
    reg [7:0] memory [0:127];
    reg [7:0] cnt;
    
    initial begin
        $readmemh("data_mem.mem", memory);
    end
    
    always @(negedge clk) begin
        if(MemWrite) begin
            memory[adress[6:0]] <= Write_data[7:0];
            memory[adress[6:0] + 1] <= Write_data[15:8];
            memory[adress[6:0] + 2] <= Write_data[23:16];
            memory[adress[6:0] + 3] <= Write_data[31:24];
        end
    end
    
    always @(posedge clk) begin
        if(inst_end) begin
            if(cnt == 28) cnt <= cnt;
            else cnt <= cnt + 4;
        end
        else cnt <= 0;
    end
    
    assign Read_data = (MemRead)?{memory[adress[6:0] + 3], memory[adress[6:0] + 2], memory[adress[6:0] + 1], memory[adress[6:0] + 0]}:0;
    assign test_value = {memory[cnt + 3], memory[cnt + 2], memory[cnt + 1], memory[cnt + 0]};
    
endmodule
