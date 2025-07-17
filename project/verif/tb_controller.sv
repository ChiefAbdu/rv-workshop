// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// RISC-V Control Unit Testbench (With Result Checking)
// =============================================================================

module tb_controller;

    // Inputs
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    // Outputs
    logic       reg_write;
    logic [2:0] imm_src;
    logic       alu_src;
    logic       mem_write;
    logic       result_src;
    logic       branch;
    logic       jump;
    logic [3:0] alu_control;

    int total = 0, passed = 0, failed = 0;

    // Instantiate DUT
    controller dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );

    // Task to run and verify a test
    task run_test(
        input [6:0] opc, 
        input [2:0] f3, 
        input [6:0] f7,
        input logic exp_reg_write,
        input [2:0] exp_imm_src,
        input logic exp_alu_src,
        input logic exp_mem_write,
        input logic exp_result_src,
        input logic exp_branch,
        input logic exp_jump,
        input [3:0] exp_alu_control,
        input string desc
    );
        begin
            opcode = opc; funct3 = f3; funct7 = f7;
            #1;

            total++;
            if (reg_write == exp_reg_write && imm_src == exp_imm_src &&
                alu_src == exp_alu_src && mem_write == exp_mem_write &&
                result_src == exp_result_src && branch == exp_branch &&
                jump == exp_jump && alu_control == exp_alu_control) begin

                passed++;
                $display("[PASS] %-25s | ALU=%b IMM=%b", desc, alu_control, imm_src);
            end else begin
                failed++;
                $display("[FAIL] %-25s", desc);
                $display("       => reg_write=%b (exp %b), imm_src=%b (exp %b), alu_src=%b (exp %b)",
                         reg_write, exp_reg_write, imm_src, exp_imm_src, alu_src, exp_alu_src);
                $display("       => mem_write=%b (exp %b), result_src=%b (exp %b), branch=%b (exp %b), jump=%b (exp %b)",
                         mem_write, exp_mem_write, result_src, exp_result_src, branch, exp_branch, jump, exp_jump);
                $display("       => alu_control=%b (exp %b)", alu_control, exp_alu_control);
            end
        end
    endtask

    initial begin
        $display("=== Control Unit Testbench Start ===");

        run_test(7'b0110011, 3'b000, 7'b0000000, 1, 3'b000, 0, 0, 0, 0, 0, 4'b0000, "R-type ADD");
        run_test(7'b0110011, 3'b000, 7'b0100000, 1, 3'b000, 0, 0, 0, 0, 0, 4'b0001, "R-type SUB");
        run_test(7'b0110011, 3'b111, 7'b0000000, 1, 3'b000, 0, 0, 0, 0, 0, 4'b1001, "R-type AND");

        run_test(7'b0010011, 3'b000, 7'b0000000, 1, 3'b000, 1, 0, 0, 0, 0, 4'b0000, "I-type ADDI");
        run_test(7'b0010011, 3'b101, 7'b0100000, 1, 3'b000, 1, 0, 0, 0, 0, 4'b0111, "I-type SRAI");
        run_test(7'b0010011, 3'b011, 7'b0000000, 1, 3'b000, 1, 0, 0, 0, 0, 4'b0100, "I-type SLTIU");

        run_test(7'b0000011, 3'b010, 7'b0000000, 1, 3'b000, 1, 0, 1, 0, 0, 4'b0000, "Load (LW)");
        run_test(7'b0100011, 3'b010, 7'b0000000, 0, 3'b001, 1, 1, 0, 0, 0, 4'b0000, "Store (SW)");
        run_test(7'b1100011, 3'b000, 7'b0000000, 0, 3'b010, 0, 0, 0, 1, 0, 4'b0001, "Branch (BEQ)");
        run_test(7'b1101111, 3'b000, 7'b0000000, 1, 3'b011, 0, 0, 0, 0, 1, 4'b0000, "JAL");
        run_test(7'b0110111, 3'b000, 7'b0000000, 1, 3'b100, 1, 0, 0, 0, 0, 4'b1111, "LUI");

        run_test(7'b1111111, 3'b000, 7'b0000000, 0, 3'b000, 0, 0, 0, 0, 0, 4'b0000, "NOP/Invalid");

        $display("=== Control Unit Testbench Summary ===");
        $display("Total tests: %0d", total);
        $display("Passed     : %0d", passed);
        $display("Failed     : %0d", failed);
        if (failed == 0)
            $display("✅ All control unit tests passed.");
        else
            $display("❌ Some control unit tests failed. Please review output.");

        $finish;
    end
endmodule
