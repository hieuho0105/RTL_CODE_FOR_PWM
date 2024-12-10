module PWM_CSR(
    input           clk,
    input           reset,
    input           chipselect,
    input           write_enable,
    input           read_enable,
    input   [15:0]  address,
    input   [15:0]  writedata,
    output  [15:0]  readdata,
    output  [7:0]   ctrl,
    output  [15:0]  period,
    output  [15:0]  duty_cycle,
    output  [15:0]  divisor
);

parameter   ADDR_CTRL=0,
            ADDR_DIVISOR=2,
            ADDR_PERIOD=4,
            ADDR_DUTY_CYCLE=6;

reg [7:0]   ctrl_reg;
reg [15:0]  period_reg;
reg [15:0]  duty_cycle_reg;
reg [15:0]  divisor_reg;

wire        write;
assign      write = chipselect && write_enable;

always@(posedge clk or posedge reset)
    if(reset) begin
        ctrl_reg[4:0] <= 0;
        ctrl_reg[7:6] <= 0;
        duty_cycle_reg <= 0;
        period_reg <= 0;
        divisor_reg <= 0;    
    end
    else if(write) begin
        case(address)
            ADDR_CTRL: begin
                ctrl_reg[4:0] <= writedata[4:0];
                ctrl_reg[7:6] <= writedata[7:6];
            end
            ADDR_DIVISOR: divisor_reg <= writedata;
            ADDR_PERIOD: period_reg <= writedata;
            ADDR_DUTY_CYCLE: duty_cycle_reg <= writedata;
        endcase
    end

assign readdata = (chipselect && read_enable) ? 
                  (address == ADDR_CTRL ? {8'h0, ctrl_reg} :
                  address == ADDR_DIVISOR ? divisor_reg :
                  address == ADDR_PERIOD ? period_reg :
                  address == ADDR_DUTY_CYCLE ? duty_cycle_reg : 0) : 16'h0;

assign ctrl = ctrl_reg;
assign period = period_reg;
assign duty_cycle = duty_cycle_reg;
assign divisor = divisor_reg;

endmodule