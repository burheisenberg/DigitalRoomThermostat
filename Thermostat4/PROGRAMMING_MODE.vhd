----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:44:21 01/09/2021 
-- Design Name: 
-- Module Name:    DISPLAY_MODE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DISPLAY_MODE is
    Port ( MODE : in  STD_LOGIC_VECTOR (1 downto 0);
           UP : in  STD_LOGIC;
           DOWN : in  STD_LOGIC;
			  IS_FAHRENHEIT: in STD_LOGIC;
			  COOLER : out STD_LOGIC;
			  HEATER : out STD_LOGIC;
			  DISPLAY_CLOCK: in STD_LOGIC;
           PUSH_CLOCK : in  STD_LOGIC;
			  WIRE_DATA_BUS	: in STD_LOGIC_VECTOR(31 DOWNTO 0);
           R_D : out  STD_LOGIC_VECTOR (3 downto 0);
           R_C : out  STD_LOGIC_VECTOR (3 downto 0);
           R_B : out  STD_LOGIC_VECTOR (3 downto 0);
           R_A : out  STD_LOGIC_VECTOR (3 downto 0);
           L_D : out  STD_LOGIC_VECTOR (3 downto 0);
           L_C : out  STD_LOGIC_VECTOR (3 downto 0);
           L_B : out  STD_LOGIC_VECTOR (3 downto 0);
           L_A : out  STD_LOGIC_VECTOR (3 downto 0));
end DISPLAY_MODE;

architecture Behavioral of DISPLAY_MODE is

-- bcd converted values
SIGNAL T_DEC : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL T_ONE : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL T_TEN : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL T_HUN : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL H_DEC : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL H_ONE : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL H_TEN : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL H_HUN : STD_LOGIC_VECTOR (3 DOWNTO 0);

-- thermostat configuration values
SIGNAL LOWER_BOUNDARY : STD_LOGIC_VECTOR (15 DOWNTO 0)	:= "0000000000001111";
SIGNAL UPPER_BOUNDARY : STD_LOGIC_VECTOR (15 DOWNTO 0)	:= "0000000000011001";
SIGNAL LOWER_TENS, LOWER_ONES, UPPER_TENS, UPPER_ONES : STD_LOGIC_VECTOR (3 DOWNTO 0); 

-- 
SIGNAL TEMP_DATA_BUS : STD_LOGIC_VECTOR (15 DOWNTO 0)	:= (OTHERS => '0');
begin


BCD_HUMIDITY : entity WORK.BCD_CONVERTER PORT MAP(
	INPUT => WIRE_DATA_BUS(31 downto 16),
	ONES => H_DEC,
	TENS => H_ONE,
	HUNDREDS => H_TEN,
	THOUSANDS => H_HUN);

BCD_TEMPERATURE : entity WORK.BCD_CONVERTER PORT MAP(
	INPUT => TEMP_DATA_BUS,
	ONES => T_DEC,
	TENS => T_ONE,
	HUNDREDS => T_TEN,
	THOUSANDS => T_HUN);


BCD_UPPER	: ENTITY WORK.BCD_CONVERTER PORT MAP(
	INPUT => UPPER_BOUNDARY,
	ONES => UPPER_ONES,
	TENS => UPPER_TENS
);

BCD_LOWER	: ENTITY WORK.BCD_CONVERTER PORT MAP(
	INPUT => LOWER_BOUNDARY,
	ONES => LOWER_ONES,
	TENS => LOWER_TENS
);

CONVERT_IF_FAHRENHEIT	:	entity WORK.C_TO_F port map(
	IS_FAHRENHEIT	=>	IS_FAHRENHEIT,
	CELCIUS => WIRE_DATA_BUS(15 DOWNTO 0),
	TEMP_DATA_BUS => TEMP_DATA_BUS);

PICK_MODE	:	PROCESS (PUSH_CLOCK, MODE, UP, DOWN) IS BEGIN
					
					if(rising_edge(PUSH_CLOCK)) then
					

					if(mode(1) = '0') then		----- the humidity and the temperature are shown
						R_D <= T_DEC;
						R_C <= T_ONE;
						R_B <= T_TEN;
						R_A <= T_HUN;
						L_D <= H_DEC;
						L_C <= H_ONE;
						L_B <= H_TEN;
						L_A <= H_HUN;
						
					elsif(mode(0) = '0') then  ----- the lower boundary DISPLAY
						if(up = '1') then	-- increase the lower boundary
							lower_boundary <= lower_boundary + '1';
						elsif(down = '1') then --decrease the upper boundary
							lower_boundary <= lower_boundary - '1';
						end if;
						
						L_A <= "1010";
						L_B <= "1011";
						L_C <= "1100";
						L_D <= "1101"; 	-- PRG L
						R_A <= "0000";
						R_B <= LOWER_TENS;
						R_C <= LOWER_ONES;
						R_D <= "0000";
						
					else 												-- the upper boundary DISPLAY
							if(up = '1') then -- increase the upper boundary
								upper_boundary <= upper_boundary + '1';
							elsif(down = '1') then --decrease the upper boundary
								upper_boundary <= upper_boundary - '1';
							end if;
							
						L_A <= "1010"; 
						L_B <= "1011";
						L_C <= "1100";
						L_D <= "1110"; 	-- PRG U
						R_A <= "0000";
						R_B <= UPPER_TENS;
						R_C <= UPPER_ONES;
						R_D <= "0000";
						
					end if;
					
					
					end if;
					
					end process PICK_MODE;
					
TEMP_CONTROL	:	PROCESS(DISPLAY_CLOCK) IS BEGIN
					
					if(rising_edge(display_clock)) then
					
						if((T_TEN & T_ONE) < (LOWER_TENS & LOWER_ONES)) then
							Heater <= '0';			--active low relay		-- heater on
						else 
							Heater <= '1';
						end if;
						
						if((T_TEN & T_ONE) > (UPPER_TENS & UPPER_ONES)) then
							Cooler <= '0';			-- active low relay		-- cooler on
						else
							Cooler <= '1';
						end if;
					end if;
					
					END PROCESS TEMP_CONTROL;

end Behavioral;

