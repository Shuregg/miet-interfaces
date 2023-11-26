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
    IDLE    =   3'b000, 
    SHIFT   =   3'b001, 
    LATCH   =   3'b010, 
    HOLD    =   3'b011 
} State;

module SPI(
    input   logic  SCLK_i,  //Clock
    input   logic  ARST_i,   //ASyncr Reset

    input   logic  MISO_i,  //Master inpur Slave Output
    
    output  logic  MOSI_o,  //Master Output Slave Input
    output  logic  SS0_o,   //Flash
    output  logic  SS1_o,   //8-bit Shift register
    output  logic  SS2_o    //sensor
    );
    

    
    logic [7:0] tx_data;    //transmitted data
    logic [7:0] rx_data;    //received data

    logic [3:0] bit_counter;//Counter for bit receive/send

    logic [2:0] state;      //Current state
    logic [2:0] state_next; //Next State

    logic       SS0;        //Slave select (Flash)
    logic       SS1;        //Slave select (Shift register)
    logic       SS2;        //Slave select (Sensor (Hyroscope))

    always_ff @ (posedge SCLK_i or posedge ARST_i) begin
        if(RST_i) begin
            MISO_i      <=  1'b0;
            MOSI_o      <=  1'b1;

            SS0_o       <=  1'b0;
            SS1_o       <=  1'b0;
            SS2_o       <=  1'b0;

            tx_data     <=  8'b0;
            rx_data     <=  8'b0;

            bit_counter <=  4'b0;

            state       <=  IDLE;            
        end else begin
            state       <=  state_next;
        end
    end    

    always_ff @ (posedge SCLK_i or posedge ARST_i) begin// : FSM
        case(state)
            IDLE:   begin
                case({ SS2, SS1, SS0 })
                    3'b000:
                        state_next  <= IDLE;
                    3'b001: begin       //FLASH

                    end

                    3'b010: begin

                    end

                    3'b100: begin

                    end

                    default: begin
                        state_next  <= IDLE;
                    end

                endcase
            end


        endcase
    end
    
endmodule
