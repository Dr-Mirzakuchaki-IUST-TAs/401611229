library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADS_SPI_tb is
end ADS_SPI_tb;

architecture Behavioral of ADS_SPI_tb is

	signal  aclk        				:   std_logic                       :=  '0';
	signal  SCK        		            :   std_logic                       :=  '0';
	signal  MOSI        				:   std_logic                       :=  '0';
	signal  MISO        				:   std_logic                       :=  '0';
	signal  CS        				    :   std_logic                       :=  '0';
	
	signal  null_ads         			:   std_logic                       :=  '0';
	signal  rst_ads 			        :   std_logic                       :=  '0';
	signal  stb_ads 			        :   std_logic                       :=  '0';
	signal  wup_ads 		            :   std_logic                       :=  '0';
	signal  loc_ads     	            :   std_logic                       :=  '0';
	signal  uloc_ads			        :   std_logic                       :=  '0';

	constant CLOCK_PERIOD 			: time := 10 ns;
	constant T_HOLD       			: time := 10 ns;


begin

SPI_Controller_inst: entity work.ADS_SPI
   port map (
      Clock                     => aclk,  
      SCK                       => SCK, 
      MOSI_O                    => mosi,
      MISO_O                    => MOSI,               
      CS                        => CS,
      null_ads                  =>   null_ads,
      rst_ads                   =>   rst_ads ,
      stb_ads                   =>   stb_ads ,
      wup_ads                   =>   wup_ads ,
      loc_ads                   =>   loc_ads ,
      uloc_ads                  =>   uloc_ads
);
  clock_gen : process
  begin
    aclk <= '0';

      wait for CLOCK_PERIOD;
      loop
        aclk <= '0';
        wait for CLOCK_PERIOD/2;
        aclk <= '1';
        wait for CLOCK_PERIOD/2;
      end loop;
  end process clock_gen;

  stimuli : process
  begin

    -- Drive inputs T_HOLD time after rising edge of clock
    wait until rising_edge(aclk);
    wait for T_HOLD;

    -- Run for long enough to produce of outputs
    wait for 100 ns;
    rst_ads <= '1';

    wait for 100 ns;
    rst_ads <= '0';
	
	wait for 1000 ns;
    loc_ads <= '1';

    wait for 100 ns;
    loc_ads <= '0'; 
    
    wait for 4000 ns;
    uloc_ads <= '1';

    wait for 100 ns;
    uloc_ads <= '0';
    
    wait for 4000 ns;
    stb_ads <= '1';

    wait for 100 ns;
    stb_ads <= '0';
    wait;

  end process stimuli;


end Behavioral;
