`timescale 1ns/1ps
module tb_uart_tx;
    reg clk, rst_n, baud_tick;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx;
    wire tx_busy;

    uart_tx dut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    always #5 clk = ~clk;

    task automatic send_baud_tick;
        begin
            baud_tick = 1'b1;
            #10;
            baud_tick = 1'b0;
            #10;
        end
    endtask

    initial begin
        clk = 0;
        rst_n = 0;
        baud_tick = 0;
        tx_start = 0;
        tx_data = 8'hA5;
        #50;
        rst_n = 1;
        #10;
        tx_start = 1'b1;
        #10;
        tx_start = 1'b0;

        repeat (12) begin
            send_baud_tick();
        end

        $finish;
    end
endmodule