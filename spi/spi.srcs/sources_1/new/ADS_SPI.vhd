library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADS_SPI is
    Port (  
            Clock 				 : in 	  STD_LOGIC;
            SCK 				 : out	  STD_LOGIC;
            MOSI_O 				 : out    STD_LOGIC;
			MISO_O				 : in	  STD_LOGIC;
			CS   				 : out	  STD_LOGIC;
			null_ads             : in     STD_LOGIC;
            rst_ads              : in     STD_LOGIC;
            stb_ads              : in     STD_LOGIC;
            wup_ads              : in     STD_LOGIC;
            loc_ads              : in     STD_LOGIC;
            uloc_ads             : in     STD_LOGIC
    ); 
end ADS_SPI;

architecture Behavioral of ADS_SPI is
    
    COMPONENT
        SPI_Controller port(
                Clock 				    			: in 	STD_LOGIC;
				Data_In 							: in 	unsigned (31 downto 0);
				Send 								: in 	STD_LOGIC;
				Command_Type 			    		: in 	unsigned (1 downto 0);
				Force_CS 					    	: in 	STD_LOGIC;
				Data_Out 						    : out	unsigned (7 downto 0);
				Data_Out_Valid 		           		: out   STD_LOGIC;
				Busy 								: out   STD_LOGIC;
				MOSI 								: out	STD_LOGIC;
				MISO 								: in	STD_LOGIC;
				SCK 								: out	STD_LOGIC;
				CS 								    : out	STD_LOGIC);
    end component;
    
    COMPONENT
        ADS GENERIC(ADS_NULL        : unsigned (31 downto 0):="00000000000000000000000000000000";
                    ADS_RESET       : unsigned (31 downto 0):="00000000000000000000000000010001";
                    ADS_STANDBY     : unsigned (31 downto 0):="00000000000000000000000000100010";
                    ADS_WAKEUP      : unsigned (31 downto 0):="00000000000000000000000000110011";
                    ADS_LOCK        : unsigned (31 downto 0):="00000000000000000000010101010101";
                    ADS_UNLOCK      : unsigned (31 downto 0):="00000000000000000000011001010101");
            
    Port ( clock                : in     STD_LOGIC;
           null_ads             : in     STD_LOGIC;
           rst_ads              : in     STD_LOGIC;
           stb_ads              : in     STD_LOGIC;
           wup_ads              : in     STD_LOGIC;
           loc_ads              : in     STD_LOGIC;
           uloc_ads             : in     STD_LOGIC;
           
           SPI_Busy             : in     STD_LOGIC;
           SPI_Data_In          : out    unsigned (31 downto 0);
           SPI_Command_Type     : out    unsigned (1 downto 0);
           SPI_Send             : out    STD_LOGIC;
           SPI_Force_CS         : out    STD_LOGIC);
    END COMPONENT;
    
    signal SPI_Data_signal                  : unsigned (31 downto 0);
    signal Force_signal                     : STD_LOGIC;
    signal Send_signal                      : STD_LOGIC;
    signal Command_Type_signal               : unsigned (1 downto 0);
    signal Data_Out_signal                  : unsigned (7 downto 0);
    signal Data_Out_Valid_signal            : STD_LOGIC;
    signal Busy_signal                      : STD_LOGIC;
    signal mosi_signal                      : STD_LOGIC;
    signal miso_signal                      : STD_LOGIC;
    signal cs_signal                        : STD_LOGIC;

begin
    cs <= cs_signal;
    MOSI_O <= mosi_signal;
    miso_signal <= MISO_O;
    c1: SPI_Controller PORT MAP(clock                       => clock,
                                Data_In                     => SPI_Data_signal ,
                                Send                        => send_signal,
                                Command_Type                => Command_Type_signal, 
                                Force_Cs                    => Force_signal, 
                                Data_Out                    => Data_Out_signal,
                                Data_Out_Valid              => Data_Out_Valid_signal,
                                Busy                        => Busy_signal,
                                MOSI                        => mosi_signal,
                                MISO                        => miso_signal,
                                SCK                         => sck,
                                CS                          => CS_signal
                                 );
                                 
                                 
    c2: ADS PORT MAP(           clock                       => clock,
                                null_ads                    => null_ads,
                                rst_ads                     => rst_ads,
                                stb_ads                     => stb_ads,
                                wup_ads                     => wup_ads,
                                loc_ads                     => loc_ads,
                                uloc_ads                    => uloc_ads,
                                SPI_Busy                    => Busy_signal,
                                SPI_Data_In                 => SPI_Data_signal,
                                SPI_Command_Type            => Command_Type_signal,
                                SPI_Send                    => Send_signal,
                                SPI_Force_CS                => Force_signal
                       );

end Behavioral;
