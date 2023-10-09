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


module encoder_rll_3rd_try
  (
    input logic         clk_i,
    //input logic         ri,
    input logic  [3:0]  data_i,
    
    output logic [7:0]  data_o
  );

   
  parameter [1:0]  buff_width      = 4;
  logic     [3:0]  buffer_in;
  logic     [7:0]  buffer_out;
  integer          clock_delay_cnt = 0;
  
  //assign data_o = buffer_out;
 
  //Generate RLL code
  always_ff @(posedge clk_i) begin
    buffer_in <= data_i;
    case(buffer_in)
        4'b1111: begin // RN NN #1
          buffer_out <= {
           buffer_out[3],  buffer_out[2],
           buffer_out[1],  buffer_out[0],
          ~buffer_out[0], ~buffer_out[0],
          ~buffer_out[0], ~buffer_out[0]};

        end
        4'b0111: begin // RN NN #2
          buffer_out <= {
           buffer_out[3],  buffer_out[2],
           buffer_out[1],  buffer_out[0],
          ~buffer_out[0], ~buffer_out[0],
          ~buffer_out[0], ~buffer_out[0]};
        end
          
        4'b0110: begin // NR NN #1
          buffer_out <= {
           buffer_out[3],  buffer_out[2],
           buffer_out[1],  buffer_out[0],
           buffer_out[0], ~buffer_out[0], //N R
          ~buffer_out[0], ~buffer_out[0]};//N N
        end
        4'b1110: begin // NR NN #2
          buffer_out <= {
           buffer_out[3],  buffer_out[2],
           buffer_out[1],  buffer_out[0],
           buffer_out[0], ~buffer_out[0], //N R
          ~buffer_out[0], ~buffer_out[0]};//N N
        end
        
        4'b1011: begin // NN RN NN
          buffer_out <= {
           buffer_out[1],  buffer_out[0],
           buffer_out[0],  buffer_out[0], //N N
          ~buffer_out[0], ~buffer_out[0], //R N
          ~buffer_out[0], ~buffer_out[0]};//N N
        end
        
        4'b1010: begin // RN NR NN
          buffer_out <= {
           buffer_out[1],  buffer_out[0],
          ~buffer_out[0], ~buffer_out[0],
          ~buffer_out[0],  buffer_out[0],
           buffer_out[0],  buffer_out[0]};
        end
        
        4'b0000: begin // NN NR NN #1
          buffer_out <= {
           buffer_out[1],  buffer_out[0], 
           buffer_out[0],  buffer_out[0],
           buffer_out[0], ~buffer_out[0], 
          ~buffer_out[0], ~buffer_out[0]};
        end
        4'b1000: begin // NN NR NN #2
          buffer_out <= {
           buffer_out[1],  buffer_out[0], 
           buffer_out[0],  buffer_out[0],
           buffer_out[0], ~buffer_out[0], 
          ~buffer_out[0], ~buffer_out[0]};
        end
        
        4'b0011: begin // NN NN RN NN
          buffer_out <= {
           buffer_out[0],  buffer_out[0],
           buffer_out[0],  buffer_out[0],
          ~buffer_out[0], ~buffer_out[0],
          ~buffer_out[0], ~buffer_out[0]};
        end
          
        4'b0010: begin // NN RN NR NN
          buffer_out <= {
           buffer_out[0],  buffer_out[0],
          ~buffer_out[0], ~buffer_out[0],
          ~buffer_out[0],  buffer_out[0],
           buffer_out[0],  buffer_out[0]};
        end
        default: begin
        
        end
    endcase
  end
endmodule
