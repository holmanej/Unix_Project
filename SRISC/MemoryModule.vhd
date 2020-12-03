library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.ALL;

entity MemoryModule is
	port(
		clk			: in  STD_LOGIC;
		wrAddr		: in  STD_LOGIC_VECTOR (6 downto 0);
		wrData		: in  STD_LOGIC_VECTOR (7 downto 0);
		wrEn		: in  STD_LOGIC;
		rdAddr		: in  STD_LOGIC_VECTOR (6 downto 0);
		-- --
		rdData		: out STD_LOGIC_VECTOR (7 downto 0)
	);
end MemoryModule;
	
architecture Behavioral of MemoryModule is	
	
	signal		mem_int		:	MEM_TYPE := (others => (others => '0'));
	attribute	ramstyle	:	string;
	attribute	ramstyle of mem_int	:	signal is "block";

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (wrEn = '1') then
				mem_int(to_integer(unsigned(wrAddr))) <= wrData;
			end if;
		end if;
	end process;
	
	rdData <= mem_int(to_integer(unsigned(rdAddr)));

end Behavioral;