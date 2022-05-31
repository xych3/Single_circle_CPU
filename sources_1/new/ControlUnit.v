`timescale 1ns / 1ps
module ControlUnit(
    input [31:0] inst,
    input breq,
    input brlt,
    output reg insmemRW,
    output reg regwEn,
    output reg pcsel,
    output reg asel,
    output reg bsel,
    output reg [1:0] wbsel,
    output reg [1:0] brsel,
    output reg [2:0] datarw,
    output reg [3:0] alusel
    );

    // insmemRW
    always @(inst or breq or brlt) begin
        insmemRW <= 0;
    end

    // regwEn
    always @(inst or breq or brlt) begin
        case (inst[6:0])
            7'b010_0011,
            7'b110_0011,
            7'b111_0011: regwEn <= 0;
            default: regwEn <= 1;
        endcase
    end

    // pcsel
    always @(inst or breq or brlt) begin
        case (inst[6:0])
            7'b110_0011: begin
                case (inst[14:12])
                    3'b000: begin
                        if(breq==1) pcsel <= 0;
                        else pcsel <= 1;
                    end
                    3'b001: begin
                        if(breq==0) pcsel <= 0;
                        else pcsel <= 1;
                    end
                    3'b100,
                    3'b110: begin
                        if(brlt==0 && breq==0) pcsel <= 0;
                        else pcsel <= 1;
                    end
                    3'b101,
                    3'b111: begin
                        if(brlt==1 || breq==1) pcsel <= 0;
                        else pcsel <= 1;
                    end
                endcase
            end
            7'b110_1111,
            7'b110_0111: pcsel <= 0;
            default: pcsel <= 1;
        endcase
    end

    // asel
    always @(inst or breq or brlt) begin
        case (inst[6:0])
            7'b110_0011,
            7'b110_1111,
            7'b001_0111: asel <= 0;
            default: asel <= 1;
        endcase
    end

    // bsel
    always @(inst or breq or brlt) begin
        case (inst[6:0])
            7'b011_0011: bsel <= 0;
            default: bsel <= 1;
        endcase
    end

    // wbsel
    always @(inst or breq or brlt) begin
        case (inst[6:0])
            7'b000_0011: wbsel <= 2'b00;
            7'b011_0011,
            7'b001_0011,
            7'b011_0111,
            7'b001_0111: wbsel <= 2'b01;
            7'b110_1111,
            7'b110_0111: wbsel <= 2'b10;
            default: wbsel <= 2'b11;
        endcase
    end

    // brsel
    always @(inst or breq or brlt) begin
        case (inst[6:0])
            7'b011_0011: 
                case (inst[14:12])
                    3'b010: brsel <= 2'b00;
                    3'b011: brsel <= 2'b01;
                    default: brsel <= 2'b00;
                endcase
            7'b001_0011:
                case (inst[14:12])
                    3'b010: brsel <= 2'b10;
                    3'b011: brsel <= 2'b11;
                    default: brsel <= 2'b10;
                endcase
            7'b110_0011:
                case (inst[14:12])
                    3'b110,
                    3'b111: brsel <= 2'b01;
                    default: brsel <= 2'b00;
                endcase
            default: brsel <= 2'b00;
        endcase
    end

    // datarw
    always @(inst or breq or brlt) begin
        case (inst[6:0])
            7'b000_0011:
                case (inst[14:12])
                    3'b000: datarw <= 3'b000;
                    3'b001: datarw <= 3'b001;
                    3'b010: datarw <= 3'b100;
                    3'b100: datarw <= 3'b010;
                    3'b101: datarw <= 3'b011;
                endcase
            7'b010_0011: 
                case (inst[14:12])
                    3'b000: datarw <= 3'b101;
                    3'b001: datarw <= 3'b110;
                    3'b010: datarw <= 3'b111;
                endcase
            default: datarw <= 3'b000;
        endcase
    end

    // alusel
    always @(inst or breq or brlt) begin
        case (inst[6:0])
            7'b011_0011:
                case (inst[14:12])
                    3'b000: 
                        case (inst[31:25])
                            7'b000_0000: alusel <= 4'b0000;
                            7'b010_0000: alusel <= 4'b0001;
                        endcase
                    3'b100:
                        case (inst[31:25])
                            7'b000_0000: alusel <= 4'b0010;
                        endcase
                    3'b110:
                        case (inst[31:25])
                            7'b000_0000: alusel <= 4'b0011;
                        endcase
                    3'b111:
                        case (inst[31:25])
                            7'b000_0000: alusel <= 4'b0100;
                        endcase
                    3'b001:
                        case (inst[31:25])
                            7'b000_0000: alusel <= 4'b0101;
                        endcase
                    3'b101:
                        case (inst[31:25])
                            7'b000_0000: alusel <= 4'b0111;
                            7'b010_0000: alusel <= 4'b1001;
                        endcase
                    3'b010,
                    3'b011:
                        case (inst[31:25])
                            7'b000_0000: begin 
                                if(brlt==0 && breq==0)  alusel <= 4'b1011;
                                else alusel <= 4'b1100;
                            end
                        endcase
                    default: alusel <= 4'b1111;
                endcase
            7'b001_0011:
                case (inst[14:12])
                    3'b000: alusel <= 4'b0000;
                    3'b100: alusel <= 4'b0010;
                    3'b110: alusel <= 4'b0011;
                    3'b111: alusel <= 4'b0100;
                    3'b001:
                        case (inst[31:25])
                            7'b000_0000: alusel <= 4'b0110;
                        endcase
                    3'b101:
                        case (inst[31:25])
                            7'b000_0000: alusel <= 4'b1000;
                            7'b010_0000: alusel <= 4'b1010;
                        endcase
                    3'b010,
                    3'b011: begin 
                        if(brlt==0 && breq==0)  alusel <= 4'b1011;
                        else alusel <= 4'b1100;
                    end
                    default: alusel <= 4'b1111;
                endcase
            7'b000_0011,
            7'b010_0011,
            7'b110_0011,
            7'b110_1111,
            7'b110_0111: alusel <= 4'b0000;
            7'b011_0111: alusel <= 4'b1101;
            7'b001_0111: alusel <= 4'b1110;
            default: alusel <= 4'b1111;
        endcase
    end

endmodule
