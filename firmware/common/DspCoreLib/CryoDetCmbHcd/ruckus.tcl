############################
# DO NOT EDIT THE CODE BELOW
############################

# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load target's source code and constraints
loadSource      -dir  "$::DIR_PATH/rtl"
loadConstraints -dir  "$::DIR_PATH/xdc"
loadSource      -path "$::DIR_PATH/simulink/netlist/dspcore.dcp"

# Force synth_1 to be stale between runs incase the sysgen .DCP file changes ( work around for a bug in Vivado)
exec touch [get_files {DspCoreWrapper.vhd}]

# Place and Route strategy
set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]
#set_property STEPS.POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
#set_property STEPS.POST_PLACE_POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]

set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY rebuilt [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING          on      [get_runs synth_1]