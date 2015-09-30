`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        RIT
// Engineer:       Cody Cziesler and Nick Desaulniers
//
// Create Date:    11:47:57 04/07/2011
// Design Name:    memory
// Module Name:    memory
// Project Name:   omicron
// Target Devices: Xilinx Spartan-3E
// Tool versions:  ISE M.70d
// Description:    The memory stage of the pipeline
//
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Instantiated data memory, no branch control logic, untested
// Revision 2.00 - Added cu_branch, implemented m_branch_en (CRC)
// Revision 3.00 - Modified branch control decoding (NAD)
// Revision 4.00 - Fixed typo, spacing (CRC)
// Revision 5.00 - Changed size of cu_branch input (CRC)
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module memory(
  input         clk_n,
  input         rst_n,
  input [15:0]  ex_alu_result,
  input [15:0]  ex_register2_data,
  input [2:0]   ex_reg_waddr,
  input         cu_dm_wea,
  input [1:0]   cu_branch,
  input         ex_alu_z,
  output [15:0] m_alu_result,
  output [15:0] m_dm_dout,
  output [2:0]  m_reg_waddr,
  output reg    m_branch_en
);

// Branch Parameters
parameter DBR = 2'b00; // Don't Branch
parameter BEQ = 2'b01;
parameter BNE = 2'b10;
parameter JMP = 2'b11;

assign m_alu_result = ex_alu_result;
assign m_reg_waddr  = ex_reg_waddr;

// Branch Control Decoding
// m_branch_en should be 1 if branching or jumping
always@( posedge clk_n or negedge rst_n ) begin
  if( rst_n == 1'b0 ) begin
    m_branch_en <= 1'b0;
  end else begin
    case( cu_branch )
    DBR: begin // Don't Branch
      m_branch_en <= 1'b0;
    end
    BEQ: begin
      if( ex_alu_z == 1'b1 ) begin // BEQ && No Difference = 1
        m_branch_en <= 1'b1;
      end else begin               // BEQ &&    Difference = 0
        m_branch_en <= 1'b0;
      end
    end
    BNE: begin
      if( ex_alu_z == 1'b1 ) begin // BNE && No Difference = 0
        m_branch_en <= 1'b0;
      end else begin               // BNE &&    Difference = 1
        m_branch_en <= 1'b1;
      end
    end
    JMP: begin                     // Jump (Always Branch)
      m_branch_en <= 1'b1;
    end
    endcase
  end
end

data_mem i_data_mem (
  .clka(clk_n),
  .rsta(1'b0),
  .wea(cu_dm_wea),
  .addra(ex_alu_result[6:0]),
  .dina(ex_register2_data),
  .douta(m_dm_dout[15:0])
);

endmodule
