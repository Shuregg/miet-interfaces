`timescale 1ns / 1ps

module encoder
(
  input  logic         clk_i,
  input  logic         ari,
  input  logic         data_i,
  
  output logic [7:0]  data_o
);

parameter max_tab_in  = 4;
parameter max_tab_out = 8;

integer bit_cnt = 0;
//integer delay_cnt   = 0;

logic  [max_tab_in-1:0]  SR_IN;
logic  [max_tab_out-1:0] SR_OUT;
logic                    labit_out;

//assign data_o = SR_OUT;
//assign labit_out = data_o[7];

always_ff @(posedge clk_i or negedge ari) begin
  if(!ari) begin
    data_o      <= 8'b0;
    bit_cnt  = 0;
    //delay_cnt    = 0;
  end else begin
  
      SR_IN <= {SR_IN[2:0], data_i};
      bit_cnt = bit_cnt + 1;
      
      case(bit_cnt)
        4: begin
          case(SR_IN)
            4'b0010: begin // NN RN NR NN
              SR_OUT <= {
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              data_o <= {
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              bit_cnt = 0;
            end
            4'b0011: begin  // NN NN RN NN
              SR_OUT <= {
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
              data_o <= {
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
            end
            default: begin
              //$display("Err. bit_cnt=4");
              SR_OUT <= SR_OUT;
              data_o <= SR_OUT;
              bit_cnt = 2;
            end
          endcase
        end
        
        3: begin
          case(SR_IN[2:0]) 
            3'b000: begin // NN NR NN
              SR_OUT <= {SR_OUT[1:0], 
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0], ~SR_OUT[0], 
               ~SR_OUT[0], ~SR_OUT[0]};
              data_o <= {SR_OUT[1:0], 
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0], ~SR_OUT[0], 
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
            end
            3'b010: begin // RN NR NN
              SR_OUT <= {SR_OUT[1:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              data_o <= {SR_OUT[1:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              bit_cnt = 0;
            end
            3'b011: begin // NN RN NN
              SR_OUT <= {SR_OUT[1:0],
                SR_OUT[0],  SR_OUT[0], //N N
               ~SR_OUT[0], ~SR_OUT[0], //R N
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              data_o <= {SR_OUT[1:0],
                SR_OUT[0],  SR_OUT[0], //N N
               ~SR_OUT[0], ~SR_OUT[0], //R N
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              bit_cnt = 0;
            end
            default: begin
              SR_OUT <= SR_OUT;
              data_o <= SR_OUT;
              bit_cnt = 2;
            end
          endcase
        end
        
        2: begin
          case(SR_IN[1:0]) 
            2'b10: begin // NR NN
              SR_OUT <= {SR_OUT[3:0],
                SR_OUT[0], ~SR_OUT[0], //N R
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              data_o <= {SR_OUT[3:0],
                SR_OUT[0], ~SR_OUT[0], //N R
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              bit_cnt = 0;
            end
            2'b11: begin // RN NN
              SR_OUT <= {SR_OUT[3:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              data_o <= {SR_OUT[3:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
            end
            default: begin
              SR_OUT <= SR_OUT;
              data_o <= SR_OUT;
            end
          endcase
        end
        
        default:  begin
          SR_OUT <= SR_OUT;
          data_o <= SR_OUT;
        end
      endcase
    end
end


endmodule
