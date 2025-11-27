vlib work
#vmap work work

vlog ../RTL/output_port_arbiter.sv
vlog ../RTL/router_fifo.sv
vlog ../RTL/simple_router.sv

vlog ../RTL/tb_simple_router.sv

vsim -voptargs=+acc work.tb_simple_router

# Add waveform signals - Testbench level
add wave -radix hexadecimal sim:/tb_simple_router/clk
add wave -radix hexadecimal sim:/tb_simple_router/rst_b
add wave -radix hexadecimal sim:/tb_simple_router/pkt_in



# Add waveform signals - DUT internal signals
add wave -radix hexadecimal sim:/tb_simple_router/dut/write
add wave -radix hexadecimal sim:/tb_simple_router/dut/fifo_empty
add wave -radix hexadecimal sim:/tb_simple_router/fifo_full
add wave -radix hexadecimal sim:/tb_simple_router/dut/mask
add wave -radix hexadecimal sim:/tb_simple_router/dut/out_req
add wave -radix hexadecimal sim:/tb_simple_router/dut/out_grant
add wave -radix hexadecimal sim:/tb_simple_router/dut/read
add wave -radix hexadecimal sim:/tb_simple_router/dut/fifo_out_pkt
add wave -radix hexadecimal sim:/tb_simple_router/pkt_out



run 2 us
