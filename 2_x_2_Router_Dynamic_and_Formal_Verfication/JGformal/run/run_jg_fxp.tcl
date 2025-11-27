#  Clean previous session
clear -all

#Analyze RTL files (use whichever applies)
analyze -sv \
    ../RTL/design_includes.h \
    ../RTL/simple_router.sv \
    ../RTL/router_fifo.sv \
    ../RTL/output_port_arbiter.sv \
    ../RTL/router_assumptions.sva \
    ../RTL/router_assertions.sva \
    ../RTL/bind_file.sva

check_xprop -init
#Elaborate the design
set design simple_router
elaborate -top $design

#Optional: get design info to list design summary
get_design_info


#Clock and Reset setup
clock clk
reset !rst_b

#------------------------------------------------------------
#Sanity check of Clock, Reset, Assumptions
#To verify clock/reset setup
sanity_check

#To debug/analyze reset phase
visualize -reset

#FXP simulation
#check_xprop -init

#------------------------------------------------------------
#Run proofs
prove -all

#------------------------------------------------------------
#Optional reports
report -file results_summary_fxp -detailed
