--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:52:46 01/11/2021
-- Design Name:   
-- Module Name:   C:/Users/Burhan/Desktop/Thermostat4/Thermostat_test10.vhd
-- Project Name:  Thermostat4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DISPLAY_MODE
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Thermostat_test10 IS
END Thermostat_test10;
 
ARCHITECTURE behavior OF Thermostat_test10 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DISPLAY_MODE
    PORT(
         MODE : IN  std_logic_vector(1 downto 0);
         UP : IN  std_logic;
         DOWN : IN  std_logic;
         IS_FAHRENHEIT : IN  std_logic;
         COOLER : OUT  std_logic;
         HEATER : OUT  std_logic;
         DISPLAY_CLOCK : IN  std_logic;
         PUSH_CLOCK : IN  std_logic;
         WIRE_DATA_BUS : IN  std_logic_vector(31 downto 0);
         R_D : OUT  std_logic_vector(3 downto 0);
         R_C : OUT  std_logic_vector(3 downto 0);
         R_B : OUT  std_logic_vector(3 downto 0);
         R_A : OUT  std_logic_vector(3 downto 0);
         L_D : OUT  std_logic_vector(3 downto 0);
         L_C : OUT  std_logic_vector(3 downto 0);
         L_B : OUT  std_logic_vector(3 downto 0);
         L_A : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal MODE : std_logic_vector(1 downto 0) := (others => '0');
   signal UP : std_logic := '0';
   signal DOWN : std_logic := '0';
   signal IS_FAHRENHEIT : std_logic := '0';
   signal DISPLAY_CLOCK : std_logic := '0';
   signal PUSH_CLOCK : std_logic := '0';
   signal WIRE_DATA_BUS : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal COOLER : std_logic;
   signal HEATER : std_logic;
   signal R_D : std_logic_vector(3 downto 0);
   signal R_C : std_logic_vector(3 downto 0);
   signal R_B : std_logic_vector(3 downto 0);
   signal R_A : std_logic_vector(3 downto 0);
   signal L_D : std_logic_vector(3 downto 0);
   signal L_C : std_logic_vector(3 downto 0);
   signal L_B : std_logic_vector(3 downto 0);
   signal L_A : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant DISPLAY_CLOCK_period : time := 10 ns;
   constant PUSH_CLOCK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DISPLAY_MODE PORT MAP (
          MODE => MODE,
          UP => UP,
          DOWN => DOWN,
          IS_FAHRENHEIT => IS_FAHRENHEIT,
          COOLER => COOLER,
          HEATER => HEATER,
          DISPLAY_CLOCK => DISPLAY_CLOCK,
          PUSH_CLOCK => PUSH_CLOCK,
          WIRE_DATA_BUS => WIRE_DATA_BUS,
          R_D => R_D,
          R_C => R_C,
          R_B => R_B,
          R_A => R_A,
          L_D => L_D,
          L_C => L_C,
          L_B => L_B,
          L_A => L_A
        );

   -- Clock process definitions
   DISPLAY_CLOCK_process :process
   begin
		DISPLAY_CLOCK <= '0';
		wait for DISPLAY_CLOCK_period/2;
		DISPLAY_CLOCK <= '1';
		wait for DISPLAY_CLOCK_period/2;
   end process;
 
   PUSH_CLOCK_process :process
   begin
		PUSH_CLOCK <= '0';
		wait for PUSH_CLOCK_period/2;
		PUSH_CLOCK <= '1';
		wait for PUSH_CLOCK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for DISPLAY_CLOCK_period*10;


      -- insert stimulus here 
	  -- For this testbench to work properly, you need to disconnect the celcius to fahrenheit converter,
	  -- and directly connect the wire_data_bus(15 downto 0) to the bcd converter
		WIRE_DATA_BUS <= "00000011001000000000000001100100";					-- h: 80.0%, t: 10.0 oC
		wait for 100 ns;
		WIRE_DATA_BUS <= "00000011001000000000000010010110";					-- h: 80.0%, t: 15.0 oC
		wait for 100 ns;
		WIRE_DATA_BUS <= "00000011001000000000000011001000";					-- h: 80.0%, t: 20.0 oC
		wait for 100 ns;
		WIRE_DATA_BUS <= "00000011001000000000000011111010";					-- h: 80.0%, t: 25.0 oC
		wait for 100 ns;
		WIRE_DATA_BUS <= "00000011001000000000000100101100";					-- h: 80.0%, t: 30.0 oC
		wait for 100 ns;
		
		WIRE_DATA_BUS <= "00000011001000000000000011001000";					-- h: 80.0%, t: 20.0 oC
		MODE <= "10";	-- UPPER BOUNDARY PROGRAMMING MODE
		UP <= '1';
		WAIT FOR 100ns;-- increase the upper boundary by 10 (15+10 = 25) 
		
		WIRE_DATA_BUS <= "00000011001000000000000011001000";					-- h: 80.0%, t: 20.0 oC
		MODE <= "11";	-- LOWER BOUNDARY PROGRAMMING MODE
		DOWN <= '1';
		WAIT FOR 100ns;-- increase the upper boundary by 10 (25-10 = 15) 
	
	
      wait;
   end process;

END;
