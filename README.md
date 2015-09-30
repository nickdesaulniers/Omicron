# Omicron

Omicron is a general purpose, pipelined CPU written in the Verilog hardware
description language. It is designed to be compiled and run on a Xilinx
Spartan-3E FPGA evaluation board. The Omicron contains five stages: Instruction
Fetch, Instruction Decode, Execute, Memory, Write Back. By splitting the CPU
into pipelined stages, the clock speed can be increased causing an increased
throughput compared to a non-pipelined CPU.

My friend Cody Cziesler and I designed and implemented this processor in
college (2011).  We attended Rochester Institute of Technology (RIT), and both
Computer Engineering majors.  We designed this processor in 0306-550 Computer
Organization and refined/implemented/tested it on an FPGA in 0306-561 Digital
Systems Design.

# License

Omicron, a general purpose, pipelined CPU
Copyright (C) 2011  Cody Cziesler, Nick Desaulniers

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.

