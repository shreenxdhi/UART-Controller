module uart_tx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115_200
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       baud_tick,
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    output reg        tx,
    output reg        tx_busy
);
    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data_reg;
    localparam IDLE  = 2'd0,
               START = 2'd1,
               DATA  = 2'd2,
               STOP  = 2'd3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
            bit_cnt <= 0;
            data_reg <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy <= 1'b1;
                        state <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;
                    if (baud_tick) begin
                        bit_cnt <= 0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_cnt];
                    if (baud_tick) begin
                        if (bit_cnt == 3'd7)
                            state <= STOP;
                        else
                            bit_cnt <= bit_cnt + 1;
                    end
                end

                STOP: begin
                    tx <= 1'b1;
                    if (baud_tick)
                        state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule