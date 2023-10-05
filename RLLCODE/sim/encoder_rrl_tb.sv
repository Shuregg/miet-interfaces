`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2023 14:59:30
// Design Name: 
// Module Name: encoder_rrl_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module encoder_rrl_tb();

  parameter buffer_width = 4;

  logic       CLK;
  //logic       DIN;
  //logic [7:0] DOUT;
  
  logic [buffer_width-1:0]    buffer_in;
  logic [2*buffer_width-1:0]  buffer_out;
  
  initial CLK = 0;
  always #20 CLK = ~CLK;
  
  genvar i;
  generate
    for(i = 0; i < buffer_width; i = i + 1) begin
      encoder_rll encoder_rll_inst
    (
      .clk_i(CLK),
      .data_i(buffer_in[i]),
      .data_o()
    );
    end
    
  endgenerate
  
endmodule
