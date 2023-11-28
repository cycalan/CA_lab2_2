module CPU
(
    clk_i, 
    rst_i
);

// Ports
input               clk_i;
input               rst_i;

wire [31:0] instruction;
wire [4:0] rs1, rs2;
wire [6:0] opcode;
wire ID_FlushIF;

assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign opcode = instruction[6:0];
assign ID_FlushIF = (Control.Branch_o & (Registers.RS1data_o == Registers.RS2data_o)) ? 1'b1 : 1'b0;

MUX MUX1(
    .data0_i        (address.data_o),
    .data1_i        (Add.data_o),
    .signal_i       (ID_FlushIF)
);

PC PC(
    .rst_i          (rst_i),
    .clk_i          (clk_i),
    .PCWrite_i      (Hazard_Detection.PCWrite_o),
    .pc_i           (MUX1.MUX_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i         (PC.pc_o)
);

Adder address(
    .data1_i        (PC.pc_o),
    .data2_i        (32'b100)
);

IF_ID IF_ID(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .instruction_i  (Instruction_Memory.instr_o),
    .pc_i           (PC.pc_o),
    .flush_i        (ID_FlushIF),
    .stall_i        (Hazard_Detection.Stall_o),
    .instruction_o  (instruction)
);

Adder Add(
    .data1_i        (Immediate_Gen.Immediate_Gen_o << 32'b1),
    .data2_i        (IF_ID.pc_o)
);

Hazard_Detection Hazard_Detection(
    .MemRead_i      (ID_EX.MemRead_o),
    .rd_i           (ID_EX.rd_o),
    .rs1_i          (rs1),
    .rs2_i          (rs2)
);

Registers Registers(
    .rst_i          (rst_i),
    .clk_i          (clk_i),
    .RS1addr_i      (rs1),
    .RS2addr_i      (rs2),
    .RDaddr_i       (MEM_WB.rd_o),
    .RDdata_i       (MUX3.MUX_o),
    .RegWrite_i     (MEM_WB.RegWrite_o)
);

Control Control(
    .Opcode_i       (opcode),
    .NoOp_i         (Hazard_Detection.NoOp_o)
);

Immediate_Gen Immediate_Gen(
    .instr_i        (instruction)
);

ID_EX ID_EX(
    .clk_i              (clk_i),
    .rst_i              (rst_i),
    .RegWrite_i         (Control.RegWrite_o),
    .MemtoReg_i         (Control.MemtoReg_o),
    .MemRead_i          (Control.MemRead_o),
    .MemWrite_i         (Control.MemWrite_o),
    .ALUOp_i            (Control.ALUOp_o),
    .ALUSrc_i           (Control.ALUSrc_o),
    .Immediate_Gen_i    (Immediate_Gen.Immediate_Gen_o),
    .instr_i            (instruction),
    .data_1_i           (Registers.RS1data_o),
    .data_2_i           (Registers.RS2data_o)
);

MUX_Forward MUX11(
    .data00_i       (ID_EX.data1_o),
    .data01_i       (MUX3.MUX_o),
    .data10_i       (EX_MEM.ALU_result_o),
    .forward_i      (Forward_Unit.Forward_A_o)
);

MUX_Forward MUX22(
    .data00_i       (ID_EX.data2_o),
    .data01_i       (MUX3.MUX_o),
    .data10_i       (EX_MEM.ALU_result_o),
    .forward_i      (Forward_Unit.Forward_B_o)
);

MUX MUX2(
    .data0_i        (MUX22.MUX_Forward_o),
    .data1_i        (ID_EX.Immediate_Gen_o),
    .signal_i       (ID_EX.ALUSrc_o)
);

Forward_Unit Forward_Unit(
    .MEM_RegWrite_i (EX_MEM.RegWrite_o),
    .MEM_rd_i       (EX_MEM.rd_o),
    .WB_RegWrite_i  (MEM_WB.RegWrite_o),
    .WB_rd_i        (MEM_WB.rd_o),
    .EX_rs1_i       (ID_EX.ID_EX_rs1_o),
    .EX_rs2_i       (ID_EX.ID_EX_rs2_o)
);
  
ALU ALU(
    .data_1_i         (MUX11.MUX_Forward_o),
    .data_2_i         (MUX2.MUX_o),
    .ALU_Control_i        (ALU_Control.ALU_Control_o)
);

ALU_Control ALU_Control(
    .ID_EX_func7_i         (ID_EX.func7_o),
    .ID_EX_func3_i         (ID_EX.func3_o),
    .ALUOp_i         (ID_EX.ALUOp_o)
);

EX_MEM EX_MEM(
    .clk_i           (clk_i),
    .rst_i           (rst_i),
    .RegWrite_i      (ID_EX.RegWrite_o),
    .MemtoReg_i      (ID_EX.MemtoReg_o),
    .MemRead_i       (ID_EX.MemRead_o),
    .MemWrite_i      (ID_EX.MemWrite_o),
    .ALU_result_i    (ALU.ALU_o),
    .MUX_i           (MUX22.MUX_Forward_o),
    .rd_i            (ID_EX.rd_o)
);

Data_Memory Data_Memory(
    .clk_i           (clk_i),
    .addr_i          (EX_MEM.ALU_result_o),
    .MemRead_i       (EX_MEM.MemRead_o),
    .MemWrite_i      (EX_MEM.MemWrite_o),
    .data_i          (EX_MEM.MUX_o)
);

MEM_WB MEM_WB(
    .clk_i           (clk_i),
    .rst_i           (rst_i),
    .RegWrite_i      (EX_MEM.RegWrite_o),
    .MemtoReg_i      (EX_MEM.MemtoReg_o),
    .ALU_result_i    (EX_MEM.ALU_result_o),
    .ReadData_i      (Data_Memory.data_o),
    .rd_i            (EX_MEM.rd_o)
);

MUX MUX3(
    .data0_i         (MEM_WB.ALU_result_o),
    .data1_i         (MEM_WB.ReadData_o),
    .signal_i        (MEM_WB.MemtoReg_o)
);

endmodule