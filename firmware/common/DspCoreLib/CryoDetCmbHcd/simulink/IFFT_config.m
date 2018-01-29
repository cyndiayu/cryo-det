
function IFFT_config(this_block)

  % Revision History:
  %
  %   25-Jan-2018  (09:23 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     /afs/slac.stanford.edu/u/cd/mdewart/workspace/cryo-det/firmware/common/DspCoreLib/common/filter_bank/ifft_bb/IFFT.vhd
  %
  %

  this_block.setTopLevelLanguage('VHDL');

  this_block.setEntityName('IFFT');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
  this_block.tagAsCombinational;

  this_block.addSimulinkInport('reset');
  this_block.addSimulinkInport('data_re');
  this_block.addSimulinkInport('data_im');
  this_block.addSimulinkInport('valid');

  this_block.addSimulinkOutport('data_out_re');
  this_block.addSimulinkOutport('data_out_im');
  this_block.addSimulinkOutport('valid_out');

  data_out_re_port = this_block.port('data_out_re');
  data_out_re_port.setType('Fix_20_15');
  data_out_im_port = this_block.port('data_out_im');
  data_out_im_port.setType('Fix_20_15');
  valid_out_port = this_block.port('valid_out');
  valid_out_port.setType('Bool');
  valid_out_port.useHDLVector(false);

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('reset').width ~= 1);
      this_block.setError('Input data type for port "reset" must have width=1.');
    end

    this_block.port('reset').useHDLVector(false);

    if (this_block.port('data_re').width ~= 16);
      this_block.setError('Input data type for port "data_re" must have width=16.');
    end

    if (this_block.port('data_im').width ~= 16);
      this_block.setError('Input data type for port "data_im" must have width=16.');
    end

    if (this_block.port('valid').width ~= 1);
      this_block.setError('Input data type for port "valid" must have width=1.');
    end

    this_block.port('valid').useHDLVector(false);

  end  % if(inputTypesKnown)
  % -----------------------------

  % -----------------------------
   if (this_block.inputRatesKnown)
     setup_as_single_rate(this_block,'clk','ce')
   end  % if(inputRatesKnown)
  % -----------------------------

    uniqueInputRates = unique(this_block.getInputRates);


  % Add addtional source files as needed.
  %  |-------------
  %  | Add files in the order in which they should be compiled.
  %  | If two files "a.vhd" and "b.vhd" contain the entities
  %  | entity_a and entity_b, and entity_a contains a
  %  | component of type entity_b, the correct sequence of
  %  | addFile() calls would be:
  %  |    this_block.addFile('b.vhd');
  %  |    this_block.addFile('a.vhd');
  %  |-------------

  %    this_block.addFile('');
  %    this_block.addFile('');
