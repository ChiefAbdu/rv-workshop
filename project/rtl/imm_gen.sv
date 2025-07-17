// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// Single-Cycle RISC-V Processor - Immediate Generator (Workshop Skeleton Version)
// =============================================================================

module immgen (
    input  logic [31:0] instruction,
    input  logic [2:0]  imm_src,
    output logic [31:0] imm_ext
);

    always_comb begin
        case (imm_src)
            3'b000: // I-type (Example completed)
                imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            
            // TODO: Implement remaining immediate types
            // 3'b001: S-type
            // 3'b010: B-type
            // 3'b011: U-type
            // 3'b100: J-type

            default:
                imm_ext = 32'h0000_0000;
        endcase
    end

endmodule
