----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:14:01 01/09/2021 
-- Design Name: 
-- Module Name:    SEVSEG_DRIVER - Behavioral 
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SEVSEG_DRIVER IS
    PORT(CLK : IN STD_LOGIC;
			L_D : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			L_C : IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
			L_B : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			L_A : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			R_D : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			R_C : IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
			R_B : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			R_A : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			MODE: IN STD_LOGIC;
			DECIMAL_POINT :OUT STD_LOGIC;
         SEVSEG_DATA : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
         SEVSEG_CONTROL : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) 
			  );
END SEVSEG_DRIVER;

ARCHITECTURE Behavioral OF SEVSEG_DRIVER IS

SIGNAL COUNTER : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";

BEGIN

PROCESS_CLK : PROCESS(CLK)

BEGIN

	IF (CLK'EVENT AND CLK = '1') THEN
		COUNTER <= COUNTER + '1';
	END IF;

END PROCESS;

WITH COUNTER SELECT DECIMAL_POINT <=
	'0' WHEN "001",
	MODE WHEN "101",
	'1' WHEN OTHERS;

WITH COUNTER SELECT SEVSEG_DATA <=
	L_A WHEN "111",
	L_B WHEN "110",
	L_C WHEN "101",
	L_D WHEN "100",
	R_A WHEN "011",
	R_B WHEN "010",
	R_C WHEN "001",
	R_D WHEN "000",
	"0000" WHEN OTHERS;

WITH COUNTER SELECT SEVSEG_CONTROL <=
	"11111110" WHEN "111",
	"11111101" WHEN "110",
	"11111011" WHEN "101",
	"11110111" WHEN "100",
	"11101111" WHEN "011",
	"11011111" WHEN "010",
	"10111111" WHEN "001",
	"01111111" WHEN "000",
	"11111111" WHEN OTHERS;

END Behavioral;

