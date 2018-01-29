-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc_IFFT_no_scale\t\RADIX22FFT_CTRL1_4.vhd
-- Created: 2018-01-25 18:20:51
-- 
-- Generated by MATLAB 9.0 and HDL Coder 3.8
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: RADIX22FFT_CTRL1_4
-- Source Path: t/IFFT/IFFT HDL Optimized/RADIX22FFT_CTRL1_4
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RADIX22FFT_CTRL1_4 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        dout_3_1_vld                      :   IN    std_logic;
        dinXTwdl_4_1_vld                  :   IN    std_logic;
        softReset                         :   IN    std_logic;
        rd_4_Addr                         :   OUT   std_logic;
        rd_4_Enb                          :   OUT   std_logic;
        proc_4_enb                        :   OUT   std_logic;
        multiply_4_J                      :   OUT   std_logic
        );
END RADIX22FFT_CTRL1_4;


ARCHITECTURE rtl OF RADIX22FFT_CTRL1_4 IS

  -- Functions
  -- HDLCODER_TO_STDLOGIC 
  FUNCTION hdlcoder_to_stdlogic(arg: boolean) RETURN std_logic IS
  BEGIN
    IF arg THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
  END FUNCTION;


  -- Signals
  SIGNAL SDFController_wrState            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_rdState            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_rdAddr_reg         : std_logic;  -- ufix1
  SIGNAL SDFController_multjState         : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_wrState_next       : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_rdState_next       : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_rdAddr_reg_next    : std_logic;  -- ufix1
  SIGNAL SDFController_multjState_next    : unsigned(1 DOWNTO 0);  -- ufix2

BEGIN
  -- SDFController
  SDFController_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' OR softReset = '1' THEN
        SDFController_rdAddr_reg <= '0';
        SDFController_wrState <= to_unsigned(16#0#, 2);
        SDFController_rdState <= to_unsigned(16#0#, 2);
        SDFController_multjState <= to_unsigned(16#0#, 2);
      ELSE 
        SDFController_wrState <= SDFController_wrState_next;
        SDFController_rdState <= SDFController_rdState_next;
        SDFController_rdAddr_reg <= SDFController_rdAddr_reg_next;
        SDFController_multjState <= SDFController_multjState_next;
      END IF;
    END IF;
  END PROCESS SDFController_process;

  SDFController_output : PROCESS (SDFController_wrState, SDFController_rdState, SDFController_rdAddr_reg,
       SDFController_multjState, dout_3_1_vld, dinXTwdl_4_1_vld)
  BEGIN
    SDFController_wrState_next <= SDFController_wrState;
    SDFController_rdState_next <= SDFController_rdState;
    SDFController_rdAddr_reg_next <= SDFController_rdAddr_reg;
    SDFController_multjState_next <= SDFController_multjState;
    CASE SDFController_multjState IS
      WHEN "00" =>
        SDFController_multjState_next <= to_unsigned(16#0#, 2);
        multiply_4_J <= '0';
        IF SDFController_rdState = to_unsigned(16#1#, 2) THEN 
          SDFController_multjState_next <= to_unsigned(16#1#, 2);
        END IF;
      WHEN "01" =>
        multiply_4_J <= '0';
        IF SDFController_rdState = to_unsigned(16#0#, 2) THEN 
          SDFController_multjState_next <= to_unsigned(16#2#, 2);
        END IF;
      WHEN "10" =>
        multiply_4_J <= '0';
        SDFController_multjState_next <= to_unsigned(16#3#, 2);
      WHEN "11" =>
        multiply_4_J <= '1';
        SDFController_multjState_next <= to_unsigned(16#0#, 2);
      WHEN OTHERS => 
        SDFController_multjState_next <= to_unsigned(16#0#, 2);
        multiply_4_J <= '0';
    END CASE;
    CASE SDFController_rdState IS
      WHEN "00" =>
        SDFController_rdState_next <= to_unsigned(16#0#, 2);
        SDFController_rdAddr_reg_next <= '0';
        rd_4_Enb <= '0';
        IF (hdlcoder_to_stdlogic(SDFController_wrState = to_unsigned(16#3#, 2)) AND dout_3_1_vld) = '1' THEN 
          SDFController_rdState_next <= to_unsigned(16#1#, 2);
          rd_4_Enb <= dinXTwdl_4_1_vld;
        END IF;
      WHEN "01" =>
        rd_4_Enb <= dinXTwdl_4_1_vld;
        IF dinXTwdl_4_1_vld = '1' THEN 
          SDFController_rdState_next <= to_unsigned(16#0#, 2);
        END IF;
      WHEN OTHERS => 
        SDFController_rdState_next <= to_unsigned(16#0#, 2);
        SDFController_rdAddr_reg_next <= '0';
        rd_4_Enb <= '0';
    END CASE;
    CASE SDFController_wrState IS
      WHEN "00" =>
        SDFController_wrState_next <= to_unsigned(16#0#, 2);
        proc_4_enb <= '0';
        IF dout_3_1_vld = '1' THEN 
          SDFController_wrState_next <= to_unsigned(16#3#, 2);
        END IF;
      WHEN "11" =>
        SDFController_wrState_next <= to_unsigned(16#3#, 2);
        proc_4_enb <= '0';
        IF dout_3_1_vld = '1' THEN 
          SDFController_wrState_next <= to_unsigned(16#2#, 2);
          proc_4_enb <= '1';
        END IF;
      WHEN "10" =>
        proc_4_enb <= '0';
        SDFController_wrState_next <= to_unsigned(16#2#, 2);
        IF dout_3_1_vld = '1' THEN 
          SDFController_wrState_next <= to_unsigned(16#3#, 2);
        END IF;
      WHEN OTHERS => 
        SDFController_wrState_next <= to_unsigned(16#0#, 2);
        proc_4_enb <= '0';
    END CASE;
    rd_4_Addr <= SDFController_rdAddr_reg;
  END PROCESS SDFController_output;


END rtl;

