onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mult_nd_multiplier_opt

do {wave.do}

view wave
view structure
view signals

do {mult_nd_multiplier.udo}

run -all

quit -force
