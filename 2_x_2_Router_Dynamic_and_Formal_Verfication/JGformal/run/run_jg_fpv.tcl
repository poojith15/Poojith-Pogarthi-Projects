clear -all

# Set session name
session -set_name router_FPV

# Analyze design files
analyze -sv -f ../RTL/filelist

# Elaborate the design with top module
elaborate -top simple_router

# Set up clock and reset
clock clk
reset -expression {!rst_b}

# Set proof time limit
set_prove_time_limit 60s

# Prove all properties
prove -all
