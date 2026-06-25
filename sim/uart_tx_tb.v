`timescale 1ns/1ps

module uart_tx_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire tx_done;
wire tx_busy;

uart_tx uut(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_done(tx_done),
    .tx_busy(tx_busy)
);

//--------------------------------------------------
// 100 MHz clock
//--------------------------------------------------
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//--------------------------------------------------
// Test sequence
//--------------------------------------------------
initial begin

    rst      = 1;
    tx_start = 0;
    data_in  = 8'b10110010;

    // Hold reset
    repeat(3) @(posedge clk);

    rst = 0;

    // Wait a couple of clocks
    repeat(2) @(posedge clk);

    // One-cycle transmit request
    tx_start = 1;
    @(posedge clk);
    tx_start = 0;

    wait(tx_done == 1);
    @(posedge clk);
    $display("✓ Transmission complete at time %0t", $time);
    $finish;

end

endmodule