module cacheFSM #(
    parameter int NUM_WAYS = 4,
    parameter int NUM_SETS = 64,
    parameter int TAG_WIDTH = 20,
    parameter int LINE_SIZE = 512, // 64 bytes (cache line)
    parameter int WORD_SIZE = 32,  // 4 bytes  (CPU word)
    parameter int ADDR_WIDTH = 32,  // 32 bit address for future RISC V compatibility

    // derived, do not override
    localparam int SET_BITS = $clog2(NUM_SETS),          // 6
    localparam int WAY_BITS = $clog2(NUM_WAYS),          // 2
    localparam int OFFSET_BITS = $clog2(LINE_SIZE/8),       // 6  (byte offset inside the line)
    localparam int WORD_SEL = $clog2(LINE_SIZE/WORD_SIZE)// 4  (which word of the line)
)(
    input  logic clk,
    input  logic rst,

//CPU Side (request in / response out)
    input  logic cpu_req,      // CPU wants an access this cycle
    input  logic cpu_we,       // 1 = store, 0 = load
    input  logic [ADDR_WIDTH-1:0]cpu_addr,     // {tag, set_indx, byte offset}
    input  logic [WORD_SIZE-1:0]cpu_wdata,    // word to store
    output logic [WORD_SIZE-1:0]cpu_rdata,    // word returned on a load
    output logic cpu_done,     // pulses when the access is finished
    output logic cpu_stall,    // hold the CPU while we miss / write back

//To Tag Comparator
    output logic [TAG_WIDTH-1:0] tag_bits,     // tag field of the address being looked up
    input  logic hit_bit,      // comparator says the line is present
    input  logic [WAY_BITS-1:0] hit_way,      // which way it hit in

//To Data Store, read port
    output logic [SET_BITS-1:0] set_indx,     // set to read this cycle
    output logic [WAY_BITS-1:0] way_indx,     // way whose line we want on data_out
//To Data Store, write port
    output logic WE,
    output logic [SET_BITS-1:0] wr_set,
    output logic [WAY_BITS-1:0] wr_way,
    output logic wr_dirty, // 1 on a CPU store, 0 on a fill from memory
    output logic [TAG_WIDTH-1:0] wr_tag,
    output logic [LINE_SIZE-1:0] data_in,      // full line written back into the array
//From Data Store
    input  logic [NUM_WAYS*TAG_WIDTH-1:0] ds_tags_out,   // feeds the comparator's stored_tags
    input  logic [NUM_WAYS-1:0] ds_valid_bits,
    input  logic [NUM_WAYS-1:0] ds_dirty_bits, // tells us if the victim needs a write back
    input  logic [LINE_SIZE-1:0] ds_data_out,   // selected line, we slice the word out of it

//To LRU Tracker
    output logic lru_update,     // assert on a hit or after a fill
    output logic [SET_BITS-1:0] lru_set,
    output logic [WAY_BITS-1:0] lru_way,        // the way we just touched
    input  logic [WAY_BITS-1:0] victim_way,     // way to evict when the set is full

//To Main Memory (mem_model.sv)
    output logic mem_req,
    output logic mem_we, // 1 = write back a dirty line, 0 = fill
    output logic [ADDR_WIDTH-1:0]  mem_addr,       // line aligned address
    output logic [LINE_SIZE-1:0]  mem_wdata,      // dirty line on its way out
    input  logic mem_ready, // memory has finished / data is valid
    input  logic [LINE_SIZE-1:0] mem_rdata       // line coming back from memory
);



parameter [1:0] IDLE = 2'b00,
                REQ = 2'b01,
                READ = 2'b10,
                WRITEB = 2'b11;







endmodule
