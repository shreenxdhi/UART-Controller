# UART Controller

A simple, configurable UART (serial communication) module written in Verilog. Send and receive data at 115,200 baud (or whatever speed you need).

## What's Inside

- **uart_top.v** - Main module (send & receive)
- **uart_tx.v** - Handles transmitting data
- **uart_rx.v** - Handles receiving data  
- **baud_gen.v** - Clock divider for timing
- **tb_*.sv** - Test files for each module

## Quick Start

### Set Your Speed

```verilog
uart_top #(
    .CLK_FREQ(50_000_000),      // 50 MHz clock
    .BAUD_RATE(115_200)         // 115,200 baud
) uart (
    .clk(clk),
    .rst_n(reset),
    .tx(tx_pin),
    .rx(rx_pin),
    .tx_data(byte_to_send),
    .tx_start(send_now),
    .tx_busy(still_sending),
    .rx_data(received_byte),
    .rx_valid(got_data)
);
```

### Sending a Byte

```verilog
tx_data = 8'h41;    // ASCII 'A'
tx_start = 1;       // Request send
@(posedge clk);
tx_start = 0;       // One-cycle pulse
// Wait until tx_busy goes low, then send next byte
```

### Receiving Data

```verilog
if (rx_valid) begin
    byte_received = rx_data;  // New byte ready!
end
```

## Common Baud Rates

- 9,600 - Slow, reliable
- 115,200 - Default, fast enough for most things
- 230,400 - Really fast

## Testing

Run the testbenches with your simulator:

```bash
# ModelSim
vlog *.v *.sv
vsim tb_uart_top
run -all
```
## Example Waveform 

! (waveform.png)
## How It Works

- **TX**: Takes a byte, adds a start bit and stop bit, then sends it one bit at a time
- **RX**: Waits for a start bit, reads 8 bits, checks for stop bit, and saves the byte
- **Baud Generator**: Just a fancy counter that divides your clock to get the right serial speed
- Both happen at the same time (full-duplex)

## Parameters You Can Change

- `CLK_FREQ` - Your system clock speed (default: 50 MHz)
- `BAUD_RATE` - Serial speed (default: 115,200)

The module figures out how to divide the clock automatically.

## Notes

- Standard format: 1 start bit, 8 data bits, 1 stop bit
- No parity (yet)
- Works with any clock frequency ≥ ~1 MHz
