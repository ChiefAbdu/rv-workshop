// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// RISCV Processor Full-System Testbench
// =============================================================================

module tb_riscv_processor;

    logic clk, reset;
    wire [31:0] pc_out, instruction_out;

    int passed = 0, failed = 0, total = 0;

    riscv_processor dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction_out(instruction_out)
    );

    always #5 clk = ~clk;

    task check_instr(input [31:0] expected, input string msg);
        #1;
        total++;
        if (instruction_out === expected) begin
            passed++;
            $display("[PASS] %s | PC = %h, Instr = %h", msg, pc_out, instruction_out);
        end else begin
            failed++;
            $display("[FAIL] %s | PC = %h, Instr = %h (expected %h)", msg, pc_out, instruction_out, expected);
        end
    endtask

    initial begin
        $display("=== RISCV Processor Test Start ===");
        clk = 0;
        reset = 1;
        #20;
        reset = 0;

        repeat (10) begin
            case (pc_out)
                32'h00000000: check_instr(32'h00500093, "ADDI x1, x0, 5");
                32'h00000004: check_instr(32'h00600113, "ADDI x2, x0, 6");
                32'h00000008: check_instr(32'h002081b3, "ADD x3, x1, x2");
                32'h0000000C: check_instr(32'h00000013, "NOP");
                default: check_instr(32'h00000013, "Default NOP");
            endcase
            #10;
        end

        $display("=== RISCV Processor Summary ===");
        $display("Total: %0d | Passed: %0d | Failed: %0d", total, passed, failed);
        if (failed == 0) $display("✅ All tests passed.");
        else $display("❌ Some tests failed.");
        $finish;
    end
endmodule
