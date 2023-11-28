module ALU
(   data_1_i,
    data_2_i,
    ALU_Control_i,
    ALU_o
);
input [31:0] data_1_i, data_2_i;
input [2:0] ALU_Control_i;
output [31:0] ALU_o;

assign ALU_o =  (ALU_Control_i == 3'b000) ? data_1_i & data_2_i :
                (ALU_Control_i == 3'b001) ? data_1_i ^ data_2_i :
                (ALU_Control_i == 3'b010) ? data_1_i << data_2_i :
                (ALU_Control_i == 3'b011) ? data_1_i + data_2_i :
                (ALU_Control_i == 3'b100) ? data_1_i - data_2_i :
                (ALU_Control_i == 3'b101) ? data_1_i * data_2_i :
                (ALU_Control_i == 3'b110) ? data_1_i >>> (data_2_i & 12'b000000011111) : 32'b0;


endmodule