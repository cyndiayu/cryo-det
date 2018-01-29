-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc_IFFT_no_scale\t\SimpleDualPortRAM_16x20b.vhd
-- Created: 2018-01-25 18:20:51
-- 
-- Generated by MATLAB 9.0 and HDL Coder 3.8
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: SimpleDualPortRAM_16x20b
-- Source Path: t/IFFT/IFFT HDL Optimized/RADIX2FFT_bitNatural/dataMEM_re_1_16x20b/SimpleDualPortRAM_16x20b
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SimpleDualPortRAM_16x20b IS
  PORT( clk                               :   IN    std_logic;
        wr_din                            :   IN    std_logic_vector(19 DOWNTO 0);  -- sfix20_En15
        wr_addr                           :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        wr_en                             :   IN    std_logic;  -- ufix1
        rd_addr                           :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        rd_dout                           :   OUT   std_logic_vector(19 DOWNTO 0)  -- sfix20_En15
        );
END SimpleDualPortRAM_16x20b;


ARCHITECTURE rtl OF SimpleDualPortRAM_16x20b IS

  -- Local Type Definitions
  CONSTANT AddrWidth : INTEGER := 4;
  CONSTANT DataWidth : INTEGER := 20;
  TYPE ram_type IS ARRAY (2**AddrWidth - 1 DOWNTO 0) of std_logic_vector(DataWidth - 1 DOWNTO 0);

  -- Signals
  SIGNAL ram                              : ram_type := (OTHERS => (OTHERS => '0'));
  SIGNAL data_int                         : std_logic_vector(DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL wr_addr_unsigned                 : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL rd_addr_unsigned                 : unsigned(3 DOWNTO 0);  -- ufix4

BEGIN
  wr_addr_unsigned <= unsigned(wr_addr);

  rd_addr_unsigned <= unsigned(rd_addr);

  SimpleDualPortRAM_16x20b_process: PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF wr_en = '1' THEN
        ram(to_integer(wr_addr_unsigned)) <= wr_din;
      END IF;
      data_int <= ram(to_integer(rd_addr_unsigned));
    END IF;
  END PROCESS SimpleDualPortRAM_16x20b_process;

  rd_dout <= data_int;

END rtl;

