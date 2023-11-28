module MEM_WB
(   
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    ALU_result_i,
    ReadData_i,
    rd_i,

    RegWrite_o,
    MemtoReg_o,
    ALU_result_o,
    ReadData_o,
    rd_o
);

input clk_i, rst_i, RegWrite_i, MemtoReg_i;
input [31:0] ALU_result_i, ReadData_i;
input [4:0] rd_i;

output reg RegWrite_o, MemtoReg_o;
output reg[31:0] ALU_result_o, ReadData_o;
output reg[4:0] rd_o;

always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        RegWrite_o <= 1'b0; 
        MemtoReg_o <= 1'b0;
        ALU_result_o <= 32'b0;
        ReadData_o <= 32'b0;
        rd_o <= 5'b0;
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALU_result_o <= ALU_result_i;
        ReadData_o <= ReadData_i;
        rd_o <= rd_i;
    end
end

endmodule