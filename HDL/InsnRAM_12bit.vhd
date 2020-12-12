library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.all;

entity InsnRAM_12bit is
	generic(
		M		:	INTEGER := 10
	);
	port(
		clk		: in  STD_LOGIC;
		reset	: in  STD_LOGIC := '0';
		-- --
		wrAddr	: in  STD_LOGIC_VECTOR (M downto 0) := (others => '0');
		wrData	: in  STD_LOGIC_VECTOR (7 downto 0);
		wren	: in  STD_LOGIC;
		-- --
		rdAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0);
		rdData	: out STD_LOGIC_VECTOR (11 downto 0)
	);
end InsnRAM_12bit;
	
architecture Behavioral of InsnRAM_12bit is
	
	signal		mem_int		:	BIT12_ARRAY := READ_BIN_FILE("C:\Users\holma\source\repos\Unix_Project\S_Code\uart_guest_loader.bin");
	
	signal		writeAddr	:	INTEGER := 0;
	
begin

	writeAddr <= to_integer(unsigned(wrAddr(M downto 1)));

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (wren = '1') then
				if (wrAddr(0) = '0') then
					mem_int(writeAddr)(7 downto 0) <= wrData;
				else
					mem_int(writeAddr)(11 downto 8) <= wrData(3 downto 0);
				end if;
			end if;
			
			rdData <= mem_int(to_integer(unsigned(rdAddr)));
		end if;		
	end process;

end Behavioral;