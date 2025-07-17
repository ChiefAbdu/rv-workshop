// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// Single-Cycle RISC-V Processor - Complete Implementation
// MEDS Workshop: "Build your own RISC-V Processor in a day"
// =============================================================================

// =============================================================================
// BRANCH UNIT MODULE
// =============================================================================

module branch_unit (
    input  logic [31:0] rd1, rd2,
    input  logic [2:0]  funct3,
    input  logic        branch,
    output logic        pc_src
);

    logic branch_condition;

    always_comb begin
        // TODO: Implement branch condition logic based on funct3
        // funct3:
        // 000: BEQ   (rd1 == rd2)
        // 001: BNE   (rd1 != rd2)
        // 100: BLT   (signed comparison)
        // 101: BGE   (signed comparison)
        // 110: BLTU  (unsigned comparison)
        // 111: BGEU  (unsigned comparison)
        
        case (funct3)
            3'b000: branch_condition = (rd1 == rd2);       // BEQ
            3'b001: branch_condition = (rd1 != rd2);       // BNE
            // TODO: Implement BLT, BGE, BLTU, BGEU
            default: branch_condition = 1'b0;
        endcase
    end

    // TODO: Set pc_src = branch & branch_condition
    assign pc_src = branch & branch_condition;

endmodule
