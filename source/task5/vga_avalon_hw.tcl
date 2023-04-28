# TCL File Generated by Component Editor 19.1
# Fri Apr 28 10:42:11 PDT 2023
# DO NOT MODIFY


# 
# vga_avalon "vga_avalon" v1.0
# Alex Manak 2023.04.28.10:42:11
# VGA Avalon Interface
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module vga_avalon
# 
set_module_property DESCRIPTION "VGA Avalon Interface"
set_module_property NAME vga_avalon
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Alex_Manak
set_module_property AUTHOR "Alex Manak"
set_module_property DISPLAY_NAME vga_avalon
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL vga_avalon
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file vga_avalon.sv SYSTEM_VERILOG PATH vga_avalon.sv TOP_LEVEL_FILE
add_fileset_file vga_adapter.sv SYSTEM_VERILOG PATH ../vga-core/vga_adapter.sv
add_fileset_file vga_address_translator.sv SYSTEM_VERILOG PATH ../vga-core/vga_address_translator.sv
add_fileset_file vga_controller.sv SYSTEM_VERILOG PATH ../vga-core/vga_controller.sv
add_fileset_file vga_pll.sv SYSTEM_VERILOG PATH ../vga-core/vga_pll.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL vga_avalon
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file vga_avalon.sv SYSTEM_VERILOG PATH vga_avalon.sv
add_fileset_file vga_adapter.sv SYSTEM_VERILOG PATH ../vga-core/vga_adapter.sv
add_fileset_file vga_address_translator.sv SYSTEM_VERILOG PATH ../vga-core/vga_address_translator.sv
add_fileset_file vga_controller.sv SYSTEM_VERILOG PATH ../vga-core/vga_controller.sv
add_fileset_file vga_pll.sv SYSTEM_VERILOG PATH ../vga-core/vga_pll.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock_sink
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock_sink
set_interface_property avalon_slave_0 associatedReset reset
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitStates 0
set_interface_property avalon_slave_0 readWaitTime 0
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 address address Input 4
add_interface_port avalon_slave_0 read read Input 1
add_interface_port avalon_slave_0 readdata readdata Output 32
add_interface_port avalon_slave_0 write write Input 1
add_interface_port avalon_slave_0 writedata writedata Input 32
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink clk clk Input 1


# 
# connection point conduit_vga_export
# 
add_interface conduit_vga_export conduit end
set_interface_property conduit_vga_export associatedClock clock_sink
set_interface_property conduit_vga_export associatedReset reset
set_interface_property conduit_vga_export ENABLED true
set_interface_property conduit_vga_export EXPORT_OF ""
set_interface_property conduit_vga_export PORT_NAME_MAP ""
set_interface_property conduit_vga_export CMSIS_SVD_VARIABLES ""
set_interface_property conduit_vga_export SVD_ADDRESS_GROUP ""

add_interface_port conduit_vga_export vga_blu vga_blu Output 8
add_interface_port conduit_vga_export vga_clk vga_clk Output 1
add_interface_port conduit_vga_export vga_grn vga_grn Output 8
add_interface_port conduit_vga_export vga_hsync vga_hsync Output 1
add_interface_port conduit_vga_export vga_red vga_red Output 8
add_interface_port conduit_vga_export vga_vsync vga_vsync Output 1

