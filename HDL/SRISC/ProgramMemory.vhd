library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.ALL;

entity ProgramMemory is
	port(
		rdAddr	: in  STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
		-- --
		rdData	: out STD_LOGIC_VECTOR (11 downto 0)
	);
end ProgramMemory;
	
architecture Behavioral of ProgramMemory is
	
	signal		inst_int	:	INST_TYPE := READ_BIN_FILE("C:\Users\holma\source\repos\Unix_Project\S Code\sw_to_led.bin");
	attribute	ramstyle	:	string;
	attribute	ramstyle of inst_int	:	signal is "block";
	
begin

	rdData <= inst_int(to_integer(unsigned(rdAddr)));

end Behavioral;