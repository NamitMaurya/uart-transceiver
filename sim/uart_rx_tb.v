`timescale 1ns / 1ps

module uart_rx_tb;

reg clk;
reg rst;
reg rx;

wire [7:0] data_out;
wire rx_done;
wire rx_busy;
wire framing_error;

// Same baud rate as DUT
localparam CLK_FREQ  = 100_000_000;
localparam BAUD_RATE = 9600;   
localparam DIVISOR   = CLK_FREQ / BAUD_RATE;

uart_rx #(
    .clk_freq(CLK_FREQ),
    .baud_rate(BAUD_RATE)
) uut (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(data_out),
    .rx_done(rx_done),
    .rx_busy(rx_busy),
    .framing_error(framing_error)
);


//--------------------------------------
// Clock Generation (100 MHz)
//--------------------------------------
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


//--------------------------------------
// Send one UART bit
//--------------------------------------
task send_bit;
    input bit_value;
begin
    rx = bit_value;
    repeat(DIVISOR) @(posedge clk);
end
endtask


//--------------------------------------
// Send one UART frame
//--------------------------------------
task send_byte;
    input [7:0] data;
    integer i;
begin
    // Start bit
    send_bit(0);

    // Data bits (LSB first)
    for(i=0; i<8; i=i+1)
        send_bit(data[i]);

    // Stop bit
    send_bit(1);
end
endtask


//--------------------------------------
// Test Sequence
//--------------------------------------
initial begin

    rx = 1;     // UART idle
    rst = 1;

    repeat(3) @(posedge clk);

    rst = 0;

    repeat(2) @(posedge clk);

    // Send one byte
    send_byte(8'hB2);

    wait(rx_done == 1);
    @(posedge clk);
    $display("✓ Recieving complete at time %0t", $time);

    $finish;

end

endmodule