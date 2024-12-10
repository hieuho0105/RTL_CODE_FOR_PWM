module wrapper(
    input           clk,
    input           reset,
    input           chipselect,
    input           write_enable,
    input           read_enable,
    input   [15:0]  address,
    input   [15:0]  writedata,
    output  [15:0]  readdata,
    output          pwm_out
);

wire [7:0]  ctrl;
wire [15:0] period;
wire [15:0] duty_cycle;
wire [15:0] divisor;

csr csr_inst (
    .clk            (clk),
    .reset          (reset),
    .chipselect     (chipselect),
    .write_enable   (write_enable),
    .read_enable    (read_enable),
    .address        (address),
    .writedata      (writedata),
    .readdata       (readdata),
    .ctrl           (ctrl),
    .period         (period),
    .duty_cycle     (duty_cycle),
    .divisor        (divisor)
);

core core_inst (
    .clk            (clk),
    .reset          (reset),
    .period         (period),
    .duty_cycle     (duty_cycle),
    .divisor        (divisor),
    .ctrl           (ctrl),
    .pwm_out        (pwm_out)
);

endmodule