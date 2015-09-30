`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        RIT
// Engineer:       Cody Cziesler, Nick Desaulniers
//
// Create Date:    11:44:01 04/07/2011
// Design Name:    execute
// Module Name:    execute
// Project Name:   omicron
// Target Devices: Xilinx Spartan-3E
// Tool versions:
// Description:    Execute stage of pipelined cpu
//
// Revision 0.01 - File Created
// Revision 1.00 - Complete, untested
// Revision 2.00 - Fixed b, removed v and c from alu, tested w/ ModelSim
// Revision 3.00 - Fixed spacing, header (CRC)
// Revision 4.00 - Modified cu_alu_opcode width
// Revision 5.00 - Removed cu_reg_dest and logic for ex_reg_waddr (CRC)
//
//////////////////////////////////////////////////////////////////////////////////
module execute(
    input         clk_n,
    input         rst_n,
    input [6:0]   id_next_addr,
    input [15:0]  id_register1_data,
    input [15:0]  id_register2_data,
    input [6:0]   id_sign_ext_addr,
    input [2:0]   id_dest_reg_addr,
    input [10:0]  cu_alu_opcode,
    input         cu_alu_sel_b,
    output [6:0]  ex_sign_ext_next_addr,
    output        ex_alu_z,
    output [15:0] ex_alu_result,
    output [15:0] ex_register2_data,
    output [2:0]  ex_reg_waddr
);

wire [15:0] b;

// Mux for second operand
// if( cu_alu_sel_b ){
// 	b <= id_sign_ext_addr;
// }else{
// 	b <= id_register2_data;
// }
assign b = cu_alu_sel_b ? id_sign_ext_addr : id_register2_data;

assign ex_reg_waddr = id_dest_reg_addr;

assign ex_sign_ext_next_addr = id_next_addr + id_sign_ext_addr;
assign ex_register2_data = id_register2_data;


alu i_alu(
    .a(id_register1_data),
    .b(b),
    .opcode(cu_alu_opcode),
    .rst_n(rst_n),
    .clk_n(clk_n),
    .out(ex_alu_result),
    .z(ex_alu_z)
);

endmodule
