`timescale 1ns / 1ps
module PCSel(
    input PCSel,
    input [31:0] alu,
    input [31:0] pc4,
    output wire [31:0] next_pc
    );
    assign next_pc = PCSel==1? pc4:alu;
endmodule
