/*
 * File: alu.v
 * Module: alu
 * Authors: Cody Cziesler, Nick Desaulniers
 * Created: 3/31/11
 * Verilog HDL
 * Description: Non-pipelined 16-bit ALU
 *
 * Revision 0.01 - File Created
 * Revision 1.00 - Complete, untested
 * Revision 2.00 - Removed v, c; fixed z; fixed displays; tested w/ ModelSim (CRC)
 * Revision 3.00 - Formatting, Fixed NAND, NOR instructions (CRC)
 * Revision 4.00 - Changed up opcodes to represent finalized control logic.
 * Revision 5.00 - Reinserted ZERO (CRC)
 */

module alu(
    input wire [15:0] a,      // First operand
    input wire [15:0] b,      // Second operand
    input wire [10:0] opcode, // Opcode for ALU
    input wire        rst_n,  // Reset
    input wire        clk_n,  // Clock
    output reg [15:0] out,    // Result
    output wire       z       // Zero Flag
);

parameter NOOP  = 11'b00000000001;
parameter CPY   = 11'b00000000010;
parameter ADD   = 11'b00000000100;
parameter SUB   = 11'b00000001000;
parameter MUL   = 11'b00000010000;
parameter AND   = 11'b00000100000;
parameter OR    = 11'b00001000000;
parameter NOT   = 11'b00010000000;
parameter XOR   = 11'b00100000000;
parameter LS    = 11'b01000000000;
parameter RS    = 11'b10000000000;

// Unused but implemented
parameter ZERO  = 11'b11111111000;
parameter NOR   = 11'b11111111110;
parameter XNOR  = 11'b11111111101;
parameter NAND  = 11'b11111111011;

// Z is the nor of all of the outputs
assign z = ~(out[0]|out[1]|out[2]|out[3]|out[4]|out[5]|out[6]|out[7]|out[8]|out[9]|out[10]|out[11]|out[12]|out[13]|out[14]|out[15]);

always@(posedge clk_n or negedge rst_n) begin
  if(rst_n == 1'b0) begin
    out <= 16'b0;
  end else begin
    case(opcode)
      ZERO : begin
	$display("ZERO");
        out <= 16'b0;
      end
      CPY : begin
	$display("CPY");
	out <= a;
      end
      ADD : begin
        $display("ADD");
        out <= a + b;
        out <= a + b;
      end
      SUB : begin
        $display("SUB");
        out <= a - b;
      end
      MUL : begin
	$display("MUL");
      	out <= a * b;
      end
      AND : begin
        $display("AND");
	out <= a & b;
      end
      OR : begin
        $display("OR");
	out <= a | b;
      end
      NOT : begin
        $display("NOT");
        out <= ~a;
      end
      XOR : begin
        $display("XOR");
        out <= a ^ b;
      end
      XNOR : begin
        $display("XNOR");
        out <= a ^~ b;
      end
      NAND : begin
        $display("NAND");
        out <= ~(a & b);
      end
      NOR : begin
        $display("NOR");
        out <= ~(a | b);
      end
      LS : begin
        $display("LS");
        out <= a << b;
      end
      RS : begin
        $display("RS");
	out <= a >> b;
      end
      NOOP : begin
        $display("NOOP");
      end
      default : begin
        $display("invalid opcode");
      end
    endcase
  end
end

endmodule

