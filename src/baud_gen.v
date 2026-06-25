// --------------------------------------------------
// Baud Generator
//
// Generates a single-cycle baud_tick pulse every
// DIVISOR clock cycles.
//
// Example:
// CLK_FREQ  = 100 MHz
// BAUD_RATE = 9600
// DIVISOR   = 10417
// --------------------------------------------------


module baud_gen(
        input clk,
        input rst,
        input baud_rst,
        output reg baud_tick
        );
parameter clk_freq = 100_000_000;
parameter baud_rate = 9600;

localparam divisor = clk_freq / baud_rate;
localparam width= $clog2(divisor) ;
reg [width-1:0]count ;
always@(posedge clk) begin
            if(rst) begin
                 count<=0 ;
                 baud_tick<=0 ;
            end
            else if(baud_rst) begin
                    count<=0 ;
                    baud_tick<=0 ;
            end
            else begin 
                if(count==divisor-1) begin
                        baud_tick<=1 ;
                        count<=0 ;
                end
                else begin
                    baud_tick<=0 ;
                    count<=count+1 ;
                end
           end
       
   end
endmodule
