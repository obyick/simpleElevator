onerror {quit -f}
vlib work
vlog -work work ELEVADOR.vo
vlog -work work ELEVADOR.vt
vsim -novopt -c -t 1ps -L cycloneiv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.ELEVADOR_vlg_vec_tst
vcd file -direction ELEVADOR.msim.vcd
vcd add -internal ELEVADOR_vlg_vec_tst/*
vcd add -internal ELEVADOR_vlg_vec_tst/i1/*
add wave /*
run -all
