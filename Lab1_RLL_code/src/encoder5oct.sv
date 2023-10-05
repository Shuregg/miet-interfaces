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


module encoder5oct
  (
    input logic         clk_i,
    input logic         rst_i,
    input logic         data_i,
    
    output logic [7:0]  SR_OUT
  );

   
  parameter maxb_in     = 4;
  parameter maxb_out    = 8;
  
  logic     [maxb_in-1:0]    SR_IN;
  //logic     [maxb_out-1:0]   SR_OUT;
  
  
  integer start_delay_cnt = 0;
  integer bit_cnt         = 0;
  
  //assign data_o = SR_OUT;
  
  
  //first 4 bits condition
  always @ (posedge clk_i or posedge rst_i) begin
    if(start_delay_cnt < 4) begin
      start_delay_cnt = start_delay_cnt + 1;
      SR_IN <= {SR_IN[2:0], data_i};
      
    end else if(start_delay_cnt == 4)begin
      start_delay_cnt = 137590; //let's go
      case(SR_IN)
        4'bXX11: begin // RN NN
          if(SR_IN[3:0] == 4'b0011) begin
              SR_OUT <= {
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
          end else if(SR_IN[2:0] == 3'b011) begin
              SR_OUT <= {SR_OUT[1:0],
                SR_OUT[0],  SR_OUT[0], //N N
               ~SR_OUT[0], ~SR_OUT[0], //R N
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              bit_cnt = 0;
          end else begin
              SR_OUT <= {SR_OUT[3:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
          end
        end
          
        4'bXX10: begin // NR NN
          if(SR_IN[3:0] == 4'b0010) begin
          SR_OUT <= {
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              bit_cnt = 0;

          end else 
          if(SR_IN[2:0] == 3'b010) begin
              SR_OUT <= {SR_OUT[1:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              bit_cnt = 0;
          end else begin
            SR_OUT <= {SR_OUT[3:0],
                SR_OUT[0], ~SR_OUT[0], //N R
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              bit_cnt = 0;
          end
        end
        
        4'bX000: begin // NN NR NN
              SR_OUT <= {SR_OUT[1:0], 
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0], ~SR_OUT[0], 
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
        end
        default: begin
          //$display("\nSTART CASE DEFAULT ERROR!!!\nSR_IN=");
          $display(SR_IN);
          $display("\nbit_cnt=");
          $display(bit_cnt);
          bit_cnt = 0;
        end
    endcase
    end
  end
  
  
  //SHIFT REGISTER for buffer fill
  always @ (posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      bit_cnt = 0;
      SR_OUT <= 8'b0;
    end else if(start_delay_cnt == 137590) begin
      bit_cnt = bit_cnt + 1;
      SR_IN <= {SR_IN[2:0], data_i};
      
      case(SR_IN)
        4'bXX11: begin // RN NN
          if(bit_cnt == 2) begin
              SR_OUT <= {SR_OUT[3:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
          end else 
          if(bit_cnt == 3 && SR_IN[2:0] == 3'b011) begin
              SR_OUT <= {SR_OUT[1:0],
                SR_OUT[0],  SR_OUT[0], //N N
               ~SR_OUT[0], ~SR_OUT[0], //R N
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              bit_cnt = 0;
          end else
          if(bit_cnt == 4 && SR_IN[3:0] == 4'b0011) begin
              SR_OUT <= {
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
          end else begin
            $display("\nError in 4'bXX11!\nbit_cnt =\n");
            $display(bit_cnt);
          end  
        end
          
        4'bXX10: begin // NR NN
          if(bit_cnt == 2) begin
              SR_OUT <= {SR_OUT[3:0],
                SR_OUT[0], ~SR_OUT[0], //N R
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              bit_cnt = 0;
          end else 
          if(bit_cnt == 3 && SR_IN[2:0] == 3'b010) begin
              SR_OUT <= {SR_OUT[1:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              bit_cnt = 0;
          end else
          if(bit_cnt == 4 && SR_IN[3:0] == 4'b0010) begin
              SR_OUT <= {
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              bit_cnt = 0;
          end else begin
            $display("\nError in 4'bXX10!\nbit_cnt =\n");
            $display(bit_cnt);
          end  
        end
        
        4'bX000: begin // NN NR NN
              SR_OUT <= {SR_OUT[1:0], 
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0], ~SR_OUT[0], 
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
        end
        default: begin
          $display("\CASE DEFAULT ERROR!!!\nSR_IN=");
          $display(SR_IN);
          $display("\nbit_cnt=");
          $display(bit_cnt);
          bit_cnt = 0;
        end
    endcase
    end
  end
endmodule
