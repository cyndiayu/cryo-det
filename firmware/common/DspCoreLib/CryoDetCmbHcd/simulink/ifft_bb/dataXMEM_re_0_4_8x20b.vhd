-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc_IFFT_no_scale\t\dataXMEM_re_0_4_8x20b.vhd
-- Created: 2018-01-25 18:20:51
-- 
-- Generated by MATLAB 9.0 and HDL Coder 3.8
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: dataXMEM_re_0_4_8x20b
-- Source Path: t/IFFT/IFFT HDL Optimized/RADIX22FFT_SDF2_4/SDFCommutator4/dataXMEM_re_0_4_8x20b
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dataXMEM_re_0_4_8x20b IS
  PORT( clk                               :   IN    std_logic;
        wr_din                            :   IN    std_logic_vector(19 DOWNTO 0);  -- sfix20_En15
        wr_addr                           :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        wr_en                             :   IN    std_logic;  -- ufix1
        rd_addr                           :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        rd_dout                           :   OUT   std_logic_vector(19 DOWNTO 0)  -- sfix20_En15
        );
END dataXMEM_re_0_4_8x20b;


ARCHITECTURE rtl OF dataXMEM_re_0_4_8x20b IS

  -- Component Declarations
  COMPONENT SimpleDualPortRAM_8x20b
    PORT( clk                             :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(19 DOWNTO 0);  -- sfix20_En15
          wr_addr                         :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
          wr_en                           :   IN    std_logic;  -- ufix1
          rd_addr                         :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
          rd_dout                         :   OUT   std_logic_vector(19 DOWNTO 0)  -- sfix20_En15
          );
  END COMPONENT;

  -- Signals
  SIGNAL rd_dout_tmp                      : std_logic_vector(19 DOWNTO 0);  -- ufix20

BEGIN
  u_SimpleDualPortRAM_8x20b : SimpleDualPortRAM_8x20b
    PORT MAP( clk => clk,
              wr_din => wr_din,  -- sfix20_En15
              wr_addr => wr_addr,  -- ufix3
              wr_en => wr_en,  -- ufix1
              rd_addr => rd_addr,  -- ufix3
              rd_dout => rd_dout_tmp  -- sfix20_En15
              );

  rd_dout <= rd_dout_tmp;

END rtl;
