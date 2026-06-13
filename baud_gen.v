module baud_gen #(parameter CLK_FREQ = 50_000_000,parameter BAUD_RATE = 115_200)(clk,rst_n,baud_tick);
input wire clk,rst_n;
output reg baud_tick;
reg [15:0] counter;
localparam DIVISOR = CLK_FREQ / BAUD_RATE;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter   <= 0;
        baud_tick <= 0;
    end
    else begin
        if (counter == DIVISOR - 1) begin
            counter   <= 0;
            baud_tick <= 1'b1;
        end
        else begin
            counter   <= counter + 1;
            baud_tick <= 1'b0;
        end
    end
end
endmodule