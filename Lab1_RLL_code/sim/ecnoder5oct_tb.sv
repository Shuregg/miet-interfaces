`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2023 19:29:52
// Design Name: 
// Module Name: encoder_tb
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

module encoder5oct_tb();

  parameter LINE_LENGTH = 32;

  integer i;
  
  logic       DATA;
  logic       RST;
  logic       CLK;
  logic [7:0] RES;
  
  logic [LINE_LENGTH-1:0] bitline = {
  4'b0011, 4'b0010, 4'b1111, 4'b1000,
  4'b1010, 4'b1011, 2'b10, 2'b11, 4'b0110
  };
  
  encoder5oct encoder5oct_inst
  (
    .clk_i(CLK),
    .rst_i(RST),
    .data_i(DATA),
    .SR_OUT(RES)
   );
  
  initial begin
    CLK = 0;
    RST = 0;
    //$display( "\nStart test: \n\n==========================\nCLICK THE BUTTON 'Run All'\n==========================\n"); $stop();
    #20
    for(i = 1; i < LINE_LENGTH; i = i + 1) begin
      CLK = ~CLK;
      DATA = bitline[i];
      #20;
    end
    
  end
endmodule
