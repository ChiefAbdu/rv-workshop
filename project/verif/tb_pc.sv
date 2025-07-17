// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// RISC-V PC Module Testbench (Enhanced with Checks)
// =============================================================================

module tb_pc;

    // Inputs
    logic clk;
    logic reset;
    logic [31:0] pc_next;

    // Output
    wire [31:0] pc;

    // Test bookkeeping
    int total = 0, passed = 0, failed = 0;

    // Instantiate the PC module
    pc dut (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    // Utility to check result
    task check(input [31:0] expected, input string desc);
        total++;
        #1;
        if (pc === expected) begin
            passed++;
            $display("[PASS] %s | pc = %h", desc, pc);
        end else begin
            failed++;
            $display("[FAIL] %s | pc = %h, expected = %h", desc, pc, expected);
        end
    endtask

    // Test sequence
    initial begin
        $display("=== PC Module Testbench Start ===");

        // Initialize inputs
        clk = 0;
        reset = 0;
        pc_next = 0;

        // Test 1: Reset functionality
        reset = 1;
        pc_next = 32'h0000_0004;
        #12;
        check(32'h0000_0000, "Test 1: PC Reset should be zero");

        // Test 2: Normal operation after reset deasserted
        reset = 0;
        pc_next = 32'h0000_0004;
        #10;
        check(32'h0000_0004, "Test 2a: PC update to 0x4");

        pc_next = 32'h0000_0008;
        #10;
        check(32'h0000_0008, "Test 2b: PC update to 0x8");

        pc_next = 32'h0000_000C;
        #10;
        check(32'h0000_000C, "Test 2c: PC update to 0xC");

        // Test 3: Reset during operation
        reset = 1;
        pc_next = 32'h1234_5678;
        #10;
        check(32'h0000_0000, "Test 3: Reset asserted again");

        // Test 4: Continue after reset
        reset = 0;
        pc_next = 32'hFFFF_FFFC;
        #10;
        check(32'hFFFF_FFFC, "Test 4a: PC update to FFFF_FFFC");

        pc_next = 32'hABCD_1234;
        #10;
        check(32'hABCD_1234, "Test 4b: PC update to ABCD_1234");

        // Summary
        $display("=== PC Module Testbench Summary ===");
        $display("Total tests : %0d", total);
        $display("Passed      : %0d", passed);
        $display("Failed      : %0d", failed);
        if (failed == 0)
            $display("✅ All PC tests passed.");
        else
            $display("❌ Some PC tests failed. Check logs.");

        $finish;
    end
endmodule
