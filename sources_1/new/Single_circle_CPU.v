`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SYSU
// Engineer: xieych
// 
// Create Date: 2021/11/17 22:23:16
// Design Name: Single_circle_CPU
// Module Name: Single_circle_CPU
// Project Name: Single_circle_CPU
// Target Devices: RISC-V Single_circle_CPU
// Tool Versions: 1.0
// Description: Design a based on RISC-V Single circle CPU
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module Single_circle_CPU(
    input clk,                  // clk for LED_display
    input clkin_n,              // clkin not anti shake for PC
    input reset,                // reset sign
    input [2:0]SW,              // select data to LED_display
    output [7:0] LED_display,   // Seven segment nixie tube display
    output [3:0] LED_pos        // position selection
    );
    reg [31:0] pc4;             // pc+4
    reg [15:0] display_data;    // Data display LED
    reg stop;                   // If stop
    wire clkin;                  // clkin anti shake for PC
    wire pcsel;                 // select next PC
    wire InsMemRW;              // Instruction Memoty read/write
    wire regWEn;                // Register File write enable
    wire breq;                  // equal judge
    wire brlt;                  // left/right data larger judge
    wire asel;                  // select pc/rs1data
    wire bsel;                  // select rs2data/imm
    wire [1:0] brsel;           // select brunch mode
    wire [1:0] WBSel;           // select rd write data
    wire [3:0] aluSel;          // select ALU mode
    wire [2:0] datamemRW;       // Data Memory read/write
    wire [31:0] PC;             // current PC
    wire [31:0] nextPC;         // next PC
    wire [31:0] imm;            // immediate number
    wire [31:0] WB;             // Register File dataD write
    wire [31:0] rs1data;        // Data of rs1
    wire [31:0] rs2data;        // Data of rs2
    wire [31:0] aluDataA;       // ALU inputA
    wire [31:0] aluDataB;       // ALU inputB
    wire [31:0] aluRes;         // ALU result
    wire [31:0] memRes;         // Data Memory result
    wire [31:0] inst;           // current instruction


    initial begin
        display_data <= 0;
        stop <= 0;
    end


    // stop
    always @(*) begin
        if(reset) stop <= 0;
        else if(inst[6:0]==7'b111_0011) stop <= 1;
        else stop <= 0;
    end

    // data display
    always @(*) begin
        case (SW)
            3'b000: display_data <= {PC[7:0], nextPC[7:0]};
            3'b001: display_data <= {3'b000, inst[19:15], rs1data[7:0]};
            3'b010: display_data <= {3'b000, inst[24:20], rs2data[7:0]};
            3'b011: display_data <= {3'b000, inst[11:7], WB[7:0]};
            3'b100: display_data <= imm[15:0];
            3'b101: display_data <= aluRes[15:0];
            3'b110: display_data <= memRes[15:0];
            default: display_data <= 16'b0;
        endcase
    end
    // pc4
    always @(PC or stop) begin
        if(stop) pc4 = PC;
        else pc4 = PC+4;
    end


    // Model Instances
    // CLkFilter
    ClkFilter clkfilter(
        .clk(clk),              // input
        .reset(reset),          // input
        .clkin_n(clkin_n),      // input
        .clkin(clkin)           // output
    );
    // PC
    PC pc(
        .clk(clkin),            // input
        .next_pc(nextPC),       // input
        .reset(reset),          // input
        .pc(PC)                 // output
    );
    // Instruction Memoty
    InsMem insmem(
        .RW(InsMemRW),          // input
        .IAddr(PC[7:0]),        // input
        .IDataOut(inst)         // output
    );
    // Get Immediate Number
    GetImm getimm(
        .inst(inst),            // input
        .imm(imm)               // output
    );
    // Register File
    RegisterFile registerfile(
        .clk(clkin),            // input
        .reset(reset),          // input
        .wEn(regWEn),           // input
        .addrD(inst[11:7]),     // input
        .addrA(inst[19:15]),    // input
        .addrB(inst[24:20]),    // input
        .dataD(WB),             // input
        .dataA(rs1data),        // output
        .dataB(rs2data)         // output
    );
    // Branch Compare
    BranchComp branchcomp(
        .brSel(brsel),          // input
        .rs1(rs1data),          // input
        .rs2(rs2data),          // input
        .imm(imm),              // input
        .brEq(breq),            // output
        .brLt(brlt)             // output
    );
    // ASelect
    ASel A_sel(
        .asel(asel),            // input
        .dataA(PC),             // input
        .dataB(rs1data),        // input
        .res(aluDataA)          // output
    );
    // BSelect
    ASel B_sel(
        .asel(bsel),            // input
        .dataA(rs2data),        // input
        .dataB(imm),            // input
        .res(aluDataB)          // output
    );
    // ALU
    ALU alu(
        .ALUSel(aluSel),        // input
        .dataA(aluDataA),       // input
        .dataB(aluDataB),       // input
        .res(aluRes)            // output
    );
    // Data Memory
    DataMem datamem(
        .clk(clkin),            // input
        .reset(reset),          // input
        .memRW(datamemRW),      // input
        .addr(aluRes),          // input
        .dataW(rs2data),        // input
        .dataR(memRes)          // output
    );
    // WB Select
    WB wbsel(
        .WBSel(WBSel),          // input
        .alu(aluRes),           // input
        .mem(memRes),           // input
        .pc4(pc4),              // input
        .wb(WB)                 // output
    );
    // Control Unit
    ControlUnit controlunit(
        .inst(inst),            // input
        .breq(breq),            // input
        .brlt(brlt),            // input
        .insmemRW(InsMemRW),    // output
        .regwEn(regWEn),        // output
        .pcsel(pcsel),          // output
        .asel(asel),            // output
        .bsel(bsel),            // output
        .wbsel(WBSel),          // output
        .brsel(brsel),          // output
        .datarw(datamemRW),     // output
        .alusel(aluSel)         // output
    );
    // PC Select
    PCSel pcSel(
        .PCSel(pcsel),          // input
        .alu(aluRes),           // input
        .pc4(pc4),              // input
        .next_pc(nextPC)        // output
    );
    // LED Display
    Seg_LED segled(
        .clk(clk),                  // input
        .display_data(display_data),// input
        .led_pos(LED_pos),          // output
        .led_segment(LED_display)   // output
    );

endmodule
