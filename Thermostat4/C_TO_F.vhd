----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:12:19 01/09/2021 
-- Design Name: 
-- Module Name:    C_TO_F - Behavioral 
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

entity C_TO_F is
    Port ( IS_FAHRENHEIT	: 	in std_logic;			  
			  CELCIUS : in  STD_LOGIC_VECTOR (15 downto 0);
           TEMP_DATA_BUS : out  STD_LOGIC_VECTOR (15 downto 0));
end C_TO_F;

architecture Behavioral of C_TO_F is

SIGNAL TEMP1	:	STD_LOGIC_VECTOR (19 DOWNTO 0) := (OTHERS => '0');
SIGNAL TEMP2	:	STD_LOGIC_VECTOR (30 DOWNTO 0) := (OTHERS => '0');

begin

CONVERT	:	PROCESS(IS_FAHRENHEIT) IS BEGIN
				IF (IS_FAHRENHEIT = '0') THEN
				
					TEMP_DATA_BUS <= CELCIUS;	-- this data is in the form of degree celcius
				ELSE
					
					TEMP1 <= (CELCIUS & "0000") + (CELCIUS & '0') + "110010000000";	-- multiplication by 18 and adding 3200
					-- so we have 10 times the result we should have, later we'll divide it to 10
					
					TEMP2 <= (TEMP1 & "00000000000") + (TEMP1 & "0000000000") + (TEMP1 & "0000000") + (TEMP1 & "000000")
					+ (TEMP1 & "000") + (TEMP1 & "00") + TEMP1; -- multiplication by 3277
					
					TEMP_DATA_BUS <= TEMP2(30 DOWNTO 15);	-- division by 2^15
					---- 3277/2^15 ~~ 0.1
				END IF;
				END PROCESS CONVERT;


end Behavioral;

