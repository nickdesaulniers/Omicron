`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        RIT
// Engineer:       Cody Cziesler, Nick Desaulniers
//
// Create Date:    10:58:44 04/07/2011
// Design Name:    data_path
// Module Name:    data_path
// Project Name:   Data Path for the Pipelined CPU
// Target Devices: Xilinx Spartan-3E
// Tool versions:  Xilinx ISE Project Navigator
// Description:    This is a pipelined data_path with five stages: IF, ID, EX, M, WB
//
// Dependencies:   n/a
//
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Removed v, c from execute block
// Revision 2.00 - Added clk_n, rst_n to memory module
// Revision 3.00 - Fixed some inputs (clk_n, rst_n) to modules (CRC)
// Revision 4.00 - Temporarily wired stages together, no pipeline; addec cu_branch (CRC)
// Revision 5.00 - Added FFs between stages, untested (CRC)
// Revision 6.00 - Modified cu_branch width, cu_alu_opcode width
// Revision 7.00 - Changed width of cu_branch input, removed m_branch_en_ff (CRC)
// Revision 8.00 - Added assign for id_opcode_out, fixes to pipeline (CRC)
//
//////////////////////////////////////////////////////////////////////////////////
module data_path(
    input wire clk,
    input wire clk_n,
    input wire rst_n,
    input wire cu_reg_load,
    input wire cu_alu_sel_b,
    input wire [10:0] cu_alu_opcode,
    input wire cu_dm_wea,
    input wire cu_reg_data_loc,
    input wire[1:0] cu_branch,
    output wire [3:0] id_opcode_out,
    output wire [7:0] leds
);

wire [6:0]  if_next_addr;
wire [15:0] if_curr_inst;
reg [6:0]   if_next_addr_ff;
reg [15:0]  if_curr_inst_ff;

wire [3:0]  id_opcode;
wire [6:0]  id_next_addr;
wire [15:0] id_register1_data;
wire [15:0] id_register2_data;
wire [6:0]  id_sign_ext_addr;
wire [2:0]  id_dest_reg_addr;
reg [3:0]   id_opcode_ff;
reg [6:0]   id_next_addr_ff;
reg [15:0]  id_register1_data_ff;
reg [15:0]  id_register2_data_ff;
reg [6:0]   id_sign_ext_addr_ff;
reg [2:0]   id_dest_reg_addr_ff;

wire [6:0]  ex_sign_ext_next_addr;
wire        ex_alu_z;
wire [15:0] ex_alu_result;
wire [15:0] ex_register2_data;
wire [2:0]  ex_reg_waddr;
reg [6:0]   ex_sign_ext_next_addr_ff;
reg         ex_alu_z_ff;
reg [15:0]  ex_alu_result_ff;
reg [15:0]  ex_register2_data_ff;
reg [2:0]   ex_reg_waddr_ff;

wire [15:0] m_alu_result;
wire [15:0] m_dm_dout;
wire [2:0]  m_reg_waddr;
wire        m_branch_en;
reg [15:0]  m_alu_result_ff;
reg [15:0]  m_dm_dout_ff;
reg [2:0]   m_reg_waddr_ff;

wire [15:0] wb_reg_wdata;
wire [2:0]  wb_reg_waddr;

// Control signals through ffs
reg         cu_reg_load_ff1;
reg         cu_reg_data_loc_ff1;
reg [1:0]   cu_branch_ff1;
reg         cu_dm_wea_ff1;
reg [10:0]  cu_alu_opcode_ff1;
reg         cu_alu_sel_b_ff1;

reg         cu_reg_load_ff2;
reg         cu_reg_data_loc_ff2;
reg [1:0]   cu_branch_ff2;
reg         cu_dm_wea_ff2;

reg         cu_reg_load_ff3;
reg         cu_reg_data_loc_ff3;

assign id_opcode_out = id_opcode_ff;

assign leds = 8'hAA;

instruction_fetch i_instruction_fetch(
  .clk_n(clk_n),
  .rst_n(rst_n),
  .m_branch_addr(ex_sign_ext_next_addr_ff),
  .m_branch_en(m_branch_en),
  .if_next_addr(if_next_addr),
  .if_curr_inst(if_curr_inst)
);

instruction_decode i_instruction_decode(
  .clk_n(clk_n),
  .if_next_addr(if_next_addr_ff),
  .if_curr_inst(if_curr_inst_ff),
  .wb_reg_wea(wb_reg_wea),
  .wb_reg_wdata(wb_reg_wdata),
  .wb_reg_waddr(wb_reg_waddr),
  .id_opcode(id_opcode),
  .id_next_addr(id_next_addr),
  .id_register1_data(id_register1_data),
  .id_register2_data(id_register2_data),
  .id_sign_ext_addr(id_sign_ext_addr),
  .id_dest_reg_addr(id_dest_reg_addr)
);

execute i_execute(
  .clk_n(clk_n),
  .rst_n(rst_n),
  .id_next_addr(id_next_addr_ff),
  .id_register1_data(id_register1_data_ff),
  .id_register2_data(id_register2_data_ff),
  .id_sign_ext_addr(id_sign_ext_addr_ff),
  .id_dest_reg_addr(id_dest_reg_addr_ff),
  .cu_alu_opcode(cu_alu_opcode_ff1),
  .cu_alu_sel_b(cu_alu_sel_b_ff1),
  .ex_sign_ext_next_addr(ex_sign_ext_next_addr),
  .ex_alu_z(ex_alu_z),
  .ex_alu_result(ex_alu_result),
  .ex_register2_data(ex_register2_data),
  .ex_reg_waddr(ex_reg_waddr)
);

memory i_memory(
  .clk_n(clk_n),
  .rst_n(rst_n),
  .ex_alu_result(ex_alu_result_ff),
  .ex_register2_data(ex_register2_data_ff),
  .ex_reg_waddr(ex_reg_waddr_ff),
  .cu_dm_wea(cu_dm_wea_ff2),
  .cu_branch(cu_branch_ff2),
  .ex_alu_z(ex_alu_z_ff),
  .m_alu_result(m_alu_result),
  .m_dm_dout(m_dm_dout),
  .m_reg_waddr(m_reg_waddr),
  .m_branch_en(m_branch_en)
);

write_back i_write_back(
  .m_alu_result(m_alu_result_ff),
  .m_dm_dout(m_dm_dout_ff),
  .m_reg_waddr(m_reg_waddr_ff),
  .cu_reg_data_loc(cu_reg_data_loc_ff3),
  .cu_reg_load(cu_reg_load_ff3),
  .wb_reg_wdata(wb_reg_wdata),
  .wb_reg_wea(wb_reg_wea),
  .wb_reg_waddr(wb_reg_waddr)
);

// IF -> ID
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    if_next_addr_ff          <= 7'b0;
    if_curr_inst_ff          <= 16'b0;
  end else begin
    if_next_addr_ff          <= if_next_addr;
    if_curr_inst_ff          <= if_curr_inst;
  end
end

// ID -> EX
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    id_opcode_ff             <= 4'b0;
    id_next_addr_ff          <= 7'b0;
    id_register1_data_ff     <= 16'b0;
    id_register2_data_ff     <= 16'b0;
    id_sign_ext_addr_ff      <= 7'b0;
    id_dest_reg_addr_ff      <= 3'b0;
    cu_reg_load_ff1          <= 1'b0;
    cu_reg_data_loc_ff1      <= 1'b0;
    cu_branch_ff1            <= 2'b0;
    cu_dm_wea_ff1            <= 1'b0;
    cu_alu_opcode_ff1        <= 11'b0;
    cu_alu_sel_b_ff1         <= 1'b0;
  end else begin
    id_opcode_ff             <= id_opcode;
    id_next_addr_ff          <= id_next_addr;
    id_register1_data_ff     <= id_register1_data;
    id_register2_data_ff     <= id_register2_data;
    id_sign_ext_addr_ff      <= id_sign_ext_addr;
    id_dest_reg_addr_ff      <= id_dest_reg_addr;
    cu_reg_load_ff1          <= cu_reg_load;
    cu_reg_data_loc_ff1      <= cu_reg_data_loc;
    cu_branch_ff1            <= cu_branch;
    cu_dm_wea_ff1            <= cu_dm_wea;
    cu_alu_opcode_ff1        <= cu_alu_opcode;
    cu_alu_sel_b_ff1         <= cu_alu_sel_b;
  end
end

// EX -> M
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    ex_sign_ext_next_addr_ff <= 7'b0;
    ex_alu_z_ff              <= 1'b0;
    ex_alu_result_ff         <= 16'b0;
    ex_register2_data_ff     <= 16'b0;
    ex_reg_waddr_ff          <= 3'b0;
    cu_reg_load_ff2          <= 1'b0;
    cu_reg_data_loc_ff2      <= 1'b0;
    cu_branch_ff2            <= 2'b0;
    cu_dm_wea_ff2            <= 1'b0;
  end else begin
    ex_sign_ext_next_addr_ff <= ex_sign_ext_next_addr;
    ex_alu_z_ff              <= ex_alu_z;
    ex_alu_result_ff         <= ex_alu_result;
    ex_register2_data_ff     <= ex_register2_data;
    ex_reg_waddr_ff          <= ex_reg_waddr;
    cu_reg_load_ff2          <= cu_reg_load_ff1;
    cu_reg_data_loc_ff2      <= cu_reg_data_loc_ff1;
    cu_branch_ff2            <= cu_branch_ff1;
    cu_dm_wea_ff2            <= cu_dm_wea_ff1;
  end
end

// M -> WB
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_alu_result_ff          <= 16'b0;
    m_dm_dout_ff             <= 16'b0;
    m_reg_waddr_ff           <= 16'b0;
    cu_reg_load_ff3          <= 1'b0;
    cu_reg_data_loc_ff3      <= 1'b0;
  end else begin
    m_alu_result_ff          <= m_alu_result;
    m_dm_dout_ff             <= m_dm_dout;
    m_reg_waddr_ff           <= m_reg_waddr;
    cu_reg_load_ff3          <= cu_reg_load_ff2;
    cu_reg_data_loc_ff3      <= cu_reg_data_loc_ff2;
  end
end

endmodule
