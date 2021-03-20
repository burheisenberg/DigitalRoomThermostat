----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:52:27 01/09/2021 
-- Design Name: 
-- Module Name:    Thermostat_Top_Module - Behavioral 
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

entity Thermostat_Top_Module is
    Port ( MCLK : in  STD_LOGIC;
           DATA_LINE : inout  STD_LOGIC;
			  MODE	: in STD_LOGIC_VECTOR (1 DOWNTO 0);
			  UP : in STD_LOGIC;
			  DOWN : in STD_LOGIC;
			  IS_FAHRENHEIT : in STD_LOGIC;
			  DECIMAL_POINT: out STD_LOGIC;
			  COOLER	:	out STD_LOGIC;
			  HEATER	:	out STD_LOGIC;
           SEVSEG_DATA : out  STD_LOGIC_VECTOR (6 downto 0);		--	including the decimal point
           SEVSEG_CONTROL : out  STD_LOGIC_VECTOR (7 downto 0));
end Thermostat_Top_Module;

architecture Behavioral of Thermostat_Top_Module is

-- clock signals
signal wire_one_mhz	:	std_logic;
signal wire_one_khz	:	std_logic;
signal wire_ten_hz	:	std_logic;
--sensor data signal
signal wire_data_bus	: std_logic_vector(31 downto 0) := (others => '0');

-- data to display on screen
SIGNAL R_D : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL R_C : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL R_B : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL R_A : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL L_D : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL L_C : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL L_B : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL L_A : STD_LOGIC_VECTOR (3 DOWNTO 0);

-- data TO BE WRÝTTEN ON DISPLAY
SIGNAL WIRE_SEVSEG_DATA	:STD_LOGIC_VECTOR(3 DOWNTO 0);


begin

GENERATE_CLOCK	:	entity WORK.Clock_divider port map(
	MCLK => MCLK,
	MHZ => WIRE_ONE_MHZ,
	KHZ => WIRE_ONE_KHZ,
	TEN_HZ => WIRE_TEN_HZ);

READ_SENSOR	:	entity WORK.DHT22 port map(
	CLK => WIRE_ONE_MHZ,
	TRIGGER => DATA_LINE,
	PULSE => DATA_LINE,
	RESULT => WIRE_DATA_BUS);
	

SCREEN_MODE	:	entity WORK.Display_mode port map( 
			  MODE => MODE,
           UP => UP,
           DOWN => DOWN,
			  IS_FAHRENHEIT => IS_FAHRENHEIT,
			  HEATER => HEATER,
			  COOLER => COOLER,
			  DISPLAY_CLOCK => WIRE_ONE_KHZ,
           PUSH_CLOCK => WIRE_TEN_HZ,
			  WIRE_DATA_BUS => WIRE_DATA_BUS,
           R_D => R_D,
           R_C => R_C,
			  R_B => R_B,
			  R_A => R_A,
			  L_D => L_D,
			  L_C => L_C,
			  L_B => L_B,
			  L_A => L_A);

	
DISPLAY_RESULT	:	entity WORK.SEVSEG_DRIVER port map(
			  CLK => WIRE_ONE_KHZ,
			  R_D => R_D,
			  R_C => R_C,
			  R_B => R_B,
			  R_A => R_A,
			  L_D => L_D,
			  L_C => L_C,
			  L_B => L_B,
			  L_A => L_A,
			  MODE => MODE(1),
			  DECIMAL_POINT => DECIMAL_POINT,
			  SEVSEG_DATA => WIRE_SEVSEG_DATA,
			  SEVSEG_CONTROL => SEVSEG_CONTROL);

DECODE_RESULT	:	entity WORK.SEVSEG_DECODER port map(
				INPUT => WIRE_SEVSEG_DATA,
				SEVSEG_BUS => SEVSEG_DATA);


end Behavioral;

