// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// RISC-V Data Memory Testbench (Enhanced with Checks)
// =============================================================================

module tb_dmem;

    // Inputs
    logic clk;
    logic we;
    logic [31:0] addr;
    logic [31:0] wdata;

    // Output
    wire [31:0] rdata;

    int total = 0, passed = 0, failed = 0;

    // Instantiate DUT
    dmem dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Task for result checking
    task check(input [31:0] expected, input string desc);
        total++;
        #1;
        if (rdata === expected) begin
            passed++;
            $display("[PASS] %s | addr=%h, rdata=%h", desc, addr, rdata);
        end else begin
            failed++;
            $display("[FAIL] %s | addr=%h, rdata=%h, expected=%h", desc, addr, rdata, expected);
        end
    endtask

    // Test sequence
    initial begin
        $display("=== Data Memory Testbench Start ===");

        clk = 0;
        we = 0;
        addr = 0;
        wdata = 0;

        #10; // Wait for memory init

        // Test 1: Read from zero-initialized memory
        addr = 32'h0000_0000;
        #10;
        check(32'h0000_0000, "Read from addr 0 after init");

        // Test 2: Write A5A5A5A5 to addr 0x04
        addr = 32'h0000_0004;
        wdata = 32'hA5A5A5A5;
        we = 1;
        #10; // Write at rising edge
        we = 0;

        // Test 3: Write 12345678 to addr 0x10
        addr = 32'h0000_0010;
        wdata = 32'h12345678;
        we = 1;
        #10;
        we = 0;

        // Test 4: Read back A5A5A5A5 from addr 0x04
        addr = 32'h0000_0004;
        #10;
        check(32'hA5A5A5A5, "Read back addr 0x04");

        // Test 5: Read back 12345678 from addr 0x10
        addr = 32'h0000_0010;
        #10;
        check(32'h12345678, "Read back addr 0x10");

        // Test 6: Try write with we = 0 (should not write)
        addr = 32'h0000_0020;
        wdata = 32'hDEADBEEF;
        we = 0;
        #10; // No write

        // Test 7: Read back addr 0x20 (should be 0)
        addr = 32'h0000_0020;
        #10;
        check(32'h0000_0000, "Read back addr 0x20 (should remain 0)");

        // Summary
        $display("=== Data Memory Testbench Summary ===");
        $display("Total tests: %0d", total);
        $display("Passed     : %0d", passed);
        $display("Failed     : %0d", failed);
        if (failed == 0)
            $display("✅ All memory tests passed.");
        else
            $display("❌ Some memory tests failed. Please review above.");

        $finish;
    end
endmodule
