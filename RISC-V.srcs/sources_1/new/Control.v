`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/05 07:09:41
// Design Name: 
// Module Name: Control
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


module Control(
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    output reg [3:0] ALU_control,
    output reg ALU_Scr,
    output reg MemWrite,
    output reg MemRead,
    output reg RegWrite,
    output reg MemtoReg
    );
    
    always @(*) begin
        if(opcode == 7'b0110011) begin
            MemWrite = 0;
            MemRead = 0;
            RegWrite = 1;
            MemtoReg = 0;
            ALU_Scr = 0;
            case(func3)
            3'b000: begin
                if(func7[6:5] == 2'b00)
                    ALU_control = 4'b0010; //add
                else
                    ALU_control = 4'b0110; //sub
            end
            3'b111: ALU_control = 4'b0000; //and
            3'b110: ALU_control = 4'b0001; //or
            3'b100: ALU_control = 4'b0011; //xor
            3'b001: ALU_control = 4'b0100; //sll
            3'b101: begin
                if(func7[6:5] == 2'b00)
                    ALU_control = 4'b0101; //srl
                else
                    ALU_control = 4'b0111; //sra
            end
            default: ALU_control = 4'bxxxx;
            endcase
        end
        else if(opcode == 7'b0000011) begin
            ALU_control = 4'b0010;
            MemWrite = 0;
            MemRead = 1;
            RegWrite = 1;
            MemtoReg = 1;
            ALU_Scr = 1;
        end
        else if(opcode == 7'b0010011) begin
            MemWrite = 0;
            MemRead = 0;
            RegWrite = 1;
            MemtoReg = 0;
            ALU_Scr = 1;
            case(func3)
            3'b000: ALU_control = 4'b0010; //add
            3'b111: ALU_control = 4'b0000; //and
            3'b110: ALU_control = 4'b0001; //or
            3'b100: ALU_control = 4'b0011; //xor
            3'b001: ALU_control = 4'b0100; //sll
            3'b101: begin
                if(func7[6:5] == 2'b00)
                    ALU_control = 4'b0101; //srl
                else
                    ALU_control = 4'b0111; //sra
            end
            default: ALU_control = 4'bxxxx;
            endcase
        end
        else begin
            MemWrite = 1;
            MemRead = 0;
            RegWrite = 0;
            MemtoReg = 0;
            ALU_Scr = 1;
            ALU_control = 4'b0010;
        end
    end                        
endmodule
