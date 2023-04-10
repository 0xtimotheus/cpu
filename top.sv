import header::*

module single_cycle (
    input logic clk,
    input logic rst,
    input logic [0:255][0:63] ex_data
);
    // Decoder Signals
    opcode op;
    wire [0:4] addr_a;
    wire [0:4] addr_b;
    wire [0:4] write_addr;
    wire write_reg;
    wire write_mem;
    wire mem2reg;
    wire branch;

    // Control Signals
    wire instruction;
    wire instr_phase;

    // Register Signals
    wire [0:63] write_data;
    wire [0:63] operand_a;
    wire [0:63] operand_b;

    // ALU Signals
    wire [0:63] alu_result;

    // Mem Signals
    wire [0:7] mem_addr;
    wire [0:63] mem_result

    // Program Counter
    wire [0:7] pc;

    alu dp (
        .a(operand_a),
        .b(operand_b),
        .op(op),
        .y(alu_result)
    );

    assign write_data = mem2reg ? mem_result : alu_result;

    registers rg (
        .clk(clk), 
        .rst(rst), 
        .write_data(write_data), 
        .write_addr(write_addr),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .a(operand_a),
        .b(operand_b)
    );

    program_counter p (
        .clk(clk),
        .rst(rst),
        .enable(instr_phase),
        .branch(branch),
        .write_data(write_data),
        .pc(pc)
    );

    assign mem_addr = instr_phase ? pc : alu_result[0:7];

    memory io_bus(
        .clk(clk),
        .rst(rst)
        .addr(mem_addr),
        .write_data(operand_b),
        .write_enable(write_mem),
        .read_data(mem_result),
        .ex_data(ex_data),
    );

    decoder d(
        .instr(instruction),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .write_addr(write_addr),
        .write_reg(write_reg),
        .write_mem(write_mem),
        .mem2reg(mem2reg),
    );

    controller c(
        .clk(clk),
        .rst(rst),
        .instr_phase(instr_phase),
    )


endmodule