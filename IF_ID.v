module IF_ID
(
    clk_i,
    rst_i,
    instruction_i,
    pc_i,
    flush_i,
    stall_i,
    instruction_o,
    pc_o

);

input   rst_i, clk_i, stall_i, flush_i;
input [31:0] instruction_i, pc_i;
output reg[31:0] instruction_o, pc_o;

always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        instruction_o <= 32'b0;
        pc_o <= 32'b0;
    end
    else if (~stall_i) begin
        pc_o <= pc_i;
        instruction_o <= (flush_i) ? 32'b0 : instruction_i;
    end
end

endmodule