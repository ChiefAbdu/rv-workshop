// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// RISC-V Register File Testbench
// =============================================================================

module tb_register_file;

    logic clk, we;
    logic [4:0] ra1, ra2, wa;
    logic [31:0] wd;
    wire [31:0] rd1, rd2;

    int passed = 0, failed = 0, total = 0;

    register_file dut (
        .clk(clk), .we(we),
        .ra1(ra1), .ra2(ra2),
        .wa(wa), .wd(wd),
        .rd1(rd1), .rd2(rd2)
    );

    always #5 clk = ~clk;

    task check_read(input [4:0] r1, r2, input [31:0] exp1, exp2, input string msg);
        ra1 = r1; ra2 = r2;
        #1;
        total++;
        if (rd1 === exp1 && rd2 === exp2) begin
            passed++;
            $display("[PASS] %s | rd1 = %h, rd2 = %h", msg, rd1, rd2);
        end else begin
            failed++;
            $display("[FAIL] %s | rd1 = %h (exp %h), rd2 = %h (exp %h)", msg, rd1, exp1, rd2, exp2);
        end
    endtask

    initial begin
        clk = 0; we = 0;
        ra1 = 0; ra2 = 0; wa = 0; wd = 0;

        $display("=== Register File Testbench Start ===");

        #10;
        check_read(0, 0, 0, 0, "Read x0 init");

        wa = 5'd0; wd = 32'hDEAD_BEEF; we = 1;
        #10;

        we = 0;
        check_read(0, 0, 0, 0, "Write to x0 (ignored)");

        wa = 5'd1; wd = 32'h1111_2222; we = 1; #10;
        we = 0;
        check_read(1, 0, 32'h1111_2222, 0, "Write x1, read x1/x0");

        wa = 5'd2; wd = 32'h3333_4444; we = 1; #10;
        we = 0;
        check_read(1, 2, 32'h1111_2222, 32'h3333_4444, "Write x2, read x1/x2");

        wa = 5'd3; wd = 32'hFFFF_FFFF; we = 0; #10;
        check_read(3, 0, 0, 0, "Disabled write to x3");

        $display("=== Register File Summary ===");
        $display("Total: %0d | Passed: %0d | Failed: %0d", total, passed, failed);
        if (failed == 0) $display("✅ All tests passed.");
        else $display("❌ Some tests failed.");
        $finish;
    end
endmodule
