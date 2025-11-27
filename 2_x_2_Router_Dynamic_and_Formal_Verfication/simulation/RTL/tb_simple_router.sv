`include "design_includes.h"
`timescale 1ns/1ps

module tb_simple_router;

  // Clock + reset
  logic clk;
  logic rst_b;

  // Use the typedef from your RTL file:
  // typedef struct packed { ... } pkt_flit_t;
  // (do NOT re-declare it here)
  pkt_flit_t pkt_in [1:0];
  pkt_flit_t pkt_out[1:0];

  logic [1:0] fifo_full;

  // Instantiate DUT
  simple_router dut (
    .clk      (clk),
    .rst_b    (rst_b),
    .pkt_in   (pkt_in),
    .pkt_out  (pkt_out),
    .fifo_full(fifo_full)
  );

  // Clock generation: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset + init
  initial begin
    rst_b      = 0;
    pkt_in[0]  = '0;
    pkt_in[1]  = '0;

    repeat (1) @(posedge clk); // 0 ns
    rst_b = 1;
  end

 initial begin
 $display("T 		| rst |  IN0: v h t data      op txn	|  IN1: v h t data      op txn  |  OUT0: v h t data      |  OUT1: v h t data");

end


always @(posedge clk) begin


 $display("T=%0t    |      %b  |        %b %b %b %h  %0d   %0d |        %b %b %b %h  %0d   %0d |         %b %b %b %h |        %b %b %b %h",
           $time, rst_b,
           pkt_in[0].valid,  pkt_in[0].head,  pkt_in[0].tail,  pkt_in[0].data,
           pkt_in[0].output_port_num, pkt_in[0].txn_id,
		   pkt_in[1].valid,  pkt_in[1].head,  pkt_in[1].tail,  pkt_in[1].data,
           pkt_in[1].output_port_num, pkt_in[1].txn_id,
           pkt_out[0].valid, pkt_out[0].head, pkt_out[0].tail, pkt_out[0].data,
           pkt_out[1].valid, pkt_out[1].head, pkt_out[1].tail, pkt_out[1].data);

  /* if (dut.write[1])
      $display("T=%0t [FIFO1 WRITE] data=%h", $time, pkt_in[1].data);

    if (dut.read[1])
      $display("T=%0t [FIFO1 READ ] data=%h", $time, dut.fifo_out_pkt[1].data);

    if (dut.out_grant[0][1])
      $display("T=%0t [GRANT] input1 -> output0", $time);

    if (dut.out_grant[1][1])
      $display("T=%0t [GRANT] input1 -> output1", $time);*/

  end

  // Stimulus: send one 4-FLIT packet on input port 0 to output port 0
  initial begin
    // Wait for reset deassertion
    @(posedge rst_b);
    @(posedge clk);
$display("==input port 0 to output port 0======================================================================================================================");
    // HEAD
    pkt_in[0] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);

    // Middle 1
    pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h2, output_port_num:0, txn_id:0};
    @(posedge clk);

    // Middle 2
    pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h3, output_port_num:0, txn_id:0};
    @(posedge clk);

    // TAIL
    pkt_in[0] = '{head:0, tail:1, valid:1,
                  data:32'h4, output_port_num:0, txn_id:0};
    @(posedge clk);
	 // Stop driving (valid = 0)
    pkt_in[0].valid = 0;
    pkt_in[0].head  = 0;
    pkt_in[0].tail  = 0;
    pkt_in[0].data  = 0;
// Let the packet drain through the router
repeat(1) @(posedge clk);
$display("==input port 1 to output port 0======================================================================================================================");

 // Stimulus: send one 4-FLIT packet on input port 1 to output port 0
 
    // HEAD
    pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h5, output_port_num:0, txn_id:1};
    @(posedge clk);

    // Middle 1
    pkt_in[1] = '{head:0, tail:0, valid:1,
                  data:32'h6, output_port_num:0, txn_id:1};
    @(posedge clk);

    // Middle 2
    pkt_in[1] = '{head:0, tail:0, valid:1,
                  data:32'h7, output_port_num:0, txn_id:1};
    @(posedge clk);

    // TAIL
    pkt_in[1] = '{head:0, tail:1, valid:1,
                  data:32'h8, output_port_num:0, txn_id:1};
    @(posedge clk);
	pkt_in[1].valid = 0;
    pkt_in[1].head  = 0;
    pkt_in[1].tail  = 0;
    pkt_in[1].data  = 0;
// Let the packet drain through the router
repeat(1) @(posedge clk);
$display("==input port 0 to output port 1======================================================================================================================");

 // Stimulus: send one 4-FLIT packet on input port 0 to output port 1
 
    // HEAD
    pkt_in[0] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:1, txn_id:0};
    @(posedge clk);

    // Middle 1
    pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h2, output_port_num:1, txn_id:0};
  
    @(posedge clk);

    // TAIL
    pkt_in[0] = '{head:0, tail:1, valid:1,
                  data:32'h4, output_port_num:1, txn_id:0};
    @(posedge clk);
	 // Stop driving (valid = 0)
    pkt_in[0].valid = 0;
    pkt_in[0].head  = 0;
    pkt_in[0].tail  = 0;
    pkt_in[0].data  = 0;
