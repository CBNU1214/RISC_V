`timescale 1ns / 1ps

module LBIST_Controller(
    input clk,
    input nRst,
    input test_start,
    output PC_restart,
    output reg TPG,
    output CPU_restart,
    output inst_end,
    output test_done
);

reg [9:0] cnt;

always @(posedge clk or negedge nRst) begin
    if(!(nRst & test_start)) begin
        TPG <= 0;
        cnt <= 0;
    end
    else begin
        TPG <= 1;
        cnt <= cnt + 1;
    end
end

assign CPU_restart = (cnt >= 2)?1:0;
assign PC_restart = (cnt >= 3)?1:0;
assign inst_end = (cnt >= 14 && cnt <= 8'h15)?1:0;
assign test_done = (cnt == 8'h16)?1:0;

endmodule