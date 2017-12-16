-------------------------------------------------------------------------------
-- File       : DspCoreWrapperBase.vhd
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2017-06-28
-- Last update: 2017-12-15
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- This file is part of 'LCLS2 AMC Carrier Firmware'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'LCLS2 AMC Carrier Firmware', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.Jesd204bPkg.all;
use work.AppTopPkg.all;

entity DspCoreWrapperBase is
   generic (
      TPD_G            : time             := 1 ns;
      AXI_ERROR_RESP_G : slv(1 downto 0)  := AXI_RESP_SLVERR_C;
      AXI_BASE_ADDR_G  : slv(31 downto 0) := (others => '0'));
   port (
      -- JESD Clocks and resets   
      jesdClk         : in  sl;
      jesdRst         : in  sl;
      jesdClk2x       : in  sl;
      jesdRst2x       : in  sl;
      -- ADC/DAC/Debug Interface (jesdClk domain)
      adc             : in  Slv32Array(1 downto 0);
      dac             : out Slv32Array(1 downto 0);
      debugvalid      : out slv(1 downto 0);
      debug           : out Slv32Array(1 downto 0);
      -- DAC Signal Generator Interface (jesdClk domain)
      sigGenStart     : out sl;
      sigGen          : in  Slv32Array(1 downto 0);
      -- Digital I/O Interface
      startRamp       : in  sl;
      selectRamp      : in  sl;
      rampCnt         : in  slv(31 downto 0);
      -- AXI-Lite Port
      axilClk         : in  sl;
      axilRst         : in  sl;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType);
end DspCoreWrapperBase;

architecture mapping of DspCoreWrapperBase is

   component dspcore
      port (
         rampcnt                    : in  std_logic_vector (31 downto 0);
         rddata0                    : in  std_logic_vector (31 downto 0);
         rddata1                    : in  std_logic_vector (31 downto 0);
         rddata2                    : in  std_logic_vector (31 downto 0);
         rddata3                    : in  std_logic_vector (31 downto 0);
         rddata4                    : in  std_logic_vector (31 downto 0);
         rddata5                    : in  std_logic_vector (31 downto 0);
         rddata6                    : in  std_logic_vector (31 downto 0);
         rddata7                    : in  std_logic_vector (31 downto 0);
         rst                        : in  std_logic_vector (0 to 0);
         selectramp                 : in  std_logic_vector (0 to 0);
         siggen0                    : in  std_logic_vector (31 downto 0);
         siggen1                    : in  std_logic_vector (31 downto 0);
         startramp                  : in  std_logic_vector (0 to 0);
         adc0                       : in  std_logic_vector (15 downto 0);
         adc1                       : in  std_logic_vector (15 downto 0);
         dsp_clk                    : in  std_logic;
         dsp2x_clk                  : in  std_logic;
         dsp_axi_lite_clk           : in  std_logic;
         dsp_axi_lite_aresetn       : in  std_logic;
         dsp_axi_lite_s_axi_awaddr  : in  std_logic_vector (11 downto 0);
         dsp_axi_lite_s_axi_awvalid : in  std_logic;
         dsp_axi_lite_s_axi_wdata   : in  std_logic_vector (31 downto 0);
         dsp_axi_lite_s_axi_wstrb   : in  std_logic_vector (3 downto 0);
         dsp_axi_lite_s_axi_wvalid  : in  std_logic;
         dsp_axi_lite_s_axi_bready  : in  std_logic;
         dsp_axi_lite_s_axi_araddr  : in  std_logic_vector (11 downto 0);
         dsp_axi_lite_s_axi_arvalid : in  std_logic;
         dsp_axi_lite_s_axi_rready  : in  std_logic;
         debug0                     : out std_logic_vector (31 downto 0);
         debug1                     : out std_logic_vector (31 downto 0);
         debugvalids                : out std_logic_vector (1 downto 0);
         rdaddr0                    : out std_logic_vector (6 downto 0);
         rdaddr1                    : out std_logic_vector (6 downto 0);
         rdaddr2                    : out std_logic_vector (6 downto 0);
         rdaddr3                    : out std_logic_vector (6 downto 0);
         rdaddr4                    : out std_logic_vector (6 downto 0);
         rdaddr5                    : out std_logic_vector (6 downto 0);
         rdaddr6                    : out std_logic_vector (6 downto 0);
         rdaddr7                    : out std_logic_vector (6 downto 0);
         siggenstart                : out std_logic_vector (0 to 0);
         wraddr0                    : out std_logic_vector (6 downto 0);
         wraddr1                    : out std_logic_vector (6 downto 0);
         wraddr2                    : out std_logic_vector (6 downto 0);
         wraddr3                    : out std_logic_vector (6 downto 0);
         wraddr4                    : out std_logic_vector (6 downto 0);
         wraddr5                    : out std_logic_vector (6 downto 0);
         wraddr6                    : out std_logic_vector (6 downto 0);
         wraddr7                    : out std_logic_vector (6 downto 0);
         wrdata0                    : out std_logic_vector (31 downto 0);
         wrdata1                    : out std_logic_vector (31 downto 0);
         wrdata2                    : out std_logic_vector (31 downto 0);
         wrdata3                    : out std_logic_vector (31 downto 0);
         wrdata4                    : out std_logic_vector (31 downto 0);
         wrdata5                    : out std_logic_vector (31 downto 0);
         wrdata6                    : out std_logic_vector (31 downto 0);
         wrdata7                    : out std_logic_vector (31 downto 0);
         dac0                       : out std_logic_vector (15 downto 0);
         dac1                       : out std_logic_vector (15 downto 0);
         dsp_axi_lite_s_axi_awready : out std_logic;
         dsp_axi_lite_s_axi_wready  : out std_logic;
         dsp_axi_lite_s_axi_bresp   : out std_logic_vector (1 downto 0);
         dsp_axi_lite_s_axi_bvalid  : out std_logic;
         dsp_axi_lite_s_axi_arready : out std_logic;
         dsp_axi_lite_s_axi_rdata   : out std_logic_vector (31 downto 0);
         dsp_axi_lite_s_axi_rresp   : out std_logic_vector (1 downto 0);
         dsp_axi_lite_s_axi_rvalid  : out std_logic
         );
   end component;

   constant NUM_AXI_MASTERS_C : natural := 2;

   constant AXI_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXI_MASTERS_C-1 downto 0) := genAxiLiteConfig(NUM_AXI_MASTERS_C, AXI_BASE_ADDR_G, 20, 16);

   signal axilWriteMasters : AxiLiteWriteMasterArray(NUM_AXI_MASTERS_C-1 downto 0);
   signal axilWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXI_MASTERS_C-1 downto 0);
   signal axilReadMasters  : AxiLiteReadMasterArray(NUM_AXI_MASTERS_C-1 downto 0);
   signal axilReadSlaves   : AxiLiteReadSlaveArray(NUM_AXI_MASTERS_C-1 downto 0);

   signal axilRstL : sl;

   signal ramAddr : Slv7Array(15 downto 0)  := (others => (others => '0'));
   signal ramDin  : Slv32Array(15 downto 0) := (others => (others => '0'));
   signal ramDout : Slv32Array(15 downto 0) := (others => (others => '0'));

   signal adcSync : Slv16Array(1 downto 0) := (others => (others => '0'));
   signal dacSync : Slv16Array(1 downto 0) := (others => (others => '0'));

