`timescale 1ns / 1ps

module uart_top_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire tx_wire;

wire [7:0] data_out;
wire tx_done;
wire rx_done;
wire tx_busy;
wire rx_busy;
wire framing_error;


//-------------------------------------
// Instantiate Top Module
//-------------------------------------
uart_top uut(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),

    .tx(tx_wire),
    .rx(tx_wire),          // Loopback connection

    .data_out(data_out),

    .tx_done(tx_done),
    .rx_done(rx_done),

    .tx_busy(tx_busy),
    .rx_busy(rx_busy),

    .framing_error(framing_error)
);


//-------------------------------------
// Clock Generation (100 MHz)
//-------------------------------------
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


//-------------------------------------
// Test Sequence
//-------------------------------------
initial begin

    rst = 1;
    tx_start = 0;
    data_in = 8'h00;

    repeat(3) @(posedge clk);

    rst = 0;

    repeat(2) @(posedge clk);

    // Send one byte
    data_in = 8'hB2;
    tx_start = 1;

    @(posedge clk);
    tx_start = 0;

    // Wait long enough for transmission and reception
    wait(rx_done==1) ;

    $finish;

end

endmodule