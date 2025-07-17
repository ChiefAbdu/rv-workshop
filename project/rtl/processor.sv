module processor (
    input  logic clk,
    input  logic reset,
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    // Program counter signals
    logic [31:0] pc, pc_next;

    // Fetch stage
    logic [31:0] instruction;

    // Decode
    logic [4:0] rs1, rs2, rd;
    logic [31:0] rd1, rd2;
    logic [31:0] imm_ext;

    // Execute
    logic [31:0] src_a, src_b;
    logic [31:0] alu_result;
    logic        zero;

    // Memory and writeback
    logic [31:0] read_data;
    logic [31:0] result;

    // Control signals
    logic reg_write;
    logic alu_src;
    logic mem_write;
    logic mem_to_reg;
    logic branch;
    logic [2:0] alu_ctrl;
    logic pc_src;

    // Outputs for debug
    assign pc_out = pc;
    assign instruction_out = instruction;

    // Instruction field extraction
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

    // src_b selection (rd2 or imm_ext)
    always_comb begin
        if (alu_src)
            src_b = imm_ext;
        else
            src_b = rd2;
    end

    // result selection (from ALU or memory)
    always_comb begin
        if (mem_to_reg)
            result = read_data;
        else
            result = alu_result;
    end

    // PC update logic
    always_comb begin
        if (pc_src)
            pc_next = pc + imm_ext;
        else
            pc_next = pc + 4;
    end

    // Instantiate modules

    pc pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    inst_mem instruction_memory (
        .addr(pc),
        .instruction(instruction)
    );

    controller control_unit (
        .opcode(instruction[6:0]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .branch(branch),
        .alu_op(alu_ctrl)
    );

    register_file rf (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .we3(reg_write),
        .wd3(result),
        .rd1(rd1),
        .rd2(rd2)
    );

    imm_gen imm_generator (
        .instruction(instruction),
        .imm_out(imm_ext)
    );

    assign src_a = rd1;

    alu alu_core (
        .a(src_a),
        .b(src_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    data_mem dmem (
        .clk(clk),
        .addr(alu_result),
        .write_data(rd2),
        .mem_write(mem_write),
        .read_data(read_data)
    );

    branch_unit branch_logic (
        .zero(zero),
        .branch(branch),
        .pc_src(pc_src)
    );

endmodule
