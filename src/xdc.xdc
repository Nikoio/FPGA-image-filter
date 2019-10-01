##Clock signal
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports clk_in_125]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports clk_in_125]

#set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports ext_res]
#set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports ext_res2]
#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports ext_res_vtc]
#set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports ext_res_ce]

set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports selector]




##Pmod Header JD
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {data[0]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports {data[1]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {data[2]}]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports reset]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports pclk]
#set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports exp]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports iic_rtl_sda_io]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports iic_rtl_scl_io]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets pclk_IBUF]
create_clock -period 40.000 -name pclk_25mhz -waveform {0.000 20.000} -add [get_ports pclk]

##Pmod Header JE
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {data[6]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {data[5]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {data[4]}]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {data[3]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports xclk]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {data[7]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports ln]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports fm]

##VGA Connector
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {RED[0]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {RED[1]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {RED[2]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {RED[3]}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports {RED[4]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {GREEN[0]}]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports {GREEN[1]}]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {GREEN[2]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {GREEN[3]}]
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports {GREEN[4]}]
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports {GREEN[5]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports {BLUE[0]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {BLUE[1]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports {BLUE[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {BLUE[3]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {BLUE[4]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports vid_hsync]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports vid_vsync]

##LEDs
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports locked]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports vtg_ce]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports vtc_lock]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports underflow]

set_property IOB TRUE [get_ports {data[*] fm ln}]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]


