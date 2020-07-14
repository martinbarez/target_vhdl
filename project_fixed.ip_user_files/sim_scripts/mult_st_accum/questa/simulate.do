onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mult_st_accum_opt

do {wave.do}

view wave
view structure
view signals

do {mult_st_accum.udo}

run -all

quit -force
