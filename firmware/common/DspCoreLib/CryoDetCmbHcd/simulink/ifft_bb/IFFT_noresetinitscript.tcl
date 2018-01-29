# This script is generated when there are blocks with ResetType property set to None.
# This script initializes registers or signals generated from these blocks before
# the start of simulation, as they do not have a reset port or are not initialized in the HDL code.
# The initialization commands are compatible with ModelSim. Other simulation tools may use different syntax.
# For VHDL, the command syntax is: 
# force -deposit <path to signal> <value to initialize to> <time to initialize at> 
# 
# For Verilog, the command syntax is: 
# change <path to signal> <value to initialize to> 
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/Complex4Multiply_din1_re_pipe1 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/Complex4Multiply_din1_im_pipe1 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/Complex4Multiply_twiddle_re_pipe1 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/Complex4Multiply_twiddle_im_pipe1 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/Complex4Multiply_mult1_re_pipe1 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/Complex4Multiply_mult2_re_pipe1 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/Complex4Multiply_mult1_im_pipe1 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/Complex4Multiply_mult2_im_pipe1 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/prod1_re 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/prod2_re 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/prod1_im 0 1
force -deposit ${::dut_prefix}IFFT/u_IFFT_HDL_Optimized/u_SDF1_3_1/u_MUL4/prod2_im 0 1
