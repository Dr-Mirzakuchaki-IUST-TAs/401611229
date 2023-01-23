
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADS is
    GENERIC(ADS_NULL        : unsigned (31 downto 0):="00000000000000000000000000000000";
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
end ADS;

architecture Behavioral of ADS is

    signal SPI_Busy_Int         :        STD_LOGIC                          ;
    signal SPI_Data_In_Int      :        unsigned (31 downto 0)     := (others =>'0');
    signal SPI_Command_Type_Int :        unsigned (1 downto 0)              := "10";
    signal SPI_Send_Int         :        STD_LOGIC                          :='0';
    signal SPI_Force_CS_Int     :        STD_LOGIC                          :='0';  
    
	type		SPI_Data_Width_Array is array (0 to 3) of unsigned(4 downto 0); 
	signal	SPI_Data_Width			:	SPI_Data_Width_Array		:=	
				(	to_unsigned(7,5),
					to_unsigned(15,5),
					to_unsigned(23,5),
					to_unsigned(31,5)
				);
				
begin
    
    SPI_Data_In            <= SPI_Data_In_Int;
    SPI_Command_Type       <= SPI_Command_Type_Int;
    SPI_Send               <= SPI_Send_Int;
    SPI_Force_CS           <= SPI_Force_CS_Int;
    
    process(clock)
    begin
        if rising_edge (clock) then
            SPI_Busy_Int               <= SPI_Busy;
            if (rst_ads  = '1' AND SPI_Busy_Int = '0') then
                SPI_Data_In_Int <= ADS_RESET; 
                SPI_Send_Int <= '1';
                SPI_Command_Type_Int <= "01";
                SPI_Force_CS_Int <= '1';
                if SPI_Send_Int = '1' then SPI_Send_Int <= '0'; end if;
            end if;
            
            if (stb_ads = '1' AND SPI_Busy_Int = '0') then
                SPI_Data_In_Int <= ADS_STANDBY; 
                SPI_Send_Int <= '1';
                SPI_Command_Type_Int <= "01";
                SPI_Force_CS_Int <= '1';
                if SPI_Send_Int = '1' then SPI_Send_Int <= '0';end if;
            end if;
            
            if (wup_ads = '1' AND SPI_Busy_Int = '0') then
                SPI_Data_In_Int <= ADS_WAKEUP ; 
                SPI_Send_Int <= '1';
                SPI_Command_Type_Int <= "01";
                SPI_Force_CS_Int <= '1';
                if SPI_Send_Int = '1' then SPI_Send_Int <= '0'; end if;
            end if;
            
            if (loc_ads = '1' AND SPI_Busy_Int = '0') then
                SPI_Data_In_Int <= ADS_LOCK ; 
                SPI_Send_Int <= '1';
                SPI_Command_Type_Int <= "01";
                SPI_Force_CS_Int <= '1';
                if SPI_Send_Int = '1' then SPI_Send_Int <= '0'; end if;
            end if;
            
            if (uloc_ads = '1' AND SPI_Busy_Int = '0') then
                SPI_Data_In_Int <= ADS_UNLOCK ; 
                SPI_Send_Int <= '1';
                SPI_Command_Type_Int <= "01";
                SPI_Force_CS_Int <= '1';
                if SPI_Send_Int = '1' then SPI_Send_Int <= '0'; end if;
            end if;
        end if;
    end process;

end Behavioral;
