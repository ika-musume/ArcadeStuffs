module ShiftRegister
(
    //Master clock
    input   wire            clock,

    //Mode select
    input   wire    [1:0]   mode_select,
    input   wire            bit_select,

    //Ports
    input   wire    [7:0]   parallel_in,
    output  wire            serial_out,
);

reg     [7:0]   register = 8'b0000_0000; //D7 ~ D0
assign          serial_out = (bit_select == 1'b0) ? register[0] : register[7];

always @(posedge clock)
begin
    case(mode_select)
        2'b00: //HOLD
        begin
            register <= register;
        end
        2'b01: //SHIFT LEFT
        begin
            register <= register << 1;
        end
        2'b10: //SHIFT RIGHT
        begin
            register <= register >> 1;
        end
        2'b11: //LOAD
        begin
            register <= parallel_in;
        end
    endcase
end