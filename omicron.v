`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        RIT
// Engineer:       Cody Cziesler, Nick Desaulniers
//
// Create Date:    10:58:44 04/07/2011
// Design Name:    Omicron
// Module Name:    omicron
// Project Name:   Pipelined CPU
// Target Devices: Xilinx Spartan-3E
// Tool versions:  Xilinx ISE Project Navigator
// Description:    This is a pipelined CPU with five stages: IF, ID, EX, M, WB
//
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Fixed a semi-colon problem
// Revision 2.00 - Added cu_branch
// Revision 3.00 - Changed name of data_path pin "id_opcode_out" (CRC)
// Revision 4.00 - Changed cu_alu_opcode width
// Revision 5.00 - Added cu_branch wire declaration, removed cu_reg_dest (CRC)
// Revision 6.00 - Added mrst_n, a master reset, which takes the rdy signal from the clk_blk and ands it with the rst_n (CRC)
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module omicron(
  input wire        rst_n,
  input wire        clk_in,
  output wire [7:0] leds
);

// Clock Signals
wire clk;    // The master clock
wire clk_n;  // An inverted master clock, used for accessing memory, ALU
//wire rdy;    // When high, the clock is steady
//wire sts;

// Control Signals
wire cu_reg_load;
wire cu_alu_sel_b;
wire [10:0] cu_alu_opcode;
wire cu_dm_wea;
wire cu_reg_data_loc;
wire [3:0] id_opcode;
wire [1:0] cu_branch;

// Reset Signals
wire mrst_n; // Master reset - takes into account the clock block rdy signal

// rdy rst_n | mrst_n
// ==================
//  0    0   |   0
//  0    1   |   0
//  1    0   |   0
//  1    1   |   1
//assign mrst_n = rdy & rst_n;
assign mrst_n = rst_n;

// Output leds
//assign leds[7:0] = 8'b0;


// Clock block
clk_blk i_clk_blk (
  .CLKIN_IN(clk_in),
  .RST_IN(!rst_n),
  .CLK0_OUT(clk),
  .CLK180_OUT(clk_n)
  //.LOCKED_OUT(rdy),
  //.STATUS_OUT(sts)
);


// Data Path
data_path i_data_path (
  .clk(clk),
  .clk_n(clk_n),
  .rst_n(mrst_n),
  .cu_reg_load(cu_reg_load),
  .cu_alu_sel_b(cu_alu_sel_b),
  .cu_alu_opcode(cu_alu_opcode),
  .cu_dm_wea(cu_dm_wea),
  .cu_reg_data_loc(cu_reg_data_loc),
  .cu_branch(cu_branch),
  .id_opcode_out(id_opcode),
  .leds(leds)
);


// Control Unit
control_unit i_control_unit (
    .clk(clk),
    .rst_n(mrst_n),
    .id_opcode(id_opcode),
    .cu_reg_load(cu_reg_load),         // RegLd
    .cu_alu_sel_b(cu_alu_sel_b),       // AluSelB
    .cu_alu_opcode(cu_alu_opcode),     // AluCtrl
    .cu_dm_wea(cu_dm_wea),             // MemWr
    .cu_reg_data_loc(cu_reg_data_loc), // AluOrMem
    .cu_branch(cu_branch)              // BrCtrl
);


endmodule
