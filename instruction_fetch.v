`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        RIT
// Engineer:       Cody Cziesler and Nick Desaulniers
//
// Create Date:    11:28:25 04/07/2011
// Design Name:    instruction_fetch
// Module Name:    instruction_fetch
// Project Name:   Omicron
// Target Devices: Xilinx Spartan-3E
// Tool versions:
// Description:    The instruction fetch stage of the cpu pipeline
//
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Instantiated inst_mem, created PC, added mux for branch logic
// Revision 2.00 - Added assign for PC (CRC)
// Revision 3.00 - Modified the mux block
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module instruction_fetch(
    input         clk_n,
    input         rst_n,
    input  [6:0]  m_branch_addr,
    input         m_branch_en,
    output [6:0]  if_next_addr,
    output [15:0] if_curr_inst
);

reg [6:0] pc;

assign if_next_addr = pc + 1;

// Added b/c the assign won't work (reg needs always block)
always@(posedge clk_n or negedge rst_n) begin
  if(!rst_n) begin
    pc <= 7'b0;
  end else begin
    if(m_branch_en) begin
      pc <= m_branch_addr;
    end else begin
      pc <= if_next_addr;
    end
  end
end


inst_mem i_inst_mem(
  .clka(clk_n),
  .addra(pc),
  .douta(if_curr_inst)
);

endmodule
