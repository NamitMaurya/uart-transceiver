module uart_top(

    input clk,
    input rst,

    input tx_start,
    input [7:0] data_in,

    input rx,

    output tx,

    output [7:0] data_out,

    output tx_done,
    output rx_done,

    output tx_busy,
    output rx_busy,

    output framing_error
);



uart_tx uut_tx(
            .clk(clk),
            .rst(rst),
            .tx_start(tx_start),
            .data_in(data_in),
            .tx(tx),
            .tx_done(tx_done),
            .tx_busy(tx_busy)
            );

uart_rx uut_rx(
            .clk(clk),
            .rst(rst),
            .rx(rx),
            .data_out(data_out),
            .rx_done(rx_done),
            .rx_busy(rx_busy),
            .framing_error(framing_error)
            );


endmodule