%  this_block.addFile('ifft_bb/IFFT_pkg.vhd');
%  this_block.addFile('ifft_bb/Complex4Multiply.vhd');
%  this_block.addFile('ifft_bb/dataMEM_re_0_1_8x17b.vhd');
%  this_block.addFile('ifft_bb/dataMEM_re_0_2_4x18b.vhd');
%  this_block.addFile('ifft_bb/dataMEM_re_1_16x20b.vhd');
%  this_block.addFile('ifft_bb/dataXMEM_re_0_2_8x18b.vhd');
%  this_block.addFile('ifft_bb/dataXMEM_re_0_3_8x19b.vhd');
%  this_block.addFile('ifft_bb/dataXMEM_re_0_4_8x20b.vhd');
%  this_block.addFile('ifft_bb/SimpleDualPortRAM_4x18b.vhd');
%  this_block.addFile('ifft_bb/SimpleDualPortRAM_8x17b.vhd');
%  this_block.addFile('ifft_bb/SimpleDualPortRAM_8x18b.vhd');
%  this_block.addFile('ifft_bb/SimpleDualPortRAM_8x19b.vhd');
%  this_block.addFile('ifft_bb/SimpleDualPortRAM_8x20b.vhd');
%  this_block.addFile('ifft_bb/SimpleDualPortRAM_16x20b.vhd');
%  this_block.addFile('ifft_bb/TWDLROM_3_1.vhd');
%  this_block.addFile('ifft_bb/SDFCommutator1.vhd');
%  this_block.addFile('ifft_bb/SDFCommutator2.vhd');
%  this_block.addFile('ifft_bb/SDFCommutator3.vhd');
%  this_block.addFile('ifft_bb/SDFCommutator4.vhd');
%  this_block.addFile('ifft_bb/RADIX22FFT_CTRL1_1.vhd');
%  this_block.addFile('ifft_bb/RADIX22FFT_CTRL1_2.vhd');
%  this_block.addFile('ifft_bb/RADIX22FFT_CTRL1_3.vhd');
%  this_block.addFile('ifft_bb/RADIX22FFT_CTRL1_4.vhd');
%  this_block.addFile('ifft_bb/RADIX22FFT_SDF1_1.vhd');
%  this_block.addFile('ifft_bb/RADIX22FFT_SDF1_3.vhd');
%  this_block.addFile('ifft_bb/RADIX22FFT_SDF2_2.vhd');
%  this_block.addFile('ifft_bb/RADIX22FFT_SDF2_4.vhd');
%  this_block.addFile('ifft_bb/RADIX2FFT_bitNatural.vhd');
%  this_block.addFile('ifft_bb/IFFT_HDL_Optimized.vhd');
%  this_block.addFile('ifft_bb/IFFT.vhd');
  this_block.addFile('ifft_bb/IFFT_pkg.vhd');
  this_block.addFile('ifft_bb/SimpleDualPortRAM_8x17b.vhd');
  this_block.addFile('ifft_bb/dataMEM_re_0_1_8x17b.vhd');
  this_block.addFile('ifft_bb/SDFCommutator1.vhd');
  this_block.addFile('ifft_bb/RADIX22FFT_SDF1_1.vhd');
  this_block.addFile('ifft_bb/RADIX22FFT_CTRL1_1.vhd');
  this_block.addFile('ifft_bb/SimpleDualPortRAM_4x18b.vhd');
  this_block.addFile('ifft_bb/dataMEM_re_0_2_4x18b.vhd');
  this_block.addFile('ifft_bb/SimpleDualPortRAM_8x18b.vhd');
  this_block.addFile('ifft_bb/dataXMEM_re_0_2_8x18b.vhd');
  this_block.addFile('ifft_bb/SDFCommutator2.vhd');
  this_block.addFile('ifft_bb/RADIX22FFT_SDF2_2.vhd');
  this_block.addFile('ifft_bb/RADIX22FFT_CTRL1_2.vhd');
  this_block.addFile('ifft_bb/TWDLROM_3_1.vhd');
  this_block.addFile('ifft_bb/Complex4Multiply.vhd');
  this_block.addFile('ifft_bb/SimpleDualPortRAM_8x19b.vhd');
  this_block.addFile('ifft_bb/dataXMEM_re_0_3_8x19b.vhd');
  this_block.addFile('ifft_bb/SDFCommutator3.vhd');
  this_block.addFile('ifft_bb/RADIX22FFT_SDF1_3.vhd');
  this_block.addFile('ifft_bb/RADIX22FFT_CTRL1_3.vhd');
  this_block.addFile('ifft_bb/SimpleDualPortRAM_8x20b.vhd');
  this_block.addFile('ifft_bb/dataXMEM_re_0_4_8x20b.vhd');
  this_block.addFile('ifft_bb/SDFCommutator4.vhd');
  this_block.addFile('ifft_bb/RADIX22FFT_SDF2_4.vhd');
  this_block.addFile('ifft_bb/RADIX22FFT_CTRL1_4.vhd');
  this_block.addFile('ifft_bb/SimpleDualPortRAM_16x20b.vhd');
  this_block.addFile('ifft_bb/dataMEM_re_1_16x20b.vhd');
  this_block.addFile('ifft_bb/RADIX2FFT_bitNatural.vhd');
  this_block.addFile('ifft_bb/IFFT_HDL_Optimized.vhd');
  this_block.addFile('ifft_bb/IFFT.vhd');
  this_block.addFile('ifft_bb/IFFT_noresetinitscript.tcl');

return;


% ------------------------------------------------------------

function setup_as_single_rate(block,clkname,cename) 
  inputRates = block.inputRates; 
  uniqueInputRates = unique(inputRates); 
  if (length(uniqueInputRates)==1 & uniqueInputRates(1)==Inf) 
    block.addError('The inputs to this block cannot all be constant.'); 
    return; 
  end 
  if (uniqueInputRates(end) == Inf) 
     hasConstantInput = true; 
     uniqueInputRates = uniqueInputRates(1:end-1); 
  end 
  if (length(uniqueInputRates) ~= 1) 
    block.addError('The inputs to this block must run at a single rate.'); 
    return; 
  end 
  theInputRate = uniqueInputRates(1); 
  for i = 1:block.numSimulinkOutports 
     block.outport(i).setRate(theInputRate); 
  end 
  block.addClkCEPair(clkname,cename,theInputRate); 
  return; 

% ------------------------------------------------------------

