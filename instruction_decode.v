`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        RIT
// Engineer:       Cody Cziesler and Nick Desaulniers
//
// Create Date:    11:36:45 04/07/2011
// Design Name:    instruction_decode
// Module Name:    instruction_decode
// Project Name:   Omicron
// Target Devices: Xilinx Spartan-3E
// Tool versions:
// Description:    Instruction Decode stage of pipeline
//
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Added reg_block, need to fix instruction bits (CRC)
// Revision 2.00 - Fixed instruction bits (CRC)
// Revision 3.00 - Changed names on outputs from if -> id (CRC)
// Revision 4.00 - Changed wb_reg_load -> wb_reg_wea, fixed names (CRC)
// Revision 5.00 - Removed sign extend of address and changed size to 7 bits (CRC)
// Revision 6.00 - Removed id_regx_addr, added id_dest_reg_addr (CRC)
// Revision 7.00 - Changed ISA for register destination
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module instruction_decode(
    input         clk_n,
    input [6:0]   if_next_addr,
    input [15:0]  if_curr_inst,
    input         wb_reg_wea,
    input [15:0]  wb_reg_wdata,
    input [2:0]   wb_reg_waddr,
    output [3:0]  id_opcode,          // [15:12]
    output [6:0]  id_next_addr,
    output [15:0] id_register1_data,
    output [15:0] id_register2_data,
    output [6:0]  id_sign_ext_addr,   // [6:0]
    output [2:0]  id_dest_reg_addr    // [8:6]
);

assign id_next_addr = if_next_addr;
assign id_opcode = if_curr_inst[15:12];

assign id_dest_reg_addr = if_curr_inst[8:6];

assign id_sign_ext_addr = if_curr_inst[6:0];

reg_block i_reg_block(
  .clk_n(clk_n),
  .wea(wb_reg_wea),
  .raddr1(if_curr_inst[11:9]),
  .raddr2(if_curr_inst[5:3]),
  .waddr(wb_reg_waddr[2:0]),
  .wdata(wb_reg_wdata[15:0]),
  .rdata1(id_register1_data[15:0]),
  .rdata2(id_register2_data[15:0])
);

endmodule
