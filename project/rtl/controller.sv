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
// CONTROL UNIT MODULE
// =============================================================================

module controller (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       reg_write,
    output logic [2:0] imm_src,
    output logic       alu_src,
    output logic       mem_write,
    output logic       result_src,
    output logic       branch,
    output logic       jump,
    output logic [3:0] alu_control
);

    logic [1:0] alu_op;

    always_comb begin
        // Default values
        reg_write   = 1'b0;
        imm_src     = 3'b000;
        alu_src     = 1'b0;
        mem_write   = 1'b0;
        result_src  = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        alu_control = 4'b0000;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1'b1;
                alu_src   = 1'b0;
                result_src = 1'b0;
                case ({funct7[5], funct3})
                    4'b0000: alu_control = 4'b0000; // ADD
                    4'b1000: alu_control = 4'b0001; // SUB
                    4'b0001: alu_control = 4'b0010; // SLL
                    4'b0010: alu_control = 4'b0011; // SLT
                    4'b0011: alu_control = 4'b0100; // SLTU
                    4'b0100: alu_control = 4'b0101; // XOR
                    4'b0101: alu_control = 4'b0110; // SRL
                    4'b1101: alu_control = 4'b0111; // SRA
                    4'b0110: alu_control = 4'b1000; // OR
                    4'b0111: alu_control = 4'b1001; // AND
                    default: alu_control = 4'b0000;
                endcase
            end

            7'b0010011: begin // I-type (ALU immediate)
                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_src   = 3'b000; // I-type
                result_src = 1'b0;
                case (funct3)
                    3'b000: alu_control = 4'b0000; // ADDI
                    3'b010: alu_control = 4'b0011; // SLTI
                    3'b011: alu_control = 4'b0100; // SLTIU
                    3'b100: alu_control = 4'b0101; // XORI
                    3'b110: alu_control = 4'b1000; // ORI
                    3'b111: alu_control = 4'b1001; // ANDI
                    3'b001: alu_control = 4'b0010; // SLLI
                    3'b101: alu_control = (funct7 == 7'b0000000) ? 4'b0110 : 4'b0111; // SRLI/SRAI
                    default: alu_control = 4'b0000;
                endcase
            end

            7'b0000011: begin // Load (e.g. LW)
                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_src   = 3'b000; // I-type
                result_src = 1'b1;  // result from memory
                alu_control = 4'b0000; // ADD address
            end

            7'b0100011: begin // Store (e.g. SW)
                reg_write = 1'b0;
                alu_src   = 1'b1;
                imm_src   = 3'b001; // S-type
                mem_write = 1'b1;
                alu_control = 4'b0000; // ADD address
            end

            7'b1100011: begin // Branch
                reg_write = 1'b0;
                imm_src   = 3'b010; // B-type
                branch    = 1'b1;
                alu_control = 4'b0001; // SUB (for comparison)
            end

            7'b1101111: begin // JAL
                reg_write = 1'b1;
                imm_src   = 3'b011; // J-type
                jump      = 1'b1;
                result_src = 1'b0; // write PC+4
            end

            7'b0110111: begin // LUI
                reg_write = 1'b1;
                imm_src   = 3'b100; // U-type
                alu_src   = 1'b1;
                alu_control = 4'b1111; // LUI passthrough
                result_src = 1'b0;
            end

            default: begin
                // Unsupported
            end
        endcase
    end
endmodule