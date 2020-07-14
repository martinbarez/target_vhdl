onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib gauss_multiplier_opt

do {wave.do}

view wave
view structure
view signals

do {gauss_multiplier.udo}

run -all

quit -force
