module cpu_register (
    input logic clk,
    input wire rst,
    input logic write_enable,
    input logic [0:63] write_data,
    input logic [0:4] write_addr,
    input logic [0:4] addr_a,
    input logic [0:4] addr_b,

    output reg [0:63] a,
    output reg [0:63] b
);

    reg [0:32][0:63] store;

    always_ff @( posedge clk, negedge rst ) begin
        a <= store[addr_a];
        b <= store[addr_b];
        if(~rst) begin
            store = '{default: 0};
        end else begin
            store[write_addr] <= write_enable ? write_data : store[write_addr];
        end 
    end
    
endmodule