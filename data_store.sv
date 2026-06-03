module data_store #(
    parameter int NUM_WAYS   = 4,   
    parameter int NUM_SETS   = 64,  
    parameter int TAG_WIDTH  = 20,
    parameter int LINE_SIZE  = 512, // 64 bytes (cache line)
    parameter int WORD_SIZE  = 32   // 4 bytes (CPU word)
)(

    input  logic clk,
    input  logic rst,
    

//Read Port
    input  logic [$clog2(NUM_SETS)-1:0]   set_indx,    // which set to read, Reminder that clog calcualtes the number of bits needed to represent NUM_SETS number
    input  logic [$clog2(NUM_WAYS)-1:0]   way_indx,    // which way's data to output
//Write Port
	input logic WE,
	input logic [$clog2(NUM_SETS)-1:0]wr_set,
	input logic [$clog2(NUM_WAYS)-1:0]wr_way,
	input logic wr_dirty,
	input logic [TAG_WIDTH-1:0]wr_tag,
	input logic [LINE_SIZE - 1:0]data_in,
//Output Ports
	output logic [NUM_WAYS * TAG_WIDTH - 1:0] tags_out,
	output logic [NUM_WAYS-1:0]valid_bits,
	output logic [NUM_WAYS-1:0]dirty_bits,
	output logic [LINE_SIZE- 1:0]data_out

);
//pesudo code
/*
if we are doing a read then we leave we  = 0 and then we set the correct set indx and way indx and then return the outputs such as tags_out, valid_bits, dirty_bits and data_out

	if we are doing a write
 	if its a write
		 we set we = 1 and then set the way and set and then set dirty to 1 since we are doing a write and then specify the tag and data that is being written

	if its a fill
		we set we = 1 and then dirty = 0  and setting the set and way and then specifiy the tag and data written in
*/

	//STORAGE LIVES HERE
	reg valid_array[NUM_SETS-1:0][NUM_WAYS-1:0];
	reg dirty_array[NUM_SETS-1:0][NUM_WAYS-1:0];
	reg [TAG_WIDTH-1:0]tags_array[NUM_SETS-1:0][NUM_WAYS-1:0];
	reg [LINE_SIZE-1:0]data_array[NUM_SETS-1:0][NUM_WAYS-1:0];
//Read Logic
	//output the data in the correct way
	always_comb begin
		data_out = data_array[set_indx][way_indx];
	end
	//output the tags, dirty bits, and valid bits
	always_comb begin
		for (int i = 0; i < NUM_WAYS; i++) begin
			dirty_bits[i] = dirty_array[set_indx][i];
			valid_bits[i] = valid_array[set_indx][i];
			tags_out[i*TAG_WIDTH +: TAG_WIDTH] = tags_array[set_indx][i]; // +; means start at this bit and take tagwidth amount going up
		end
	end

//Write Logic
	//since we are storing values here the logic must be sequential
		always_ff @(posedge clk) begin
		if (rst) begin
			for (int s = 0; s < NUM_SETS; s++) begin
				for (int w = 0; w < NUM_WAYS; w++) begin
					valid_array[s][w] <= 1'b0;
					dirty_array[s][w] <= 1'b0;
				end
			end
		end else if (WE) begin
			valid_array[wr_set][wr_way] <= 1'b1;
			dirty_array[wr_set][wr_way] <= wr_dirty;
			tags_array[wr_set][wr_way]  <= wr_tag;
			data_array[wr_set][wr_way]  <= data_in;
		end
	end
endmodule
