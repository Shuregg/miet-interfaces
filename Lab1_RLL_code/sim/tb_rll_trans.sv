`timescale 1ns / 1ps

module tb_rll_trans();

  parameter LINE_LENGTH = 32;

  integer i;
  
  logic       DATA;
  logic       RST;
  logic       CLK;

  logic [3:0] RES4;
  logic [5:0] RES6;
  logic [7:0] RES8;
  logic [1:0]  VALID;
  
  logic [LINE_LENGTH-1:0] bitline = {
  4'b1100, 4'b0100, 4'b1111, 4'b0001,
  4'b0101, 4'b1101, 4'b0100, 4'b1100
  };
  
  rll_trans rll_trans_inst
  (
    .clk_i(CLK),
    .rst_i(RST),
    .data_bit_i(DATA),
    .encode8_o(RES8),
    .encode6_o(RES6),
    .encode4_o(RES4),
    .valid_o(VALID)
   );
   

   parameter PERIOD = 20;

   always begin
      #(PERIOD/2) CLK = ~CLK;
   end
   
   always begin
      CLK = 1'b0;
      #(PERIOD/2) CLK = 1'b1;
      #(PERIOD/2);
   end
  
  initial begin
    CLK = 0;
    RST = 1;
    DATA = bitline[LINE_LENGTH-1];
    //$display( "\nStart test: \n\n==========================\nCLICK THE BUTTON 'Run All'\n==========================\n"); $stop();
    @(posedge CLK);
    RST = 0;
    for(i = LINE_LENGTH-2; i >= 0; i = i - 1) begin
      DATA <= bitline[i];
      @(posedge CLK);
    end
  end
  
endmodule
