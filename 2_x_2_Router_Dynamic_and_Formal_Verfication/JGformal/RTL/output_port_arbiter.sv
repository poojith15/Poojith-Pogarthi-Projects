module output_port_arbiter
#(
	NUM_OF_INPS = 2, PTR_WIDTH = $clog2(NUM_OF_INPS)
	) (
	input logic clk,
	input logic rst_b,
	input logic [NUM_OF_INPS-1 : 0] out_req,
	//output grant
	output logic [NUM_OF_INPS-1 : 0] out_grant
	);


logic [PTR_WIDTH-1 : 0] priority_ptr;
logic [PTR_WIDTH-1 : 0] index;

always_ff @(posedge clk or negedge rst_b) 
begin
    if(!rst_b) 
    begin
	priority_ptr <= '0;
    end
    else 
    begin
	for(int i = 0; i < NUM_OF_INPS; i++)
	begin	
		if(out_grant[i]) 
		begin
			priority_ptr <= i + 1'b1; 
		end
	end
    end
end

always_comb begin
    out_grant = '0;
    index = priority_ptr;

    for(int i = 0; i < NUM_OF_INPS; i++)
    begin
	if(out_req[index]) 
	begin
	    out_grant[index] = 1'b1;
	    break;
	end
	else begin
	    index = index+1;
	end
    end
end



endmodule 
