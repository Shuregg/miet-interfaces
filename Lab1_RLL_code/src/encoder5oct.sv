`timescale 1ns / 1ps

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
    
//  typedef enum logic [3:0] {
//    xx11v0 = 4'b0011, xx11v1 = 4'b0111, xx11v2 = 4'b1011, xx11v3 = 4'b1111,
//    xx10v0 = 4'b0010, xx10v1 = 4'b0110, xx10v2 = 4'b1010, xx10v3 = 4'b1110,
//    x000v0 = 4'b0000, x000v1 = 4'b1000} state_template;
    
//  state_tempalte state;
  

  //logic     [maxb_out-1:0]   SR_OUT;
  
  //assign state = SR_IN;
  integer start_delay_cnt = 0;
  integer bit_cnt         = 0;
//  logic [19:0] start_cnt;
//  logic [3:0]  basic_cnt;
//  assign start_cnt = start_delay_cnt;
//  assign basic_cnt = bit_cnt;
  //assign data_o = SR_OUT;
  
  
  //first 4 bits condition
  always @ (posedge clk_i) begin
    if(start_delay_cnt < 4) begin
      start_delay_cnt = start_delay_cnt + 1;
      SR_IN <= {SR_IN[2:0], data_i};
      
    end else if(start_delay_cnt == 4)begin
      start_delay_cnt = 137590; //let's go
      case(SR_IN)
      
        //0010
        4'b0010: begin
          SR_OUT <= {
                1'b0,  1'b0,
               ~1'b0, ~1'b0,
               ~1'b0,  1'b0,
                1'b0,  1'b0};
              bit_cnt = 0;
        end
        
        4'b0011: begin
          SR_OUT <= {
                1'b0,  1'b0,
                1'b0,  1'b0,
               ~1'b0, ~1'b0,
               ~1'b0, ~1'b0};
              bit_cnt = 0;
        end
        //x000
        4'b0000,
        4'b1000: begin
          SR_OUT <= {
                1'b0,  1'b0,
                1'b0,  1'b0,
                1'b0, ~1'b0, 
               ~1'b0, ~1'b0};
              bit_cnt = 0;
        end
        
        //x010
        4'b1010: begin
          SR_OUT <= {
                1'b0,  1'b0,
               ~1'b0, ~1'b0,
               ~1'b0,  1'b0,
                1'b0,  1'b0};
              bit_cnt = 0;
        end
        
        //x011
        4'b1011: begin
          SR_OUT <= {
                1'b0,  1'b0,
                1'b0,  1'b0, //N N
               ~1'b0, ~1'b0, //R N
               ~1'b0, ~1'b0};//N N
              bit_cnt = 0;
        end
        
        //xx10
        4'b0110,
        4'b1110: begin
          SR_OUT <= {
                1'b0,  1'b0,
                1'b0,  1'b0,
                1'b0, ~1'b0, //N R
               ~1'b0, ~1'b0};//N N
              bit_cnt = 0;
        end
        
        //xx11
        4'b0111,
        4'b1111: begin
          SR_OUT <= {
                1'b0,  1'b0,
                1'b0,  1'b0,
               ~1'b0, ~1'b0,
               ~1'b0, ~1'b0};
              bit_cnt = 0;
        end
        default: begin
          //$display("\nSTART CASE DEFAULT ERROR!!!\nSR_IN=");
          //$display(SR_IN);
          $display("\nDEFAULT 1st 4 bits case");
          //$display(bit_cnt);
          SR_OUT <= 8'hE9;
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
        4'b0010: begin
          if(bit_cnt == 4) begin
            SR_OUT <= {
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              bit_cnt = 0;
          end else begin
            SR_OUT <= SR_OUT;
          end
        end
        
        //0011
        4'b0011: begin
          if(bit_cnt == 4) begin
            SR_OUT <= {
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
          end else begin
            SR_OUT <= SR_OUT;
          end
        end
        //x000
        4'b0000,
        4'b1000: begin
          if(bit_cnt == 3) begin
            SR_OUT <= {SR_OUT[1:0], 
                SR_OUT[0],  SR_OUT[0],
                SR_OUT[0], ~SR_OUT[0], 
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
          end else begin
            SR_OUT <= SR_OUT;
          end
        end
        
        //x010
        4'b1010: begin
          if(bit_cnt == 3) begin
            SR_OUT <= {SR_OUT[1:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0],  SR_OUT[0],
                SR_OUT[0],  SR_OUT[0]};
              bit_cnt = 0;
          end else begin
            SR_OUT <= SR_OUT;
          end
        end
        
        //x011
        4'b1011: begin
          if(bit_cnt == 3) begin
            SR_OUT <= {SR_OUT[1:0],
                SR_OUT[0],  SR_OUT[0], //N N
               ~SR_OUT[0], ~SR_OUT[0], //R N
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              bit_cnt = 0;
          end else begin
            SR_OUT <= SR_OUT;
          end
        end
        
        //xx10
        4'b0110,
        4'b1110: begin
          if(bit_cnt == 2) begin
            SR_OUT <= {SR_OUT[3:0],
                SR_OUT[0], ~SR_OUT[0], //N R
               ~SR_OUT[0], ~SR_OUT[0]};//N N
              bit_cnt = 0;
          end else begin
            SR_OUT <= SR_OUT;
          end
        end
        
        //xx11
        4'b0111,
        4'b1111: begin
          if(bit_cnt == 2) begin
            SR_OUT <= {SR_OUT[3:0],
               ~SR_OUT[0], ~SR_OUT[0],
               ~SR_OUT[0], ~SR_OUT[0]};
              bit_cnt = 0;
          end else begin
            SR_OUT <= SR_OUT;
          end
        end
        default: begin
          $display("\CASE DEFAULT ERROR!!!\nSR_IN=");
          //$display(SR_IN);
          $display("\nbit_cnt=");
          //$display(bit_cnt);
          bit_cnt = 0;
        end
    endcase
    end
  end
endmodule
