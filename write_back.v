`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        RIT
// Engineer:       Cody Cziesler and Nick Desaulniers
//
// Create Date:    11:50:14 04/07/2011
// Design Name:    write_back
// Module Name:    write_back
// Project Name:   omicon
// Target Devices: Xilinx Spartan-3E
// Tool versions:
// Description:    The write back stage of the pipelined cpu
//
// Revision 0.01 - File Created
// Revision 1.00 - Complete, untested
// Revision 2.00 - Renamed outputs for ID (CRC)
// Revision 3.00 - Tested (CRC)
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module write_back(
    input [15:0]  m_alu_result,
    input [15:0]  m_dm_dout,
    input [2:0]   m_reg_waddr,
    input         cu_reg_data_loc,
    input         cu_reg_load,
    output [15:0] wb_reg_wdata,
    output        wb_reg_wea,
    output [2:0]  wb_reg_waddr
);

// Mux for getting data from memory or the ALU
// if( cu_reg_data_loc )
// 	wb_reg_din <= m_dm_dout;
// else
// 	wb_reg_din <= m_alu_result;

assign wb_reg_wdata = cu_reg_data_loc ? m_dm_dout : m_alu_result;

assign wb_reg_wea = cu_reg_load;
assign wb_reg_waddr = m_reg_waddr;

endmodule
