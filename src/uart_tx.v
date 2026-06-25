//==============================================================================
// UART Transmitter
// 
// Description: 
//   8-N-1 UART transmitter (8 data bits, no parity, 1 stop bit)
//   Configurable baud rate via parameters
//
// Parameters:
//   clk_freq  - System clock frequency in Hz (default: 100 MHz)
//   baud_rate - UART baud rate (default: 9600)
//
// Ports:
//   tx_start  - Pulse high for 1 cycle to begin transmission
//   data_in   - 8-bit data to transmit
//   tx        - Serial output line
//   tx_done   - Pulses high for 1 cycle when transmission complete
//   tx_busy   - High during active transmission
//==============================================================================
module uart_tx(
        input clk,
        input rst,
        input tx_start,
        input [7:0]data_in,
        output reg tx,
        output reg tx_done,
        output reg tx_busy
        );
wire baud_tick ;
reg baud_rst;
 baud_gen uut(
        .clk(clk),
        .rst(rst),
        .baud_rst(baud_rst),
        .baud_tick(baud_tick)
        );

reg [1:0]state ;
localparam IDLE=2'b00 ;
localparam START=2'b01 ;
localparam DATA=2'b10 ;
localparam STOP=2'b11 ;

reg [7:0]shift_reg ;
reg [2:0]bit_count ;

always@(posedge clk) begin
            if(rst) begin
                    state<=IDLE ;
                    bit_count<=0 ;
                    shift_reg<=0 ;
                    tx<=1 ;
                    tx_done<=0 ;
                    tx_busy<=0 ;
                    baud_rst<=1 ;
            end
            else begin
                    case(state)
                    IDLE: begin
                        tx<=1 ;
                        baud_rst<=1 ;
                        tx_busy<=0 ;
                        tx_done<=0 ;
                            if(tx_start) begin
                                    shift_reg<=data_in ;
                                    bit_count<=0 ;
                                    tx_busy<=1 ;
                                    state<=START ;
                            end
                            
                   end
                   START: begin
                        baud_rst<=0 ;
                        tx<=0 ;
                        if(baud_tick) begin
                                state<=DATA ;
                        end
                   end
                   DATA: begin
                        if(baud_tick) begin
                                tx<=shift_reg[0] ;
                                shift_reg<=shift_reg>>1 ;
                                bit_count<=bit_count+1 ;
                                
                                if(bit_count==7) begin
                                        state<=STOP ;
                                end
                        end
                        
                   end
                   STOP: begin
                        baud_rst<=0 ;
                        tx<=1 ;
                        if(baud_tick) begin
                                tx_done<=1 ;
                                state<=IDLE ;
                        end
                  end
                  default: begin
                        state<=IDLE ;
                        bit_count<=0 ;
                        shift_reg<=0 ;
                  end
             endcase
          end
       end
endmodule
