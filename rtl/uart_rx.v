module uart_rx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115_200
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       baud_tick,
    input  wire       rx,
    output reg [7:0]  rx_data,
    output reg        rx_valid
);
    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    localparam IDLE  = 2'd0,
               START = 2'd1,
               DATA  = 2'd2,
               STOP  = 2'd3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_cnt <= 0;
            shift_reg <= 0;
            rx_data <= 0;
            rx_valid <= 1'b0;
        end
        else begin
            rx_valid <= 1'b0;

            case (state)
                IDLE: begin
                    if (rx == 1'b0) begin
                        state <= START;
                        bit_cnt <= 0;
                    end
                end

                START: begin
                    if (baud_tick) begin
                        if (rx == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        shift_reg[bit_cnt] <= rx;
                        if (bit_cnt == 3'd7)
                            state <= STOP;
                        else
                            bit_cnt <= bit_cnt + 1;
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        rx_data <= shift_reg;
                        rx_valid <= 1'b1;
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule