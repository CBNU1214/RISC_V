`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/04 22:51:35
// Design Name: 
// Module Name: RISC-V
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


module RISC_V(
    input clk,
    input nRst
    );
    
    reg [31:0] PC;
    wire PCWrite;
    
    always @(negedge clk or negedge nRst) begin
        if(!nRst)
            PC <= 0;
        else begin
            if(PCWrite)
                PC <= PC + 4;
            else 
                PC <= PC;
        end
    end
    
    wire [31:0] f_inst;
    
    inst_mem M0(.nRst(nRst), .addr(PC), .inst(f_inst));
    
    reg [31:0] IF_ID_inst;
    wire IF_ID_Write;
    
    always @(posedge clk or negedge nRst) begin
        if(!nRst)
            IF_ID_inst <= 0;
        else begin
            if(IF_ID_Write)
                IF_ID_inst <= f_inst;
            else 
                IF_ID_inst <= IF_ID_inst;
        end
    end                                                           
    // IF/ID
    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] func3;
    wire [6:0] func7;
    wire [31:0] immed;
     
    Decoder D0(.inst(IF_ID_inst), .opcode(opcode), .rd(rd), .func3(func3), .rs1(rs1), .rs2(rs2), .func7(func7), .immed(immed));
    
    wire [31:0] rs1_data, rs2_data;
    
    reg_file M1(.clk(clk), .nRst(nRst), .rs1(rs1), .rs2(rs2), .rd(MEM_WB_rd), .RegWrite(MEM_WB_RegWrite), 
                .rd_data(WB_rd_data), .rs1_data(rs1_data), .rs2_data(rs2_data));
                
    wire [3:0] ALU_control;
    wire ALU_Scr, MemWrite, MemRead, RegWrite, MemtoReg;
    
    Control C0(.opcode(opcode), .func3(func3), .func7(func7), .ALU_Scr(ALU_Scr), .MemWrite(MemWrite), 
               .MemRead(MemRead), .RegWrite(RegWrite), .MemtoReg(MemtoReg), .ALU_control(ALU_control));
    
    reg [4:0] ID_EX_rd, ID_EX_rs1, ID_EX_rs2;
    reg [3:0] ID_EX_ALU_control;
    reg [31:0] ID_EX_rs1_data, ID_EX_rs2_data, ID_EX_immed;
    reg ID_EX_ALU_Scr, ID_EX_MemWrite, ID_EX_MemRead, ID_EX_RegWrite, ID_EX_MemtoReg;
    wire Control_Mux;
    
    Hazard_detection_unit HDU0(ID_EX_MemRead, ID_EX_rd, rs1, rs2, Control_Mux, IF_ID_Write, PCWrite);
        
    always @(posedge clk or negedge nRst) begin
        if(!nRst || !Control_Mux) begin
            ID_EX_rd <= 0;
            ID_EX_rs1 <= 0;
            ID_EX_rs1_data <= 0;
            ID_EX_rs2 <= 0;
            ID_EX_rs2_data <= 0;
            ID_EX_immed <= 0;
            ID_EX_ALU_Scr <= 0;
            ID_EX_MemWrite <= 0;
            ID_EX_MemRead <= 0;
            ID_EX_RegWrite <= 0;
            ID_EX_MemtoReg <= 0;
            ID_EX_ALU_control <= 0;
        end
        else begin
            ID_EX_rd <= rd;
            ID_EX_rs1 <= rs1; 
            ID_EX_rs2 <= rs2; 
            ID_EX_rs1_data <= rs1_data;
            ID_EX_rs2_data <= rs2_data; 
            ID_EX_immed <= immed;
            ID_EX_ALU_Scr <= ALU_Scr;
            ID_EX_MemWrite <= MemWrite;
            ID_EX_MemRead <= MemRead;
            ID_EX_RegWrite <= RegWrite;
            ID_EX_MemtoReg <= MemtoReg;
            ID_EX_ALU_control <= ALU_control;
        end
    end
    // ID/EX
    wire [31:0] ALU_input_data1, ALU_input_data2, ALU_result, store_data;
    
    assign ALU_input_data1 = (EX_MEM_RegWrite && (EX_MEM_rd == ID_EX_rs1))?EX_MEM_ALU_result:
                             (MEM_WB_RegWrite && (MEM_WB_rd == ID_EX_rs1))?WB_rd_data:ID_EX_rs1_data;
    assign ALU_input_data2 = (ID_EX_ALU_Scr)?ID_EX_immed:
                             (EX_MEM_RegWrite && (EX_MEM_rd == ID_EX_rs2))?EX_MEM_ALU_result:
                             (MEM_WB_RegWrite && (MEM_WB_rd == ID_EX_rs2))?WB_rd_data:ID_EX_rs2_data;
    assign store_data = (EX_MEM_RegWrite && (EX_MEM_rd == ID_EX_rs2))?EX_MEM_ALU_result:
                         (MEM_WB_RegWrite && (MEM_WB_rd == ID_EX_rs2))?WB_rd_data:ID_EX_rs2_data;
                             
    ALU ALU0(.data1(ALU_input_data1), .data2(ALU_input_data2), .ALU_control(ID_EX_ALU_control), .ALU_result(ALU_result));
    
    reg [4:0] EX_MEM_rd;
    reg EX_MEM_MemWrite, EX_MEM_MemRead, EX_MEM_RegWrite, EX_MEM_MemtoReg;
    reg [31:0] EX_MEM_ALU_result, EX_MEM_store_data;
    
    always @(posedge clk or negedge nRst) begin
        if(!nRst) begin
            EX_MEM_rd <= 0;
            EX_MEM_MemWrite <= 0;
            EX_MEM_MemRead <= 0;
            EX_MEM_RegWrite <= 0;
            EX_MEM_MemtoReg <= 0;
            EX_MEM_ALU_result <= 0;
            EX_MEM_store_data <= 0;
        end
        else begin
            EX_MEM_rd <= ID_EX_rd;
            EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_MemRead <= ID_EX_MemRead;
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_MemtoReg <= ID_EX_MemtoReg;
            EX_MEM_ALU_result <= ALU_result;
            EX_MEM_store_data <= store_data;
        end
    end
    // EX_MEM  
    wire [31:0] Mem_Read_data;
    
    data_mem M2(.clk(clk), .MemWrite(EX_MEM_MemWrite), .MemRead(EX_MEM_MemRead), .adress(EX_MEM_ALU_result),
                .Write_data(EX_MEM_store_data), .Read_data(Mem_Read_data));
     
     reg [4:0] MEM_WB_rd;
     reg [31:0] MEM_WB_ALU_result, MEM_WB_Mem_Read_data;
     reg MEM_WB_RegWrite, MEM_WB_MemtoReg;
     
     always @(posedge clk or negedge nRst) begin
        if(!nRst) begin
            MEM_WB_rd <= 0;
            MEM_WB_ALU_result <= 0; 
            MEM_WB_Mem_Read_data <= 0;
            MEM_WB_RegWrite <= 0; 
            MEM_WB_MemtoReg <= 0;
        end
        else begin
            MEM_WB_rd <= EX_MEM_rd;
            MEM_WB_ALU_result <= EX_MEM_ALU_result; 
            MEM_WB_Mem_Read_data <= Mem_Read_data;
            MEM_WB_RegWrite <= EX_MEM_RegWrite; 
            MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
        end
     end
     //MEM_WB
     wire [31:0] WB_rd_data;
     
     assign WB_rd_data = (MEM_WB_MemtoReg)?MEM_WB_Mem_Read_data:MEM_WB_ALU_result;

endmodule
