----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:25:17 01/09/2021 
-- Design Name: 
-- Module Name:    SEVSEG_DECODER - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY SEVSEG_DECODER IS
	PORT (INPUT : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			SEVSEG_BUS : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));
END SEVSEG_DECODER;

ARCHITECTURE Behavioral OF Sevseg_Decoder IS

BEGIN
	WITH INPUT SELECT SEVSEG_BUS <=
		"0000001" WHEN "0000", --0
		"1001111" WHEN "0001", --1
		"0010010" WHEN "0010", --2
		"0000110" WHEN "0011", --3
		"1001100" WHEN "0100", --4
		"0100100" WHEN "0101", --5
		"0100000" WHEN "0110", --6
		"0001111" WHEN "0111", --7
		"0000000" WHEN "1000", --8
		"0000100" WHEN "1001", --9
		"0011000" WHEN "1010", --p
		"1111010" WHEN "1011", --r
		"0000100" WHEN "1100", --g
		"1110001" WHEN "1101", --l
		"1000001" WHEN "1110", --u
		"0111000" WHEN "1111", --F
		"1111111" WHEN OTHERS;
END BEHAVIORAL;
