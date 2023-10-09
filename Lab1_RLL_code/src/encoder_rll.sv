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
    //input logic         ri,
    input logic         data_i,
    
    output logic [7:0]  data_o
  );

   
  parameter [1:0]               buff_width      = 4;
  logic     [buff_width-1:0]    buffer_in;
  logic     [2*buff_width-1:0]  buffer_out;
  integer                       clock_delay_cnt = 0;
  
  assign data_o = buffer_out;
  
  //SHIFT REGISTER for buffer fill
  always @ (posedge clk_i) begin
    if(clock_delay_cnt < buff_width) begin
      clock_delay_cnt = clock_delay_cnt + 1;
      buffer_out <= 8'b0;
      buffer_in <= {buffer_in[2:0], data_i};
    end else begin
      buffer_in <= {buffer_in[2:0], data_i};
    end
    
  end
  
  //Generate RLL code
  always @ (posedge clk_i or negedge clk_i) begin
    case(buffer_in)
        4'bXX11: begin // RN NN
//          buffer_out <= {buffer_out[2*buff_width-1-buff_width:0],
//           ~buffer_out[0], ~buffer_out[0],
//           ~buffer_out[0], ~buffer_out[0]};
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
        end
          
        4'bXX10: begin // NR NN
//          buffer_out <= {buffer_out[2*buff_width-1-buff_width:0],
//            buffer_out[0], ~buffer_out[0], //N R
//           ~buffer_out[0], ~buffer_out[0]};//N N
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
        end
        
        4'bX011: begin // NN RN NN
//          buffer_out <= {buffer_out[2*buff_width-1-buff_width:0],
//            buffer_out[0],  buffer_out[0], //N N
//           ~buffer_out[0], ~buffer_out[0], //R N
//           ~buffer_out[0], ~buffer_out[0]};//N N
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
        end
        
        4'bX010: begin // RN NR NN
//          buffer_out <= {buffer_out[2*buff_width-1-buff_width:0],
//           ~buffer_out[0], ~buffer_out[0],
//           ~buffer_out[0],  buffer_out[0],
//            buffer_out[0],  buffer_out[0]};
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
        end
        
        4'bX000: begin // NN NR NN
//          buffer_out <= {buffer_out[2*buff_width-1-buff_width:0], 
//           buffer_out[0],  buffer_out[0],
//           buffer_out[0], ~buffer_out[0], 
//          ~buffer_out[0], ~buffer_out[0]};
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
        end
        
        4'b0011: begin // NN NN RN NN
//          buffer_out <= {buffer_out[2*buff_width-1-buff_width:0], 
//           buffer_out[0],  buffer_out[0],
//           buffer_out[0],  buffer_out[0],
//          ~buffer_out[0], ~buffer_out[0],
//          ~buffer_out[0], ~buffer_out[0]};
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
        end
          
        4'b0010: begin // NN RN NR NN
//          buffer_out <= {buffer_out[2*buff_width-1-buff_width:0], 
//           buffer_out[0],  buffer_out[0],
//          ~buffer_out[0], ~buffer_out[0],
//          ~buffer_out[0],  buffer_out[0],
//           buffer_out[0],  buffer_out[0]};
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0], ~buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
          buffer_out = {buffer_out[2*buff_width-1-1:0],  buffer_out[0]};
          data_o     = buffer_out[0];
        end
    endcase
  end
endmodule
