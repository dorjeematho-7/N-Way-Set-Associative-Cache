module lru_tracker #(
    parameter int NUM_WAYS = 4,
    parameter int NUM_SETS = 64
)(
    input  logic clk,
    input  logic rst,
    input  logic update,
    input  logic [$clog2(NUM_SETS)-1:0] updated_set,
    input  logic [$clog2(NUM_WAYS)-1:0] updated_way,
    output logic [$clog2(NUM_WAYS)-1:0] victim_way
);

    reg [$clog2(NUM_WAYS)-1:0] age [0:NUM_SETS-1][0:NUM_WAYS-1];

    // Update logic
    always_ff @(posedge clk) begin
        if (rst) begin
	//Give each way a unique age so there's a defined eviction order
            //Way 0 = age 0, Way 1 = age 1, Way 2 = age 2 ... and so on
            for (int s = 0; s < NUM_SETS; s++) begin
                for (int w = 0; w < NUM_WAYS; w++) begin
                    age[s][w] <= w[$clog2(NUM_WAYS)-1:0];
                end
            end
	end 
else if (update) begin
            age[updated_set][updated_way] <= 0; //this will occur on the at the end of a time cycle

            // RECALL THAT ONLY THE WAYS THAT HAVE A AGE LESS THAN THE ACCESSED UPDATE THEIR AGE SCORE
		//my logic is that the oldest way will always have age NUM_WAYS 
            for (int w = 0; w < NUM_WAYS; w++) begin
                if (w[$clog2(NUM_WAYS)-1:0] != updated_way) begin
                    if (age[updated_set][w] < age[updated_set][updated_way]) begin
                        age[updated_set][w] <= age[updated_set][w] + 1;
                    end
                end
            end
        end
    end

    // VICTIM SELECTION LOGIC
    // find the way with the highest age in the requested set
 always_comb begin
    victim_way = '0;
    for (int w = 0; w < NUM_WAYS; w++) begin
        if (age[updated_set][w] == NUM_WAYS - 1) begin
            victim_way = w;
        end
    end
end

endmodule
