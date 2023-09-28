`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2023 23:06:30
// Design Name: 
// Module Name: encoder_rll
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


module encoder_rll
  (
    input logic         clk_i,
    input logic         rst_i,
    input logic  [3:0]  data_i,
    
    output logic [7:0] data_o
  );
  
  parameter [3:0] 
   IDLE   = 0,
   st0    = 1, 
   st1    = 2, 
   st00   = 3, 
   st01   = 4, 
   st10   = 5, 
   st11   = 6, 
   st000  = 7, 
   st001  = 8, 
   st010  = 9, 
   st011  = 10,
   st0010 = 11,
   st0011 = 12;
   
  logic     [3:0] current_state;
  
  initial current_state = IDLE;
  always @ (posedge clk_i) begin
    case(current_state)
    //TODO WITH 4 bit input check
      IDLE:
        current_state = data_i ? st1    : st0;
      
      st0:
        current_state = data_i ? st01   : st00;
      
      st1:
        current_state = data_i ? st11   : st10;
      
      st00:
        current_state = data_i ? st001  : st000;
      
      st01:
        current_state = data_i ? st011  : st010;
      
      st10: begin 
        
        current_state = data_i ? st1    : st0;              // NR NN
        
      end  
         
      st11: begin
        current_state = data_i ? st1    : st0;              // RN NN
      end  
         
      st000: begin
        current_state = data_i ? st1    : st0;              // NN NR NN
      end
      
      st001:
        current_state = data_i ? st0011 : st0010;
      
      st010: begin
        current_state = data_i ? st1    : st0;              // RN NR NN
      end
      
      st011: begin
        current_state = data_i ? st1    : st0;              // NN RN NN
      end
      
      st0010: begin
        current_state = data_i ? st1    : st0;              // NN RN NR NN
      end
      
      st0011: begin
        current_state = data_i ? st1    : st0;              // NN NN RN NN
      end
      
    endcase
  end
endmodule
