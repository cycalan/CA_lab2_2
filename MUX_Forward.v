module MUX_Forward
(
    data00_i,
    data01_i,
    data10_i,
    forward_i,
    MUX_Forward_o
);

input [31:0]  data00_i, data01_i, data10_i;
input [1:0] forward_i;
output [31:0] MUX_Forward_o;

assign MUX_Forward_o =  (forward_i == 2'b00) ? data00_i :
                        (forward_i == 2'b01) ? data01_i :
                        (forward_i == 2'b10) ? data10_i : 32'b0;

endmodule