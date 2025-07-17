// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// ALU Testbench with Logging and Result Summary
// =============================================================================

module tb_alu;

    // Inputs
    reg [31:0] a, b;
    reg [3:0] alu_control;

    // Outputs
    wire [31:0] result;
    wire zero;

    // Counters
    int total = 0, passed = 0, failed = 0;

    // Instantiate ALU
    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    // Helper task for test
    task run_test(
        input [31:0] ain, bin,
        input [3:0] ctrl,
        input [31:0] exp_result,
        input bit exp_zero,
        input string desc
    );
        begin
            a = ain;
            b = bin;
            alu_control = ctrl;
            #1;

            total++;
            if (result === exp_result && zero === exp_zero) begin
                passed++;
                $display("[PASS] %-30s | result = %h, zero = %b", desc, result, zero);
            end else begin
                failed++;
                $display("[FAIL] %-30s | result = %h (exp %h), zero = %b (exp %b)", 
                    desc, result, exp_result, zero, exp_zero);
            end
        end
    endtask

    // Run test sequence
    initial begin
        $display("=== ALU Testbench Start ===");

        run_test(32'h00000005, 32'h00000003, 4'b0000, 32'h00000008, 0, "ADD");
        run_test(32'h00000005, 32'h00000003, 4'b0001, 32'h00000002, 0, "SUB");
        run_test(32'hF0F0F0F0, 32'h0F0F0F0F, 4'b0010, 32'h00000000, 1, "AND");
        run_test(32'hF0F0F0F0, 32'h0F0F0F0F, 4'b0011, 32'hFFFFFFFF, 0, "OR");
        run_test(32'hF0F0F0F0, 32'h0F0F0F0F, 4'b0100, 32'hFFFFFFFF, 0, "XOR");
        run_test(32'h00000001, 32'h00000004, 4'b0101, 32'h00000010, 0, "SLL");
        run_test(32'h80000000, 32'h00000004, 4'b0110, 32'h08000000, 0, "SRL");
        run_test(32'h80000000, 32'h00000004, 4'b0111, 32'hF8000000, 0, "SRA");
        run_test(32'hFFFFFFFF, 32'h00000001, 4'b1000, 32'h00000001, 0, "SLT (signed -1 < 1)");
        run_test(32'hFFFFFFFF, 32'h00000001, 4'b1001, 32'h00000000, 1, "SLTU (unsigned)");

        // Zero flag test (add zero + zero)
        run_test(32'h00000000, 32'h00000000, 4'b0000, 32'h00000000, 1, "ADD (zero result)");

        $display("=== ALU Testbench Summary ===");
        $display("Total tests: %0d", total);
        $display("Passed     : %0d", passed);
        $display("Failed     : %0d", failed);

        if (failed == 0)
            $display("✅ All ALU tests passed.");
        else
            $display("❌ Some ALU tests failed. Review results above.");

        $finish;
    end
endmodule
