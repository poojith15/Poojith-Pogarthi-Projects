module simple_router(
input logic clk,
input logic rst_b,

input pkt_flit_t pkt_in[1:0],
output pkt_flit_t pkt_out[1:0],

//flow control
output logic [1:0] fifo_full
);

//local signals 
logic [1:0] out_grant[1:0]; //if out_grant[0] == 1, some output port gave grant to input 0. If out_grant[1] == 1, some output port gave grant to input 1
logic [1:0] out_req[1:0]; //out_req[0] == 2 bit signal, out_req[0][0] = input0 req going to output port 0, out_req[0][1] = input 0 req going to output port 1

logic [1:0] fifo_empty;
logic [1:0] write, read;
pkt_flit_t fifo_out_pkt[1:0]; //fifo_out_pkt[0] == read data from fifo 0. fifo_out_pkt[1] == read data from fifo 1

logic [1:0] mask [1:0];


genvar i;
generate
for(i = 0; i < 2; i++) begin : router_inp_fifo
	assign write[i] = pkt_in[i].valid;
	assign read[i] = out_grant[0][i] || out_grant[1][i];
	router_fifo i_router_fifo(.clk(clk),
				.rst_b(rst_b),
				.write(write[i]),
				.read(read[i]),
				.fifo_in_pkt(pkt_in[i]),
				.fifo_out_pkt(fifo_out_pkt[i]),
				.fifo_full(fifo_full[i]),
				.fifo_empty(fifo_empty[i])
				);
end : router_inp_fifo
endgenerate

assign out_req[0][0] = !fifo_empty[0] ? (fifo_out_pkt[0].output_port_num == 0) && mask[0][0] : 1'b0;
assign out_req[0][1] = !fifo_empty[1] ? (fifo_out_pkt[1].output_port_num == 0) && mask[0][1] : 1'b0;    // bug fix
assign out_req[1][0] = !fifo_empty[0] ? (fifo_out_pkt[0].output_port_num == 1) && mask[1][0] : 1'b0;    // bug fix
assign out_req[1][1] = !fifo_empty[1] ? (fifo_out_pkt[1].output_port_num == 1) && mask[1][1] : 1'b0; 



genvar j;
generate
for(j = 0; j < 2; j++) begin : out_arb
	output_port_arbiter i_out_port_arb(.clk(clk), .rst_b(rst_b), .out_req(out_req[j]), .out_grant(out_grant[j]));
end : out_arb
endgenerate

//mask generation
always_ff @(posedge clk or negedge rst_b) begin
    if(!rst_b) begin
	mask[0] <= '1;
	mask[1] <= '1;
    end
    else begin
	if((out_grant[0][0] && fifo_out_pkt[0].tail) || (out_grant[0][1] && fifo_out_pkt[1].tail)) begin 
		mask[0] <= 2'h3;     // bug fix
	end
	else if (out_grant[0][0]) begin
		mask[0] <= 2'h1;
	end
	else if(out_grant[0][1]) begin
		mask[0] <= 2'h2;
	end

	if((out_grant[1][0] && fifo_out_pkt[0].tail) || (out_grant[1][1] && fifo_out_pkt[1].tail)) begin 
		mask[1] <= 2'h3;    // bug fix
	end
	else if (out_grant[1][0]) begin
		mask[1] <= 2'h1;
	end
	else if(out_grant[1][1]) begin
		mask[1] <= 2'h2;
	end
    end
end

//generating outout pkt
assign pkt_out[0] = out_grant[0][0] ? fifo_out_pkt[0] : out_grant[0][1] ? fifo_out_pkt[1] : '0;
assign pkt_out[1] = out_grant[1][0] ? fifo_out_pkt[0] : out_grant[1][1] ? fifo_out_pkt[1] : '0;

endmodule
