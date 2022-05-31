set_property IOSTANDARD LVCMOS33 [get_ports {LED_display[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_display[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_display[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_display[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_display[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_display[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_display[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_display[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_pos[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_pos[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_pos[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_pos[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
set_property PACKAGE_PIN W7 [get_ports {LED_display[0]}]
set_property PACKAGE_PIN W6 [get_ports {LED_display[1]}]
set_property PACKAGE_PIN U8 [get_ports {LED_display[2]}]
set_property PACKAGE_PIN V8 [get_ports {LED_display[3]}]
set_property PACKAGE_PIN U5 [get_ports {LED_display[4]}]
set_property PACKAGE_PIN V5 [get_ports {LED_display[5]}]
set_property PACKAGE_PIN U7 [get_ports {LED_display[6]}]
set_property PACKAGE_PIN V7 [get_ports {LED_display[7]}]
set_property PACKAGE_PIN U2 [get_ports {LED_pos[0]}]
set_property PACKAGE_PIN U4 [get_ports {LED_pos[1]}]
set_property PACKAGE_PIN V4 [get_ports {LED_pos[2]}]
set_property PACKAGE_PIN W4 [get_ports {LED_pos[3]}]
set_property PACKAGE_PIN V17 [get_ports {SW[0]}]
set_property PACKAGE_PIN V16 [get_ports {SW[1]}]
set_property PACKAGE_PIN W16 [get_ports {SW[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clkin_n]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property PACKAGE_PIN U18 [get_ports clkin_n]
set_property PACKAGE_PIN T18 [get_ports reset]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clkin_n]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]