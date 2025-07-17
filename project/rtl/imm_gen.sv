// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Abdullah Nadeem (@ChiefAbdu)
// =============================================================================
// Single-Cycle RISC-V Processor - Immediate Generator (Workshop Skeleton Version)
// =============================================================================

module imm_gen (
    input  logic [31:0] instruction,
    input  logic [2:0]  imm_src,
    output logic [31:0] imm_ext
);

    always_comb begin
        case (imm_src)
            3'b000: // I-type
                imm_ext = {{20{instruction[31]}}, instruction[31:20]};

            3'b001: // S-type
                imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            3'b010: // B-type
                imm_ext = {{19{instruction[31]}}, instruction[31], instruction[7],
                            instruction[30:25], instruction[11:8], 1'b0};

            3'b011: // U-type
                imm_ext = {instruction[31:12], 12'b0};

            3'b100: // J-type
                imm_ext = {{11{instruction[31]}}, instruction[31],
                            instruction[19:12], instruction[20],
                            instruction[30:21], 1'b0};

            default:
                imm_ext = 32'b0;
        endcase
    end

endmodule
