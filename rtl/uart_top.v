module uart_top #(parameter CLK_FREQ  = 50_000_000,parameter BAUD_RATE = 115_200)(clk,rst_n,tx_data,tx_start,tx_busy,rx_data,rx_valid,rx,tx);
    input  wire clk,rst_n;
    input  wire [7:0] tx_data;
    input  wire tx_start;
    output wire tx_busy;
    output wire [7:0] rx_data;
    output wire rx_valid;
    input  wire rx;
    output wire tx;
    wire baud_tick;
baud_gen #(.CLK_FREQ(CLK_FREQ),.BAUD_RATE(BAUD_RATE)) u_baud_gen (.clk(clk),.rst_n(rst_n),.baud_tick(baud_tick));
uart_tx u_uart_tx (.clk(clk),.rst_n(rst_n),.baud_tick (baud_tick),.tx_data(tx_data),.tx_start(tx_start),.tx(tx),.tx_busy(tx_busy));
uart_rx u_uart_rx (.clk(clk),.rst_n(rst_n),.baud_tick (baud_tick),.rx(rx),.rx_data(rx_data),.rx_valid(rx_valid));
endmodule