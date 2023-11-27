`timescale 1ns / 1ps

module spi_master
#(
    parameter sreg_width = 32,
    parameter counter_width = $clog2(sreg_width),
    parameter reset = 0, idle = 1, load = 2, transact = 3, unload = 4
)
(
    //  Controller side
    input   logic                       rstn_i,
    input   logic                       clk_i,
    input   logic                       t_start, 
    input   logic   [sreg_width-1:0]    data_i,
    input   logic   [counter_width:0]   t_size,
    output  logic   [sreg_width-1:0]    d_out,
    //  SPI Side
    input   logic                       MISO,       //Master Input Slave Output
    output  logic                       MOSI,       //Master Output Slave Input
    output  logic                       SCLK,       
    output  logic                       SS          //Slave Select
);

logic [sreg_width-1:0] mosi_d;
logic [sreg_width-1:0] miso_d;
logic [counter_width:0] count;
logic [2:0] state;

always @(state) begin
    case (state)
        reset: begin
            d_out <= 0;
            miso_d <= 0;
            mosi_d <= 0;
            count <= 0;
            SS <= 1;
        end
        idle: begin
            d_out <= d_out;
            miso_d <= 0;
            mosi_d <= 0;
            count <= 0;
            SS <= 1;
        end
        load: begin
            d_out <= d_out;
            miso_d <= 0;
            mosi_d <= data_i;
            count <= t_size;
            SS <= 0;
        end
        transact: begin
            SS <= 0;
        end
        unload: begin
            d_out <= miso_d;
            miso_d <= 0;
            mosi_d <= 0;
            count <= count;
            SS <= 0;
        end
        default: state = reset;
    endcase
end
//FSM
always @(posedge clk_i) begin
    if (!rstn_i)
        state = reset;
    else
        case (state)
            reset:
                state = idle;
            idle:
                if (t_start)
                    state = load;
            load:
                if (count != 0)
                    state = transact;
                else
                    state = reset;
            transact:
                if (count != 0)
                    state = transact;
                else
                    state = unload;
            unload:
                if (t_start)
                    state = load;
                else
                    state = idle;
        endcase
end

assign MOSI = ( ~SS ) ? mosi_d[sreg_width-1] : 1'bz;
assign SCLK = ( state == transact ) ? clk_i : 1'b0;

always @(posedge SCLK) begin
    if ( state == transact )
        miso_d <= {miso_d[sreg_width-2:0], MISO};
end

always @(negedge SCLK) begin
    if ( state == transact ) begin
        mosi_d <= {mosi_d[sreg_width-2:0], 1'b0};
        count <= count-1;
    end
end

endmodule
