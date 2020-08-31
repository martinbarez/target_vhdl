create_clock -period 5.000 -name clk -waveform {0.000 2.500} [get_ports clk]
set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {cov_fifo_dout[*]}]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports {cov_fifo_dout[*]}]
set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {mean_fifo_dout[*]}]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports {mean_fifo_dout[*]}]
set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports cov_fifo_empty]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports cov_fifo_empty]
set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports mean_fifo_empty]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports mean_fifo_empty]
set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports rst]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports rst]
set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports start]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports start]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {res_fifo_din[*]}]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports {res_fifo_din[*]}]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports cov_fifo_rd_en]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports cov_fifo_rd_en]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports mean_fifo_rd_en]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports mean_fifo_rd_en]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports ready]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports ready]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports res_fifo_wr_en]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports res_fifo_wr_en]







