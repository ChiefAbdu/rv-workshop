// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// RISC-V Immediate Generator Testbench
// =============================================================================

module tb_immgen;

    logic [31:0] instruction;
    logic [2:0] imm_src;
    wire [31:0] imm_ext;

    int passed = 0, failed = 0, total = 0;

    immgen dut (
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    task run_test(
        input logic [31:0] instr,
        input logic [2:0] src,
        input logic [31:0] expected,
        input string desc
    );
        begin
            instruction = instr;
            imm_src = src;
            #1;

            total++;
            if (imm_ext === expected) begin
                passed++;
                $display("[PASS] %s | imm_ext = %h", desc, imm_ext);
            end else begin
                failed++;
                $display("[FAIL] %s | imm_ext = %h, expected = %h", desc, imm_ext, expected);
            end
        end
    endtask

    initial begin
        $display("=== IMMGEN Testbench Start ===");

        run_test(32'hFFF12383, 3'b000, 32'hFFFFF123, "I-type (sign-ext)");
        run_test(32'h00F12323, 3'b001, 32'h00000F12, "S-type (store offset)");
        run_test(32'hFE512EE3, 3'b010, 32'hFFFFFFE4, "B-type (branch offset)");
        run_test(32'h12345037, 3'b011, 32'h12345000, "U-type (LUI)");
        run_test(32'hFFF0016F, 3'b100, 32'hFFFFF000, "J-type (JAL)");
        run_test(32'h00000000, 3'b111, 32'h00000000, "Default imm");

        $display("=== IMMGEN Summary ===");
        $display("Total: %0d | Passed: %0d | Failed: %0d", total, passed, failed);
        if (failed == 0) $display("✅ All tests passed.");
        else $display("❌ Some tests failed.");
        $finish;
    end
endmodule
