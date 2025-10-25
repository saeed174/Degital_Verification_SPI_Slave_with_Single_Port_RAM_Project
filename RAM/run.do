vlib work
vlog -f src_files.list -cover bcesf +cover +acc -covercells
vsim -coverage -voptargs=+acc work.RAM_top -classdebug -uvmcontrol=all
run 0
coverage save RAM_top.ucdb -onexit
add wave -position insertpoint sim:/RAM_top/RAM_if_inst/*
add wave -position insertpoint sim:/RAM_top/DUT/*
add wave -position insertpoint sim:/RAM_top/RAM_if_ref_inst/*
add wave -position insertpoint  \
sim:/RAM_top/DUT/MEM

run -all
coverage report -assert -detail -output assertion_report.txt
vcover report RAM_top.ucdb -details -annotate -all -output coverage_rpt.txt
coverage report -detail -cvg -directive -comments -output fcover_report.txt