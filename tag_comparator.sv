module tag_comparator #(parameter int NUM_WAYS = 4, parameter int TAG_WIDTH = 20)
(
    input  logic [TAG_WIDTH-1:0]              tag_bits,
    input  logic [NUM_WAYS*TAG_WIDTH-1:0]     stored_tags,
    input  logic [NUM_WAYS-1:0]               valid_bits,
    output logic                              hit_bit,
    output logic [$clog2(NUM_WAYS)-1:0]       hit_way
);

always_comb begin
    //default hit_bit to zero and hit_way to zero
    hit_bit = 1'b0;
    hit_way = '0;
    for (int i = 0; i < NUM_WAYS; i++) begin
        if (tag_bits == stored_tags[i*TAG_WIDTH +: TAG_WIDTH] && valid_bits[i]) begin
            hit_bit = 1'b1;
            hit_way = i[$clog2(NUM_WAYS)-1:0];
        end
    end
end
endmodule
