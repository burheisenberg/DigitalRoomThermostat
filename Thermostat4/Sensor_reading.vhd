----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:41:30 01/08/2021 
-- Design Name: 
-- Module Name:    Sensor_reading - Behavioral 
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


entity Sensor_reading is
    Port ( CLK : in  STD_LOGIC;
			  TRIGGER : out STD_LOGIC;
           DATA_LINE : in  STD_LOGIC;
           DATA_BUS : out  STD_LOGIC_VECTOR (39 downto 0));
end Sensor_reading;

architecture Behavioral of Sensor_reading is

signal counter	:	std_logic_vector (21 downto 0) := (others => '0');					-- counters for duration
signal pulse_counter	:	std_logic_vector (8 downto 0) := (others => '0');

signal index	:	integer := 40;

begin

READ_PULSE	:	PROCESS(CLK,DATA_LINE, COUNTER, PULSE_COUNTER) IS BEGIN
					
					if(rising_edge(clk)) then
						counter <= counter + '1';
						
						if(counter < "100101100000") then		-- the datasheet says at least 1 ms, give 0 signal --2400
							trigger <= '0';
						elsif(counter >= "100101100000" and counter < "100101111110") then --2400 < counter <2430
							trigger <= '1';
						elsif(counter >= "100101111110" and counter < "101000010100") then --2430 < counter <2580 --sensor gives start flag
							trigger <= 'Z';
						else
							
							if(data_line = '1') then
							pulse_counter <= pulse_counter + '1';			-- count the pulse duration
							end if;
							
						
						-- reset time 3.2 seconds: the datasheet says it must be > 2 seconds
						if(counter > "1100001101010000000000") then
							counter <= (others => '0'); 
							pulse_counter <= (others => '0');
							index <= 40;
						end if;
						
							if(data_line = '0') then
							if(index = 0) then		-- if the vector is full, then do nothing
							elsif(pulse_counter >= "11000" and pulse_counter < "100000") then -- we have a zero
								index <= index - 1;
								data_bus(index) <= '0';
								pulse_counter <= (others => '0');
							elsif(pulse_counter >= "1000000" and pulse_counter < "1001000") then -- we have a one
								index <= index - 1;								
								data_bus(index) <= '1';
								pulse_counter <= (others => '0');
							else
								pulse_counter <= (others => '0');
							end if;
							
						end if;
					  
					  end if;
					end if;
						
						
					END PROCESS READ_PULSE;
					


end Behavioral;

