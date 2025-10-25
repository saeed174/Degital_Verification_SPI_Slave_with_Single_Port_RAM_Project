vlib work
vlog -f src_files.list +define+SIM -cover bcesf +cover +acc -covercells
vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all -sv_seed random
coverage save top.ucdb -onexit
#add wave -position insertpoint sim:/top/if_wrapper/*
add wave -position insertpoint sim:/top/Wrapper_inst/if_c/*
run 0
run -all