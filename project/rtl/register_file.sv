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
    input  logic        reset,
    input  logic        we,
    input  logic [4:0]  ra1, ra2, wa,
    input  logic [31:0] wd,
    output logic [31:0] rd1, rd2
);

    logic [31:0] registers [0:31];

    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 1; i < 32; i++) begin
                registers[i] <= 32'h0;
             end
        end else if (we && wa != 0) begin
            registers[wa] <= wd;
        end
    end

    // Read port 1 (example implemented)
    always_comb begin
        if (ra1 == 5'b00000) rd1 = 32'h0000_0000;
        else rd1 = registers[ra1];

        if (ra2 == 5'b00000) rd2 = 32'h0000_0000;
        else rd2 = registers[ra2];
    end

    // TODO: Implement write logic (on clk posedge) 
    // Only write if we == 1 and wa != x0

endmodule
