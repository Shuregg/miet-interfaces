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
  logic [7:0] DOUT;
  
  logic [buffer_width-1:0]    buffer_in [7] = {
  4'b11_11,
  4'b11_10,
  4'b1_011,
  4'b1_010,
  4'b1_000,
  4'b0010,
  4'b0011
  };
  
  logic [3:0] tmp_buff;
  integer i = 0;
  
  initial begin
  
    CLK = 0;  
    #20   
    CLK = ~CLK;
    tmp_buff = 4'b11_11;
    #20
    CLK = ~CLK;
    #20
    CLK = ~CLK;
    tmp_buff = 4'b11_10;
    
    #20   
    CLK = ~CLK;
    tmp_buff = 4'b1_011;
    #20
    CLK = ~CLK;
    #20
    CLK = ~CLK;
    tmp_buff = 4'b1_010;
    
    #20   
    CLK = ~CLK;
    tmp_buff = 4'b1_000;
    #20
    CLK = ~CLK;
    #20
    CLK = ~CLK;
    tmp_buff = 4'b0010;
    
    CLK = ~CLK;
    #20
    CLK = ~CLK;
    tmp_buff = 4'b0011;
    CLK = ~CLK;
    #20
    CLK = ~CLK;
    tmp_buff = 4'b0111;
    
  end
  
  encoder_rll encoder_rll_inst
    (
      .clk_i(CLK),
      .data_i(tmp_buff),
      .data_o(DOUT)
    );

//  always #20 CLK = ~CLK;
//  always #40 i = i + 1;

endmodule
