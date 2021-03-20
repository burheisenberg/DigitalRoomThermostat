-- Source; http://www.deathbylogic.com/2013/12/binary-to-binary-coded-decimal-bcd-converter/
-- TAKEN FROM THE WEATHER_BOX PROJECT

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY BCD_CONVERTER IS
    PORT( 
        INPUT: IN   std_logic_vector (15 DOWNTO 0);
        ONES: OUT  std_logic_vector (3 DOWNTO 0);
        TENS: OUT  std_logic_vector (3 DOWNTO 0);
        HUNDREDS: OUT  std_logic_vector (3 DOWNTO 0);
        THOUSANDS: OUT  std_logic_vector (3 DOWNTO 0)
    );
END BCD_CONVERTER;

ARCHITECTURE Behavioral OF BCD_CONVERTER IS
    ALIAS Hex_Display_Data: std_logic_vector (15 DOWNTO 0) IS INPUT;
    ALIAS rpm_1 : std_logic_vector (3 DOWNTO 0) IS ONES;
    ALIAS rpm_10 : std_logic_vector (3 DOWNTO 0) IS TENS;
    ALIAS rpm_100 : std_logic_vector (3 DOWNTO 0) IS HUNDREDS;
    ALIAS rpm_1000 : std_logic_vector (3 DOWNTO 0) IS THOUSANDS;
BEGIN
    PROCESS (Hex_Display_Data, INPUT)
        TYPE fourbits IS ARRAY (3 DOWNTO 0) OF std_logic_vector(3 DOWNTO 0);
        VARIABLE bcd : std_logic_vector (15 DOWNTO 0);
        VARIABLE bint : std_logic_vector (13 DOWNTO 0); 
    BEGIN
        bcd := (others => '0');
        bint := Hex_Display_Data (13 DOWNTO 0);

        FOR i IN 0 TO 13 LOOP
            bcd(15 DOWNTO 1) := bcd(14 DOWNTO 0);
            bcd(0) := bint(13);
            bint(13 DOWNTO 1) := bint(12 DOWNTO 0);
            bint(0) := '0';

            IF i < 13 AND bcd(3 DOWNTO 0) > "0100" THEN
                bcd(3 DOWNTO 0) := 
                    std_logic_vector (unsigned(bcd(3 DOWNTO 0)) + 3);
            END IF;
            IF i < 13 and bcd(7 DOWNTO 4) > "0100" THEN
                bcd(7 DOWNTO 4) := 
                    std_logic_vector(unsigned(bcd(7 DOWNTO 4)) + 3);
            END IF;
            IF i < 13 AND bcd(11 DOWNTO 8) > "0100" THEN
                bcd(11 DOWNTO 8) := 
                    std_logic_vector(unsigned(bcd(11 DOWNTO 8)) + 3);
            END IF;
            IF i < 13 AND bcd(15 DOWNTO 12) > "0100" THEN
                bcd(11 DOWNTO 8) := 
                    std_logic_vector(unsigned(bcd(15 DOWNTO 12)) + 3);
            END IF;
        END LOOP;
        (rpm_1000, rpm_100, rpm_10, rpm_1)  <= 
                  fourbits'( bcd (15 DOWNTO 12), bcd (11 DOWNTO 8), 
                               bcd (7 DOWNTO 4), bcd (3 DOWNTO 0) );
    END PROCESS;
END ARCHITECTURE;
