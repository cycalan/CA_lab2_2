module ALU_Control
(
    ALUOp_i,
    ID_EX_func3_i,
    ID_EX_func7_i,
    ALU_Control_o
);
input [1:0] ALUOp_i;
input [6:0] ID_EX_func7_i;
input [2:0] ID_EX_func3_i;
output [2:0] ALU_Control_o;

assign ALU_Control_o =  (ID_EX_func3_i == 3'b111) ? 3'b000 :
                        (ID_EX_func3_i == 3'b100) ? 3'b001 :
                        (ID_EX_func3_i == 3'b001) ? 3'b010 :
                        (ID_EX_func3_i == 3'b101) ? 3'b110 :
                        (ID_EX_func3_i == 3'b010) ? 3'b011 :
                        (ALUOp_i == 2'b01) ? 3'b111 :
                        (ALUOp_i == 2'b00) ? 3'b011 :
                        (ID_EX_func7_i == 7'b0000000) ? 3'b011 :
                        (ID_EX_func7_i == 7'b0100000) ? 3'b100 : 3'b101;

endmodule