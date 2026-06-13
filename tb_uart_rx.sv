`timescale 1ns/1ps
module tb_uart_rx;
    reg clk, rst_n, baud_tick, rx;
    wire [7:0] rx_data;
    wire rx_valid;

    uart_rx dut (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick),
        .rx(rx),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    always #5 clk = ~clk;

    task automatic send_bit(input bit b);
        begin
            rx = b;
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
        rx = 1'b1;
        #50;
        rst_n = 1;

        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);

        #100;
        if (rx_valid && rx_data == 8'hA5)
            $display("PASS");
        else
            $error("FAIL");

        $finish;
    end
endmodule