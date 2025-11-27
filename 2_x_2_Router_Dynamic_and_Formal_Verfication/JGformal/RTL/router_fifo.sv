module router_fifo #(parameter DEPTH = 2, PTR_WIDTH = $clog2(DEPTH))
(
   input  logic   clk,
   input  logic   rst_b,

   input logic    write, 
   input logic    read, 
   input pkt_flit_t fifo_in_pkt, //data to be put in fifo

   output pkt_flit_t fifo_out_pkt,  
   output logic fifo_full,
   output logic fifo_empty
);

pkt_flit_t fifo_mem[DEPTH-1:0];
logic [PTR_WIDTH-1 : 0] rd_ptr;
logic [PTR_WIDTH-1 : 0] wr_ptr;
logic [PTR_WIDTH : 0] count;
   
// Synchronous write and pointer update behavior   
always_ff @(posedge clk or negedge rst_b)
begin
   // Asynchronous reset
   if(~rst_b) begin
      wr_ptr     <= '0;  
      rd_ptr     <= '0;      
      count <= '0;
      for(int i = 0; i < DEPTH; i++) begin
         fifo_mem[i] <= '0;
      end
   end  
   else begin
   if(write && !fifo_full) begin
         fifo_mem[wr_ptr] <= fifo_in_pkt;  // If we receive a write command, store the input packet to the slot pointed to by write pointer
         wr_ptr <= wr_ptr + 1'b1;          // Also increment the write pointer
   end
   
   if(read && !fifo_empty && !write) begin
	  count <= count - 1;
   end   
   else if(write && !fifo_full && !read) begin
	  count <= count + 1;
   end   
       if(read && !fifo_empty) begin     // Combinationa Loop
	rd_ptr <= rd_ptr + 1;
       end   
   end

 
end   

assign fifo_empty = (count == 0) ? 1'b1 : 1'b0;                            
assign fifo_full = (count == DEPTH) ? 1'b1 : 1'b0;
assign fifo_out_pkt = fifo_mem[rd_ptr];

endmodule
