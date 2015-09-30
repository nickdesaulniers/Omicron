`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        RIT
// Engineer:       Cody Cziesler and Nick Desaulniers
//
// Create Date:    3:03 04/17/2011
// Design Name:    reg_block
// Module Name:    reg_block
// Project Name:   Omicron
// Target Devices: Xilinx Spartan-3E
// Tool versions:
// Description:    The register block for the instruction decode
//
// Revision 0.01 - File Created, Tested, Works great (CRC)
// Revision 1.00 - Changed the number of registers, untested (CRC)
// Revision 2.00 - Changed size of raddr1, raddr2, waddr (CRC)
// Revision 3.00 - Added check for register $0 (CRC)
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module reg_block(
  input [2:0] raddr1,
  input [2:0] raddr2,
  input [2:0] waddr,
  input [15:0] wdata,
  input clk_n,
  input wea,
  output [15:0] rdata1,
  output [15:0] rdata2
);

// 16 bits wide, 2^3 bits deep register file
// {$0,$A,$B,$C,$D,$E,$F,$G}
reg [15:0] registers [7:0];

// Reads are combinational
assign rdata1 = registers[raddr1];
assign rdata2 = registers[raddr2];

// Writes only happen when wea is high and rising edge of clock
always@(posedge clk_n) begin
  if(wea) begin
    registers[3'b0] <= 16'b0;
    if(waddr != 3'b0) begin
      registers[waddr] <= wdata;
    end
  end
end

endmodule

