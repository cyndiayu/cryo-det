-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc_IFFT_no_scale\t\dataMEM_re_1_16x20b.vhd
-- Created: 2018-01-25 18:20:51
-- 
-- Generated by MATLAB 9.0 and HDL Coder 3.8
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: dataMEM_re_1_16x20b
-- Source Path: t/IFFT/IFFT HDL Optimized/RADIX2FFT_bitNatural/dataMEM_re_1_16x20b
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dataMEM_re_1_16x20b IS
  PORT( clk                               :   IN    std_logic;
        wr_din                            :   IN    std_logic_vector(19 DOWNTO 0);  -- sfix20_En15
        wr_addr                           :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        wr_en                             :   IN    std_logic;  -- ufix1
        rd_addr                           :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        rd_dout                           :   OUT   std_logic_vector(19 DOWNTO 0)  -- sfix20_En15
        );
END dataMEM_re_1_16x20b;


ARCHITECTURE rtl OF dataMEM_re_1_16x20b IS

  -- Component Declarations
  COMPONENT SimpleDualPortRAM_16x20b
    PORT( clk                             :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(19 DOWNTO 0);  -- sfix20_En15
          wr_addr                         :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
          wr_en                           :   IN    std_logic;  -- ufix1
          rd_addr                         :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
          rd_dout                         :   OUT   std_logic_vector(19 DOWNTO 0)  -- sfix20_En15
          );
  END COMPONENT;

  -- Signals
  SIGNAL rd_dout_tmp                      : std_logic_vector(19 DOWNTO 0);  -- ufix20

BEGIN
  u_SimpleDualPortRAM_16x20b : SimpleDualPortRAM_16x20b
    PORT MAP( clk => clk,
              wr_din => wr_din,  -- sfix20_En15
              wr_addr => wr_addr,  -- ufix4
              wr_en => wr_en,  -- ufix1
              rd_addr => rd_addr,  -- ufix4
              rd_dout => rd_dout_tmp  -- sfix20_En15
              );

  rd_dout <= rd_dout_tmp;

END rtl;
