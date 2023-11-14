`timescale 1ns / 1ps

module rll_receiver(
  input                     clk_i,
  input   logic             rst_i,
  input   logic [1:0]       valid_i,
  
  input   logic [7:0]       encode8_i,
  input   logic [5:0]       encode6_i,
  input   logic [3:0]       encode4_i,
  
  output  logic [3:0]       decoded4_o,
  output  logic [2:0]       decoded3_o,
  output  logic [1:0]       decoded2_o,
  
  output  logic [1:0]       valid_o
    );
    
  logic [1:0] inactive_countdown;
  logic [3:0] sh_r;
  
  always_ff @(posedge clk_i or negedge clk_i or posedge rst_i) begin
     if(rst_i) begin
       sh_r                 <= 4'b0;
       inactive_countdown   <= 4'd8;
     end 
     else begin
       
       case(valid_i)
       
         2'b00: begin //no one correct
         end
         2'b01: begin //8bits
           inactive_countdown   <= 4'd8;
           case(encode8_i)
             8'b00001000: //4'b0011
             8'b00100100: //4'b0010
             default: begin end
           endcase
         end
         2'b10: begin //6bits
           inactive_countdown   <= 4'd6;
           case(encode6_i)
             6'b000100: begin //3'b000
               
             end
             6'b100100: //3'b010
             6'b001000: //3'b011
             default: begin end
           endcase
         end
         2'b11: begin //4bits
           inactive_countdown   <= 4'd4;
           case(encode4_i)
             4'b0100: //2'b10
             4'b1000: //2'b11
             default: begin end
           endcase
         end
         default: begin end
       endcase
     end
  end
endmodule
