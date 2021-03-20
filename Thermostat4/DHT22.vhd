-- TAKEN FROM ONE OF THE PREVIOUSLY MADE PROJECTS: WEATHER_BOX
-- AND SIMPLIFIED
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DHT22 IS
	PORT (CLK : IN STD_LOGIC;
			PULSE : IN STD_LOGIC;
			TRIGGER : OUT STD_LOGIC;
			RESULT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END DHT22;

ARCHITECTURE Behavioral OF DHT22 IS

SIGNAL TriggerCounter : INTEGER := 0;
SIGNAL CS : INTEGER := 39;
SIGNAL CountStart : STD_LOGIC := '0';
SIGNAL PulseCounter : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
SIGNAL Temp_Data : STD_LOGIC_VECTOR(39 DOWNTO 0) := X"0000000000";
SIGNAL Temp_Temp, Temp_Humd : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

TEMP_COLLECTOR : PROCESS(CLK)

BEGIN

	IF (RISING_EDGE(CLK)) THEN									-- Trigger
		IF(TriggerCounter < 10000) THEN
			TriggerCounter <= TriggerCounter + 1;
			TRIGGER <= '0';
			CountStart <= '0';
		ELSIF(TriggerCounter >= 10000 AND TriggerCounter < 10030) THEN
			TriggerCounter <= TriggerCounter + 1;
			TRIGGER <= '1';
			CountStart <= '0';
		ELSIF(TriggerCounter >= 10030 AND TriggerCounter < 10200) THEN
			TriggerCounter <= TriggerCounter + 1;
			TRIGGER <= 'Z';
			CountStart <= '0';
		ELSIF(TriggerCounter >= 10200) THEN
			TriggerCounter <= TriggerCounter + 1;
			TRIGGER <= 'Z';
			CountStart <= '1';
		END IF;
		
		IF(CountStart = '1') THEN
		
			PulseCounter <= PulseCounter + 1;
			
			IF(PULSE = '0' AND CS > 0) THEN					-- Arranges input pulses to the 40-bit array
				IF (PulseCounter >= "1010000") THEN
				ELSIF(PulseCounter < "0100000" AND PulseCounter > "0000000") THEN
					Temp_Data(CS) <= '0';
					CS <= CS - 1;
				ELSIF(PulseCounter > "0100000" AND PulseCounter < "1010000") THEN
					Temp_Data(CS) <= '1';
					CS <= CS - 1;
				END IF;
				PulseCounter <= "0000000";
			END IF;
		END IF;
		
		IF(TriggerCounter = 4000000) THEN					--	Resets the whole system after 4 second
			TriggerCounter <= 0;
			PulseCounter <= "0000000";
			Temp_Data <= X"0000000000";
			TRIGGER <= '0';
			CountStart <= '0';
			CS <= 39;
		END IF;
		
	END IF;
	
	Temp_Temp <= Temp_Data(24 DOWNTO 9);
	Temp_Humd <= '0' & Temp_Data(39 DOWNTO 25);

	RESULT(31 DOWNTO 16) <= Temp_humd;		-- humidity data for the first 16 bit
	
	RESULT(15 DOWNTO 0) <= Temp_temp;	-- this data is in the form of degree celcius

END PROCESS;

END Behavioral;
