module MUX
(
    data0_i,
    data1_i,
    signal_i,
    MUX_o
);

input [31:0] data0_i, data1_i;
input signal_i;
output [31:0] MUX_o;

assign MUX_o = (signal_i) ? data1_i : data0_i;

endmodule