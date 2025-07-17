// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// RISC-V Instruction Memory Testbench
// =============================================================================

module tb_imem;

    logic [31:0] addr;
    wire [31:0] instruction;

    int passed = 0, failed = 0, total = 0;

    imem dut (
        .addr(addr),
        .instruction(instruction)
    );

    task run_test(
        input logic [31:0] a,
        input logic [31:0] expected,
        input string desc
    );
        begin
            addr = a;
            #1;
            total++;
            if (instruction === expected) begin
                passed++;
                $display("[PASS] %s | addr = %h, instruction = %h", desc, addr, instruction);
            end else begin
                failed++;
                $display("[FAIL] %s | addr = %h, got = %h, expected = %h", desc, addr, instruction, expected);
            end
        end
    endtask

    initial begin
        $display("=== IMEM Testbench Start ===");

        run_test(32'h0000_0000, 32'h00500093, "ADDI x1, x0, 5");
        run_test(32'h0000_0004, 32'h00600113, "ADDI x2, x0, 6");
        run_test(32'h0000_0008, 32'h002081b3, "ADD x3, x1, x2");
        run_test(32'h0000_000C, 32'h00000013, "NOP");
        run_test(32'h0000_0050, 32'h00000013, "Uninitialized memory");
        run_test(32'h0000_0005, 32'h00600113, "Misaligned address");

        $display("=== IMEM Summary ===");
        $display("Total: %0d | Passed: %0d | Failed: %0d", total, passed, failed);
        if (failed == 0) $display("✅ All tests passed.");
        else $display("❌ Some tests failed.");
        $finish;
    end
endmodule
