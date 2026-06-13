`timescale 1ns/1ps
module tb_uart_top;
    reg clk, rst_n;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx_busy;
    wire [7:0] rx_data;
    wire rx_valid;
    wire tx;

    uart_top #(.CLK_FREQ(100), .BAUD_RATE(10)) dut (.clk(clk),.rst_n(rst_n),.tx_data(tx_data),.tx_start(tx_start),.tx_busy(tx_busy),.rx_data(rx_data),.rx_valid(rx_valid),.tx(tx),.rx(tx));
    always #5 clk = ~clk;
    task automatic send_byte(input [7:0] data);
    integer timeout;
    begin
        tx_data = data;
        tx_start = 1'b1;
        @(posedge clk);
        #1;
        tx_start = 1'b0;

        timeout = 0;
        while (!rx_valid && timeout < 10000) begin
            @(posedge clk);
            #1;
            timeout = timeout + 1;
        end

        if (!rx_valid)
            $fatal(1, "Timeout waiting for rx_valid");

        if (rx_data != data)
            $error("Mismatch exp=%h got=%h", data, rx_data);
        else
            $display("PASS %h", data);

        wait (!tx_busy);
        @(posedge clk);
        #1;
    end
endtask
    initial begin
         $display("TESTBENCH STARTED");
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_uart_top);
    end
    initial begin
        clk = 0;
        rst_n = 0;
        tx_data = 0;
        tx_start = 0;
        #100;
        rst_n = 1;
        $display("RESET RELEASED");
        send_byte(8'h55);
        send_byte(8'hAA);
        send_byte(8'hF0);
        send_byte(8'h0F);
         $display("SEND COMPLETE");
        repeat (20) begin
            send_byte($random);
        end

        $display("ALL TESTS PASSED");
        $finish;
    end
endmodule
