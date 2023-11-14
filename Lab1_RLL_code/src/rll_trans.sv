module rll_trans
(
  input                     clk_i,
  input   logic             rst_i,
  input   logic             data_bit_i,
  
  /*
  encode8_o (8bit encode) - correct result on it if a sequence of 4 bits
  encode6_o (6bit encode) - correct result on it if a sequence of 3 bits
  encode4_o (4bit encode) - correct result on it if a sequence of 2 bits
  */
  output  logic [7:0]       encode8_o,
  output  logic [5:0]       encode6_o,
  output  logic [3:0]       encode4_o,
  
  
  /* valid_o - selector indicating the output with the correct signal 
  00 - no valid output
  01 - encode8_o
  10 - encode6_o
  11 - encode4_o */
  output  logic [1:0]       valid_o     
  
);

  logic [3:0] sh_r;

//Wires that are checked for sequence
  logic [3:0] bit_4_code;
  logic [2:0] bit_3_code;
  logic [1:0] bit_2_code;

//Connect the wires to the shift register:
  assign bit_4_code = sh_r;
  assign bit_3_code = sh_r[2:0];
  assign bit_2_code = sh_r[1:0];

  logic [2:0] to_skip;

  always_ff@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      sh_r      <= 4'b0;
      to_skip   <= 3'd4;
      //to_skip   <= 3'd0;
      valid_o   <= 2'b0;
    end else begin
      sh_r <= {data_bit_i, sh_r[3:1]}; //filling in the shift register
//    to_skip   <= 3'd4;
      if (to_skip == 2'b0) begin
        encode6_o <= 6'b0;
        encode4_o <= 4'b0;
        to_skip   <= 3'd3;
        valid_o   <= 2'd1;
        case(bit_4_code)
          4'b0011 : encode8_o <= 8'b00001000;
          4'b0010 : encode8_o <= 8'b00100100;

          default: begin
            encode8_o <= 8'b0;
            encode4_o <= 4'b0;
            to_skip   <= 3'd2;
            valid_o   <= 2'd2;
            case(bit_3_code)
              3'b000 : encode6_o <= 6'b000100;
              3'b010 : encode6_o <= 6'b100100;
              3'b011 : encode6_o <= 6'b001000;

              default: begin
                encode8_o <= 8'b0;
                encode6_o <= 6'b0;
                to_skip   <= 3'd1;
                valid_o   <= 2'd3;
                case(bit_2_code)
                  2'b10 : encode4_o <= 4'b0100;
                  2'b11 : encode4_o <= 4'b1000;
                endcase
              end
            endcase
          end
        endcase
      end else begin
        to_skip <= to_skip - 1'b1;
        valid_o <= 2'b0;
      end
    end
  end
endmodule