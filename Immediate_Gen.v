module Immediate_Gen
(
    instr_i,
    Immediate_Gen_o
);
input [31:0] instr_i;
output [31:0] Immediate_Gen_o;

assign Immediate_Gen_o =    (instr_i[6:0] == 7'b0100011) ? {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]} :
                            (instr_i[6:0] == 7'b1100011) ? {{21{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8]} :
                            {{20{instr_i[31]}}, instr_i[31:20]};



endmodule