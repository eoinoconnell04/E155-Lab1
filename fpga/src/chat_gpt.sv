/*
 * Blink an LED at ~2 Hz using the internal HSOSC (48 MHz) on Lattice UP5K
 * Target: Lattice iCE40 UltraPlus (UP5K)
 */

module blink_led (
    output logic led   // LED pin
);

    // Internal oscillator
    logic clk_hf;
    HSOSC #(
        .CLKHF_DIV("0b00")   // 48 MHz (00), 24 MHz (01), 12 MHz (10), 6 MHz (11)
    ) hf_osc_inst (
        .CLKHF(clk_hf),
        .CLKHFEN(1'b1),      // enable output
        .CLKHFPU(1'b1)       // power up oscillator
    );

    // Counter divider
    logic [24:0] counter;   // enough bits for ~0.5s interval at 48 MHz
    logic led_reg;

    always_ff @(posedge clk_hf) begin
        counter <= counter + 1;

        // Toggle LED at ~2 Hz (0.5s high, 0.5s low)
        if (counter == 24_000_000) begin
            led_reg <= ~led_reg;
            counter <= 0;
        end
    end

    assign led = led_reg;

endmodule
