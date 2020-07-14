onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mean_subtracter_opt

do {wave.do}

view wave
view structure
view signals

do {mean_subtracter.udo}

run -all

quit -force
