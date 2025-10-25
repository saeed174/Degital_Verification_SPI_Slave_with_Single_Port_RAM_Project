vlib work
vlog -f src_files.list +define+SIM -cover bcesf +cover +acc -covercells
vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all -sv_seed 247777025
coverage save top.ucdb -onexit
add wave -position insertpoint sim:/top/if_c/*
run 0
run -all