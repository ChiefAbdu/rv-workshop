// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// RISC-V Branch Unit Testbench
// =============================================================================

module tb_branch_unit;

    // Inputs
    logic [31:0] rd1, rd2;
    logic [2:0] funct3;
    logic branch;

    // Output
    wire pc_src;

    // Test counters
    int passed = 0;
    int failed = 0;
    int total  = 0;

    // Instantiate DUT
    branch_unit dut (
        .rd1(rd1),
        .rd2(rd2),
        .funct3(funct3),
        .branch(branch),
        .pc_src(pc_src)
    );

    // Helper task to run a test case
    task run_test(
        input logic [31:0] r1,
        input logic [31:0] r2,
        input logic [2:0] f3,
        input logic br,
        input logic expected,
        input string description
    );
        begin
            rd1 = r1;
            rd2 = r2;
            funct3 = f3;
            branch = br;
            #1; // Wait for combinational logic

            total++;
            if (pc_src === expected) begin
                passed++;
                $display("[PASS] %s | pc_src = %b as expected", description, pc_src);
            end else begin
                failed++;
                $display("[FAIL] %s | pc_src = %b, expected %b", description, pc_src, expected);
            end
        end
    endtask

    // Test sequence
    initial begin
        $display("=== Branch Unit Testbench Start ===");

        run_test(32'h12345678, 32'h12345678, 3'b000, 1, 1, "BEQ (equal)");
        run_test(32'h12345678, 32'h87654321, 3'b001, 1, 1, "BNE (not equal)");
        run_test(-5, 10,         3'b100, 1, 1, "BLT (signed -5 < 10)");
        run_test(-5, -10,        3'b101, 1, 1, "BGE (signed -5 >= -10)");
        run_test(32'h00000001, 32'hFFFFFFFF, 3'b110, 1, 1, "BLTU (unsigned 1 < FFFFFFFF)");
        run_test(32'hFFFFFFFF, 32'h00000001, 3'b111, 1, 1, "BGEU (unsigned FFFFFFFF >= 1)");

        run_test(32'h11111111, 32'h22222222, 3'b010, 1, 0, "Invalid funct3 (should output 0)");
        run_test(32'h12345678, 32'h12345678, 3'b000, 0, 0, "BEQ (branch disabled)");

        $display("=== Branch Unit Testbench Summary ===");
        $display("Total Tests: %0d", total);
        $display("Passed     : %0d", passed);
        $display("Failed     : %0d", failed);

        if (failed == 0)
            $display("✅ All tests passed successfully.");
        else
            $display("❌ Some tests failed. Please review.");

        $finish;
    end
endmodule