begin

   axilRstL <= not(axilRst);

   GEN_2X_CLK : for i in 1 downto 0 generate

      U_ADC : entity work.Jesd32bTo16b
         generic map (
            TPD_G => TPD_G)
         port map (
            wrClk    => jesdClk,
            wrRst    => jesdRst,
            validIn  => '1',
            dataIn   => adc(i),
            rdClk    => jesdClk2x,
            rdRst    => jesdRst2x,
            validOut => open,
            dataOut  => adcSync(i));

      U_DAC : entity work.Jesd16bTo32b
         generic map (
            TPD_G => TPD_G)
         port map (
            wrClk    => jesdClk2x,
            wrRst    => jesdRst2x,
            validIn  => '1',
            dataIn   => dacSync(i),
            rdClk    => jesdClk,
            rdRst    => jesdRst,
            validOut => open,
            dataOut  => dac(i));

   end generate GEN_2X_CLK;

   ---------------------
   -- AXI-Lite Crossbar
   ---------------------
   U_XBAR : entity work.AxiLiteCrossbar
      generic map (
         TPD_G              => TPD_G,
         DEC_ERROR_RESP_G   => AXI_ERROR_RESP_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => NUM_AXI_MASTERS_C,
         MASTERS_CONFIG_G   => AXI_CONFIG_C)
      port map (
         axiClk              => axilClk,
         axiClkRst           => axilRst,
         sAxiWriteMasters(0) => axilWriteMaster,
         sAxiWriteSlaves(0)  => axilWriteSlave,
         sAxiReadMasters(0)  => axilReadMaster,
         sAxiReadSlaves(0)   => axilReadSlave,
         mAxiWriteMasters    => axilWriteMasters,
         mAxiWriteSlaves     => axilWriteSlaves,
         mAxiReadMasters     => axilReadMasters,
         mAxiReadSlaves      => axilReadSlaves);

   -------------------
   -- System Generator
   -------------------
   U_SysGen : dspcore
      port map (
         -- Clock and Reset
         dsp2x_clk                  => jesdClk2x,
         dsp_clk                    => jesdClk,
         rst(0)                     => jesdRst,
         -- ADCs Ports (dsp2x_clk domain)
         adc0                       => adcSync(0),
         adc1                       => adcSync(1),
         -- DAC Ports (dsp2x_clk domain)
         dac0                       => dacSync(0),
         dac1                       => dacSync(1),
         -- RAM Ready Only Ports (dsp_clk domain)
         rddata0                    => ramDout(0),
         rddata1                    => ramDout(1),
         rddata2                    => ramDout(2),
         rddata3                    => ramDout(3),
         rddata4                    => ramDout(4),
         rddata5                    => ramDout(5),
         rddata6                    => ramDout(6),
         rddata7                    => ramDout(7),
         rdaddr0                    => ramAddr(0),
         rdaddr1                    => ramAddr(1),
         rdaddr2                    => ramAddr(2),
         rdaddr3                    => ramAddr(3),
         rdaddr4                    => ramAddr(4),
         rdaddr5                    => ramAddr(5),
         rdaddr6                    => ramAddr(6),
         rdaddr7                    => ramAddr(7),
         -- RAM Ready Only Ports (dsp_clk domain)
         wrdata0                    => ramDin(8),
         wrdata1                    => ramDin(9),
         wrdata2                    => ramDin(10),
         wrdata3                    => ramDin(11),
         wrdata4                    => ramDin(12),
         wrdata5                    => ramDin(13),
         wrdata6                    => ramDin(14),
         wrdata7                    => ramDin(15),
         wraddr0                    => ramAddr(8),
         wraddr1                    => ramAddr(9),
         wraddr2                    => ramAddr(10),
         wraddr3                    => ramAddr(11),
         wraddr4                    => ramAddr(12),
         wraddr5                    => ramAddr(13),
         wraddr6                    => ramAddr(14),
         wraddr7                    => ramAddr(15),
         -- DAQ Mux Debug Ports (dsp_clk domain)
         debugvalids                => debugvalid,
         debug0                     => debug(0),
         debug1                     => debug(1),
         -- Signal Generator Ports (dsp_clk domain)
         sigGenStart(0)             => sigGenStart,
         sigGen0                    => sigGen(0),
         sigGen1                    => sigGen(1),
         -- Digital I/O Interface (dsp_clk domain)  
         startRamp(0)               => startRamp,
         selectRamp(0)              => selectRamp,
         rampCnt                    => rampCnt,
         -- AXI-Lite Interface (dsp_axi_lite_clk domain)
         dsp_axi_lite_clk           => axilClk,
         dsp_axi_lite_aresetn       => axilRstL,
         dsp_axi_lite_s_axi_awaddr  => axilWriteMasters(0).awaddr(11 downto 0),
         dsp_axi_lite_s_axi_awvalid => axilWriteMasters(0).awvalid,
         dsp_axi_lite_s_axi_wdata   => axilWriteMasters(0).wdata,
         dsp_axi_lite_s_axi_wstrb   => axilWriteMasters(0).wstrb,
         dsp_axi_lite_s_axi_wvalid  => axilWriteMasters(0).wvalid,
         dsp_axi_lite_s_axi_bready  => axilWriteMasters(0).bready,
         dsp_axi_lite_s_axi_araddr  => axilReadMasters(0).araddr(11 downto 0),
         dsp_axi_lite_s_axi_arvalid => axilReadMasters(0).arvalid,
         dsp_axi_lite_s_axi_rready  => axilReadMasters(0).rready,
         dsp_axi_lite_s_axi_awready => axilWriteSlaves(0).awready,
         dsp_axi_lite_s_axi_wready  => axilWriteSlaves(0).wready,
         dsp_axi_lite_s_axi_bresp   => axilWriteSlaves(0).bresp,
         dsp_axi_lite_s_axi_bvalid  => axilWriteSlaves(0).bvalid,
         dsp_axi_lite_s_axi_arready => axilReadSlaves(0).arready,
         dsp_axi_lite_s_axi_rdata   => axilReadSlaves(0).rdata,
         dsp_axi_lite_s_axi_rresp   => axilReadSlaves(0).rresp,
         dsp_axi_lite_s_axi_rvalid  => axilReadSlaves(0).rvalid);

   --------------------------------
   -- AXI-Lite Shared Memory Module
   --------------------------------
   U_Mem : entity work.DspCoreWrapperBram
      generic map (
         TPD_G            => TPD_G,
         AXI_ERROR_RESP_G => AXI_ERROR_RESP_G,
         AXI_BASE_ADDR_G  => AXI_CONFIG_C(1).baseAddr)
      port map (
         -- Clock and Reset
         jesdClk         => jesdClk,
         jesdRst         => jesdRst,
         ramWe           => x"FF00",  -- RAM[15:8] = write only , RAM[7:0] = Read only
         ramAddr         => ramAddr,
         ramDin          => ramDin,
         ramDout         => ramDout,
         -- AXI-Lite Interface
         axilClk         => axilClk,
         axilRst         => axilRst,
         axilReadMaster  => axilReadMasters(1),
         axilReadSlave   => axilReadSlaves(1),
         axilWriteMaster => axilWriteMasters(1),
         axilWriteSlave  => axilWriteSlaves(1));

end mapping;
