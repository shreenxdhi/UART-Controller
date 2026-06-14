`timescale 1ns/1ps
module tb_baud_gen;
    reg clk;
    reg rst_n;
    wire baud_tick;
    baud_gen #( .CLK_FREQ(50_000_000), .BAUD_RATE(115200)) dut (.clk(clk),.rst_n(rst_n),.baud_tick(baud_tick));
    always #10 clk = ~clk;
    integer tick_count;
    initial begin
        clk = 0;
        rst_n = 0;
        tick_count = 0;
        #100;
        rst_n = 1;
        repeat(1000) begin
            #10 if(baud_tick)
                tick_count++;
        end
        $display("Ticks generated = %0d", tick_count);
        $finish;
    end
endmodule