`timescale 1ns / 1ps

module encoder5oct_tb();

  parameter LINE_LENGTH = 32;

  integer i;
  
  logic       DATA;
  logic       RST;
  logic       CLK;
  logic [7:0] RES;
  
  logic [LINE_LENGTH-1:0] bitline = {
  4'b1100, 4'b0100, 4'b1111, 4'b0001,
  4'b0101, 4'b1101, 2'b01, 2'b11, 4'b1100
  };
  
  encoder5oct encoder5oct_inst
  (
    .clk_i(CLK),
    .rst_i(RST),
    .data_i(DATA),
    .SR_OUT(RES)
   );


   // Note: CLK must be defined as a reg when using this method

   parameter PERIOD = 20;

   always begin
      CLK = 1'b0;
      #(PERIOD/2) CLK = 1'b1;
      #(PERIOD/2);
   end
  
  
  initial begin
    CLK = 0;
    RST = 1;
    //$display( "\nStart test: \n\n==========================\nCLICK THE BUTTON 'Run All'\n==========================\n"); $stop();
     @(posedge CLK);
    
    RST = 0;
     @(posedge CLK);
    for(i = 0; i < LINE_LENGTH; i = i + 1) begin
      DATA <= bitline[i];
      @(posedge CLK);
    end
    
  end
endmodule
