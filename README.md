# RISC-V Single Cycle CPU Core
RISC-V Single Cycle CPU Core Design &amp; Simulation & Bubble Sort Execution

### Project Overview

- **Purpose**
- Directly design and implement a single cycle CPU based on RISC-VRV32I
- Validates the behavior of the basic instruction set and understands the operating principles of the CPU's internal hardware
- **Development environment**
- Language/Tools used: **SystemVerilog, Vivado, C, RISC-V Assemblyer**
- Hardware design and simulation centered

---

### Architectural Design

- **Structure**
- Adoption of Harvard Architecture → command memory and data memory separation
- Parallel access → better performance
- **Support Command Set (RV32I)**
- 32-bit integer-based ISA
- 32 general purpose registers (including zero register)
- 32-bit address space (up to 4GB accessible)
- **Supports R, I, S, B, U, J type commands**

---

### major motion process

Implement basic operational flows of the CPU pipeline in a single cycle:

1. **Instruction Fetch (IF)** – Read commands from memory with PC values
2. **Instruction Decode (ID)** – Interpretation of commands and generation of control signals
3. **Execute (EX)** - Perform ALU operations (arithmetic, address calculation, comparison, etc.)
4. **Memory Access (MEM)** – Access Memory using Load/Store commands
5. **Write Back (WB)** – save operation results to register

---

### Verification by Command Type

- **R-Type**: ADD, SUB, SLL, SRL, SRA, SLT, SLTU, XOR, OR, AND → Check normal operation
- **I-Type (Load/Im)**: LB, LH, LW, LBU, LHU, ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI → Check for normal operation and sign extension, zero extension processing
- **S-Type**: SB, SH, SW → Validate operation of storing values in memory
- **B-Type**: Check PC change behavior based on BEQ, BNE, BLT, BGE, BLTU, BGE → branch conditions
- **U-Type**: LUI, AUIPC → Processing of Top 20 Bit Immediate, Verifying PC Relative Address Calculation Behavior
- **J-Type**: Check JAL, JALR → jump and return address storage capabilities

→ Simulate all commands **PASSED**

---

### Example of execution

- **Bubble Sort (Ascending)**
- Input: '{5, 4, 3, 2,1}'
- Execution result: '{1, 2, 3, 4, 5}'
- Runs the actual program on top of the CPU and verifies its operation

---

### Troubleshooting Experience

1. **Memory alignment issues**
- Address offset ([1:0]) processing is required for Load/Store per byte/halfword
- Solved with a case statement-based MUX design
- Misalignment is designed to be ignored in accordance with RISC-V specification
2. **Clocks Timing Analysis**
- Critical Path: Load Instruction 경로
- Due to the nature of the single cycle structure, all operations must operate on the longest path (T_clk)
- Verify inefficient clock usage → Recognize structural limitations

---

### achievements

- RV32I Command Set Complete Operation Verification
- Accumulate CPU operation flow (IF → ID → EX → MEM → WB) and hardware architecture design experience
- Validation of design reliability by running real alignment algorithms

---

### Direction of improvement and expansion

- **Multi-cycle structure**: Operational clock optimization → improved efficiency
- **Pipeline structure**: Parallel processing improves performance
- **UVM-based verification environment**: Apply various test scenarios and expand the scope of verification

---

### Your role

- Dedicated to designing and implementing CPU architecture
- Build a Command Set Simulation Environment and Create a Test Case
- Troubleshooting memory alignment and performing clock timing analysis
- Proceed with final verification (run bubble alignment)
