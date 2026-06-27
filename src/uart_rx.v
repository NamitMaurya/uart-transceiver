module uart_rx#
            (
                parameter clk_freq = 100_000_000,
                parameter baud_rate = 9600
            )(
            input clk,
            input rst,
            input rx,
            output reg [7:0]data_out,
            output reg rx_done,
            output reg rx_busy,
            output reg framing_error
            );
reg baud_rst ;
wire baud_tick ;
baud_gen #(
    .clk_freq(clk_freq),
    .baud_rate(baud_rate)
) uut(
            .clk(clk),
            .rst(rst),
            .baud_rst(baud_rst),
            .baud_tick(baud_tick)
            );

localparam divisor = clk_freq / baud_rate;
localparam half_divisor = divisor / 2;
localparam width= $clog2(half_divisor) ;
reg [width-1:0]sample_count;

reg [1:0]state ;
localparam IDLE=2'b00 ;
localparam START=2'b01 ;
localparam DATA=2'b10 ;
localparam STOP=2'b11 ;

reg [3:0]bit_count ;
reg [7:0]shift_reg ;


always@(posedge clk) begin
        if(rst) begin
                rx_done<=0 ;
                rx_busy<=0 ;
                framing_error<=0 ;
                baud_rst<=1 ;
                sample_count<=0;
                state<=IDLE ;
                bit_count<=0 ;
                data_out<=0 ;
                
        end
        else begin
                case(state)
                IDLE: begin
                        rx_done<=0 ;
                        rx_busy<=0 ;
                        framing_error<=0 ;
                        baud_rst<=1 ;
                        shift_reg<=0 ;
                       
                        bit_count<=0 ;
                        
                        if(rx==0) begin
                                state<= START ;
                                rx_busy<=0 ;
                                bit_count<=0 ;
                        end
                end
                START: begin
                        
                        if(sample_count==half_divisor) begin
                                  if(rx==0) begin
                                        state<=DATA ;
                                        sample_count<=0 ;
                                        rx_busy<=1 ;
                                        baud_rst<=0 ;
                                  end
                                  else begin
                                        state<=IDLE ;
                                        rx_busy<=0 ;
                                        sample_count<=0 ;
                                  end
                        end
                        else begin
                                sample_count<=sample_count+1 ;
                                baud_rst<=1 ;
                        end
                end
                DATA: begin  
                     if(baud_tick) begin
                               shift_reg<= { rx , shift_reg[7:1] } ;
                               if(bit_count==7) begin
                                        state<=STOP ;
                                        
                               end
                               bit_count<=bit_count+1 ;
                     end
               end
               STOP: begin
                    if(baud_tick) begin
                            if(rx) begin
                                    data_out<=shift_reg ;
                                    rx_done<=1 ;
                                    state<=IDLE ;
                             end
                             else begin
                                    framing_error<=1 ;
                                    state<=IDLE ;
                             end
                   end
              end
         endcase
     end
  end     

endmodule
