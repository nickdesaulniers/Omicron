/*
--File: 8_bit_counter.v
--Module: 8bc
--Author: Nick Desaulniers, Cody Cziesler
--Created: 3/28/11
--Verilog HDL
--Description: 8 Bit Counter
*/
module bc8( 
  output reg [7:0] leds,
  input wire clock,
  input wire reset
  );
  
  reg [25:0] state;
  
  always @( posedge clock or negedge reset ) begin
    if( reset == 1'b0 ) begin
      state <= 26'b0;
	  leds <= 8'b0;
    end else begin
      state <= state + 26'b1;
	  if(state == 26'h3FFFFFF) begin
		leds <= leds + 1'b1;
	  end
    end
  end
endmodule