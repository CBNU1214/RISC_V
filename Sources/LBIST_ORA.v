`timescale 1ns / 1ps

module LBIST_ORA(
    input clk,
    input nRst,
    input inst_end,
    input [11:0] random_value_1,
    input [11:0] random_value_2,
    input [31:0] mem_value,
    output P_F
);

reg [31:0] ORA_value [0:7];
reg [31:0] test_value [0:7];

reg [3:0] cnt;
integer  i;

always @(random_value_1 or random_value_2) begin
    ORA_value[0] = {{20{random_value_1[11]}}, random_value_1};
    ORA_value[1] = {{20{random_value_2[11]}}, random_value_2};
    ORA_value[2] = ORA_value[0] + ORA_value[1];
    ORA_value[3] = ORA_value[0] - ORA_value[1];
    ORA_value[4] = ORA_value[0] & ORA_value[1];
    ORA_value[5] = ORA_value[0] | ORA_value[1];
    ORA_value[6] = ORA_value[0] << 1;
    ORA_value[7] = ORA_value[1] >> 1;
end

always @(posedge clk or negedge nRst) begin
    if(!(nRst&&inst_end)) begin
        cnt <= 0;
        for(i = 0; i < 8; i = i + 1) begin
            test_value[i] = 0; 
        end
    end
    else if(inst_end) begin
        test_value[cnt] <= mem_value;
        cnt <= cnt + 1;
    end
end

assign P_F = (cnt == 8)?
             ((ORA_value[0]==test_value[0]) && (ORA_value[1]==test_value[1]) && (ORA_value[2]==test_value[2]) && (ORA_value[2]==test_value[2])
          && (ORA_value[3]==test_value[3]) && (ORA_value[4]==test_value[4]) && (ORA_value[5]==test_value[5]) && (ORA_value[6]==test_value[6]) && (ORA_value[7]==test_value[7])):0;

endmodule