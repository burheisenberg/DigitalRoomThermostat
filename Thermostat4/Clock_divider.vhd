----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:11:58 01/08/2021 
-- Design Name: 
-- Module Name:    Clock_divider - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Clock_divider is
    Port ( MCLK : in  STD_LOGIC;
           MHZ : out  STD_LOGIC;
           KHZ : out  STD_LOGIC;
           TEN_HZ : out  STD_LOGIC);
end Clock_divider;

architecture Behavioral of Clock_divider is

signal mhz_counter	: std_logic_vector (5 downto 0) := (others => '0');
signal khz_counter	: std_logic_vector (8 downto 0) := (others => '0');
signal ten_hz_counter	: std_logic_vector (7 downto 0) := (others => '0');

signal wire_mhz	:	std_logic := '0';
signal wire_khz	:	std_logic := '0';
signal wire_ten_hz	:	std_logic := '0';

begin

-- For 100 MHz clock, one clock period = 10 ns.
-- FOR 1   MHz clock, one clock period = 1  us.
-- FOR 1   KHz clock, one clock period = 1  ms.
-- FOR 10   Hz clock, one clock period = 0.1 s.


CLOCK_GENERATOR	:	PROCESS(MCLK, WIRE_MHZ, WIRE_KHZ) BEGIN
							
							IF(RISING_EDGE(MCLK)) THEN
								
								MHZ_COUNTER <= MHZ_COUNTER +'1';
								
								IF(MHZ_COUNTER = "110010") THEN 		-- alternates at each 50 triggers
								WIRE_MHZ <= NOT WIRE_MHZ;
								MHZ_COUNTER <= (OTHERS => '0');
								END IF;
								
							END IF;	
							
							IF(RISING_EDGE(WIRE_MHZ)) THEN
							
								KHZ_COUNTER <= KHZ_COUNTER + '1';
								
								IF(KHZ_COUNTER = "111110100") THEN	-- alternates at each 500 triggers
								WIRE_KHZ <= NOT WIRE_KHZ;
								KHZ_COUNTER <= (OTHERS => '0');
								END IF;
								
							END IF;
							
							IF(RISING_EDGE(WIRE_KHZ)) THEN			-- alternates at each 50 triggers
								
								TEN_HZ_COUNTER <= TEN_HZ_COUNTER + '1';
								
								IF(TEN_HZ_COUNTER = "00110010") THEN
								WIRE_TEN_HZ <= NOT WIRE_TEN_HZ;
								TEN_HZ_COUNTER <= (OTHERS => '0');
								END IF;
							
							END IF;
							
							END PROCESS CLOCK_GENERATOR;
								
								
					MHZ <= WIRE_MHZ;
					KHZ <= WIRE_KHZ;
					TEN_HZ <= WIRE_TEN_HZ;
						

end Behavioral;