// Let the packet drain through the router
repeat(1) @(posedge clk);
$display("==input port 1 to output port 1======================================================================================================================");

 // Stimulus: send one 4-FLIT packet on input port 1 to output port 1

    // HEAD
    pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:1, txn_id:1};
    @(posedge clk);

    // Middle 1
    pkt_in[1] = '{head:0, tail:0, valid:1,
                  data:32'h2, output_port_num:1, txn_id:1};
  
    @(posedge clk);

    // TAIL
    pkt_in[1] = '{head:0, tail:1, valid:1,
                  data:32'h4, output_port_num:1, txn_id:1};
    @(posedge clk);
pkt_in[1].valid = 0;
    pkt_in[1].head  = 0;
    pkt_in[1].tail  = 0;
    pkt_in[1].data  = 0;
// Let the packet drain through the router
repeat(1) @(posedge clk);
$display("==input port 1 to output port 1,input port 0 to output port 0=========================================================================================");
// Stimulus: send one 4-FLIT packet on input port 1 to output port 1
//send one 4-FLIT packet on input port 0 to output port 0

    // HEAD
    pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:1, txn_id:1};
	pkt_in[0] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);

    // Middle 1
    pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h2, output_port_num:1, txn_id:1};
	pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);

    // Middle 2
    pkt_in[1] = '{head:0, tail:0, valid:1,
                  data:32'h3, output_port_num:1, txn_id:1};
	pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);

    // TAIL
    pkt_in[1] = '{head:0, tail:1, valid:1,
                  data:32'h4, output_port_num:1, txn_id:1};
	pkt_in[0] = '{head:0, tail:1, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);
pkt_in[0].valid = 0;
    pkt_in[0].head  = 0;
    pkt_in[0].tail  = 0;
    pkt_in[0].data  = 0;

	pkt_in[1].valid = 0;
    pkt_in[1].head  = 0;
    pkt_in[1].tail  = 0;
    pkt_in[1].data  = 0;
// Let the packet drain through the router
repeat(1) @(posedge clk);

$display("==input port 1 to output port 0,input port 0 to output port 0=======================================================================================");
// Stimulus: send one 4-FLIT packet on input port 1 to output port 0
//send one 4-FLIT packet on input port 0 to output port 0

    // HEAD
    pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:0, txn_id:1};
	pkt_in[0] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);

    // Middle 1
    pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h2, output_port_num:0, txn_id:1};
	pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);

    // Middle 2
    pkt_in[1] = '{head:0, tail:0, valid:1,
                  data:32'h3, output_port_num:0, txn_id:1};
	pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);

    // TAIL
    pkt_in[1] = '{head:0, tail:1, valid:1,
                  data:32'h4, output_port_num:0, txn_id:1};
	pkt_in[0] = '{head:0, tail:1, valid:1,
                  data:32'h1, output_port_num:0, txn_id:0};
    @(posedge clk);
pkt_in[0].valid = 0;
    pkt_in[0].head  = 0;
    pkt_in[0].tail  = 0;
    pkt_in[0].data  = 0;

	pkt_in[1].valid = 0;
    pkt_in[1].head  = 0;
    pkt_in[1].tail  = 0;
    pkt_in[1].data  = 0;
// Let the packet drain through the router
repeat(1) @(posedge clk);

$display("==input port 1 to output port 1,input port 0 to output port 1==============================================================================================");
// Stimulus: send one 4-FLIT packet on input port 1 to output port 1
//send one 4-FLIT packet on input port 0 to output port 1

    // HEAD
    pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:1, txn_id:1};
	pkt_in[0] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:1, txn_id:0};
    @(posedge clk);

    // Middle 1
    pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h2, output_port_num:1, txn_id:1};
	pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h1, output_port_num:1, txn_id:0};
    @(posedge clk);

    // Middle 2
    pkt_in[1] = '{head:0, tail:0, valid:1,
                  data:32'h3, output_port_num:1, txn_id:1};
	pkt_in[0] = '{head:0, tail:0, valid:1,
                  data:32'h1, output_port_num:1, txn_id:0};
    @(posedge clk);

    // TAIL
    pkt_in[1] = '{head:0, tail:1, valid:1,
                  data:32'h4, output_port_num:1, txn_id:1};
	pkt_in[0] = '{head:0, tail:1, valid:1,
                  data:32'h1, output_port_num:1, txn_id:0};
    @(posedge clk);
pkt_in[1] = '{head:1, tail:0, valid:1,
                  data:32'h1, output_port_num:1, txn_id:1};

 pkt_in[0].valid = 0;
    pkt_in[0].head  = 0;
    pkt_in[0].tail  = 0;
    pkt_in[0].data  = 0;

 @(posedge clk);

    // TAIL
    pkt_in[1] = '{head:0, tail:1, valid:1,
                  data:32'h4, output_port_num:1, txn_id:1};
 @(posedge clk);

    pkt_in[1] = '{head:0, tail:0, valid:1,
                  data:32'h4, output_port_num:1, txn_id:1};
 @(posedge clk);

    // TAIL
    pkt_in[1] = '{head:0, tail:1, valid:1,
                  data:32'h4, output_port_num:1, txn_id:1};
// Let the packet drain through the router
repeat(1) @(posedge clk);
$display("==============================================================================================================");


    // Stop driving (valid = 0)
    pkt_in[0].valid = 0;
    pkt_in[0].head  = 0;
    pkt_in[0].tail  = 0;
    pkt_in[0].data  = 0;

	pkt_in[1].valid = 0;
    pkt_in[1].head  = 0;
    pkt_in[1].tail  = 0;
    pkt_in[1].data  = 0;

    // Let the packet drain through the router
    repeat (5) @(posedge clk);
    $finish;
  end

endmodule
