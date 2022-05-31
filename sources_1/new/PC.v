`timescale 1ns / 1ps
module PC(
    input [31:0] next_pc,           // next pc
    input clk,                      // clock
    input reset,                    // reset pc to 0
    output reg[31:0] pc             // this pc
    );
    initial begin
        pc <= 32'h0000_0000;
    end
    always @(posedge clk or posedge reset) begin
        if(reset)
            pc <= 32'h0000_0000;
        else
            pc <= next_pc;
    end
endmodule
