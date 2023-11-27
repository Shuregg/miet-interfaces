`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2023 21:28:33
// Design Name: 
// Module Name: SPI
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

/*
1.	��������� ����������� ����� �������������� ��������� �� ����� ������������� ���������.
2.	����������� ��������� �� ����� Verilog, �������� �������� ������� (I?C/SPI), ��� ������������� IP-core, ��������� ��������� � ������� �������.
3.	��������� �������, ��������� � ��������, - �������� test bench ��� ���������� �������?� ��������� ������ �������� ���������� � ��������� ������ ������� ���������.
 ����������, ����������� � ��������/flash, ����� ���� ������������, �� ������ ��������������� ��������� ��������, ���������� � ����������� ������������.

������� � 2. SPI.
������������ ������: Flash-������ W25Q16, 7-���������� ��-�������, ��������� ������� 74HC595, ������ MPU6000.
������� ��� test bench:
1.	������� 4 ����� ������ �� Flash-������ W25Q16.
2.	������� ���������� ������ �� ������ 7-���������� ������-�����, ������������ ����� ��������� �������� 74HC595.
3.	�������� ������ � Flash-������ W25Q16 �� ������ ������-���� ������.
4.	������� ������ �� Flash-������ W25Q16 �� ������ ������-���� ������, ��������� ������� Fast Read.
5.	������� ���������� ������ �� 7-���������� ����������.
6.	������� ������ �� MPU6000 �� ������� 114-117.
7.	������� ���������� ������ �� 7-���������� ����������.
���������� 7-���������� ���������� �� ���������������� �����, ��������� ���������� - �� ������������ �����.
*/

/*
1. Read 8 Bytes from Flash
2. Display this data to 8 HEXs
3. Write data ti Flash using any free address
4. Read data from flash using Fast Read and any address
5. Display to HEX
6. Read data from sensor;
7.Display to HEX
*/

// MODE: CPOL = 0, CPHA = 0.

typedef enum logic 
{
    RESET       =   3'b000
    IDLE        =   3'b001, 
    SHIFT       =   3'b010, 
    LOAD        =   3'b011,
    UNLOAD      =   3'b100
} State;


module SPI(
    //SPI Interface
    input   logic           SCLK_i,  //Clock
    input   logic           MISO_i,  //Master inpur Slave Output
    output  logic   [1:0]   SS_o,      //Slave Select
    output  logic           MOSI_o,  //Master Output Slave Input

    //Controller Interface
    input   logic           clk_i,
    input   logic           rst_i,  //Syncr Reset
    input   logic           transaction_started_i,
    input   logic           transaction_size_i
    // input   logic   [1:0]   slave_select_i, 
    // input   
    );
    
    State state, state_next;
    
    logic [7:0] tx_data;    //transmitted data
    logic [7:0] rx_data;    //received data

    logic [9:0] bit_counter;//Counter for bit receive/send

    logic [2:0] state;      //Current state
    // logic [2:0] state_next; //Next State

    logic       SS0;        //Slave select (Flash)
    logic       SS1;        //Slave select (Shift register)
    logic       SS2;        //Slave select (Sensor (Hyroscope))

    always_ff @ (posedge clk_i) begin
        if(rst_i) begin
            state       <=  RESET;            
        end else begin
            case(state)
                RESET:
                    state   =   IDLE;
                IDLE:
                    case(transaction_started_i)
                        1'b0:   state   =   IDLE;
                        1'b1:   state   =   SHIFT;
                    endcase
                SHIFT:

                LOAD:

                UNLOAD:

            endcase
            
        end
    end    

    always_comb begin// : FSM
        case(state)
            RESET:  begin
                MISO_i      <=  1'b0;
                MOSI_o      <=  1'b1;
                tx_data     <=  8'b0;
                rx_data     <=  8'b0;
                bit_counter <=  10'b0;
            end
            IDLE:   begin
                case(SS)
                    2'b00:
                        state_next  <= IDLE;
                    2'b00: begin       //FLASH

                    end

                    2'b00: begin

                    end

                    2'b00: begin

                    end

                    default: begin
                        state_next  <= IDLE;
                    end

                endcase
            end

        endcase
    end
    
endmodule
