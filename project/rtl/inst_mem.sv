// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// Single-Cycle RISC-V Processor - Instruction Memory (Workshop Skeleton Version)
// =============================================================================

module imem (
    input  logic [31:0] addr,
    output logic [31:0] instruction
);

    logic [31:0] mem [0:1023]; // 4KB instruction memory

    

    initial begin
        // ---------------------------------------------------------------------
        // Sample Instruction Sequence (RISC-V RV32I)
        // ---------------------------------------------------------------------
        // addi x1, x0, 5        -> x1 = 5
        // addi x2, x0, 10       -> x2 = 10
        // add  x3, x1, x2       -> x3 = x1 + x2 = 15
        // sub  x4, x2, x1       -> x4 = x2 - x1 = 5
        // and  x5, x1, x2       -> x5 = x1 & x2 = 0
        // or   x6, x1, x2       -> x6 = x1 | x2 = 15
        // nop                   -> x0 = x0 (no operation)
        // nop

        mem[0] = 32'h00500093; // addi x1, x0, 5
        mem[1] = 32'h00a00113; // addi x2, x0, 10
        mem[2] = 32'h002081b3; // add  x3, x1, x2
        mem[3] = 32'h40210233; // sub  x4, x2, x1
        mem[4] = 32'h0020a2b3; // and  x5, x1, x2
        mem[5] = 32'h0020b333; // or   x6, x1, x2
        mem[6] = 32'h00000013; // nop
        mem[7] = 32'h00000013; // nop

    end
    // Word-aligned access
    assign instruction = mem[addr >> 2];

endmodule
