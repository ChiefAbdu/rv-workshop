// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// Single-Cycle RISC-V Processor - Register File (Workshop Skeleton Version)
// =============================================================================

module register_file (
    input  logic        clk,
    input  logic        we,
    input  logic [4:0]  ra1, ra2, wa,
    input  logic [31:0] wd,
    output logic [31:0] rd1, rd2
);

    logic [31:0] registers [0:31];

    // TODO: Initialize registers to zero using a for loop

    // Read port 1 (example implemented)
    assign rd1 = (ra1 == 5'b00000) ? 32'h0000_0000 : registers[ra1];

    // TODO: Implement rd2 read port using same logic as rd1

    // TODO: Implement write logic (on clk posedge) 
    // Only write if we == 1 and wa != x0

endmodule
