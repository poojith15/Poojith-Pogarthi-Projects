set_fml_appmode AEP
set design simple_router
set_fml_var fml_aep_unique_name true

##enable VC Formal to dump FSM report
set_app_var fml_enable_fsm_report_complexity true
set_app_var fml_trace_auto_fsm_state_extraction true

set INCLUDE_PATH ../RTL/design_includes     ;# or wherever design_includes.h is
#read_file -format sverilog ../RTL/design_includes.h
#read_file -format sverilog ../RTL/output_port_arbiter.sv
#read_file -format sverilog ../RTL/router_fifo.sv
read_file -top $design -format sverilog -aep all+fsm_deadlock \
   -vcs "+incdir+$INCLUDE_PATH ../RTL  ../RTL/design_includes.h ../RTL/output_port_arbiter.sv ../RTL/router_fifo.sv ../RTL/simple_router.sv" 
#../RTL/design_includes.h \
 #   ../RTL/output_port_arbiter.sv \
 #  ../RTL/router_fifo.sv \
 #  ../RTL/simple_router.sv


# Enable FSM checks explicitly
#set_app_var aep_fsm_deadlock true
#set_app_var aep_fsm_livelock true  
#set_app_var aep_fsm_unionlock true


## you could add one switch at a time to check for certain properties
#read_file -top $design -format sverilog -aep all+fsm_deadlock -vcs"+incdir+../RTL" {../RTL/simple_router.sv}

create_clock clk -period 100 
create_reset rst_b -sense high

sim_run -stable 
sim_save_reset

aep_generate -type fsm_fairness
