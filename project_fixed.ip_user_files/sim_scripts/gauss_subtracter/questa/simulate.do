onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib gauss_subtracter_opt

do {wave.do}

view wave
view structure
view signals

do {gauss_subtracter.udo}

run -all

quit -force
