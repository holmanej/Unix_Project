library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPRAM_MxN is
	generic(
		M		:	INTEGER := 8;	-- depth
		N		:	INTEGER := 16	-- width
	);
	port(
		clk		: in  STD_LOGIC;
		reset	: in  STD_LOGIC := '0';
		-- --
		wrAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0) := (others => '0');
		wrData	: in  STD_LOGIC_VECTOR (N-1 downto 0);
		wren	: in  STD_LOGIC;
		-- --
		rdAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0);
		rdData	: out STD_LOGIC_VECTOR (N-1 downto 0)
	);
end SPRAM_MxN;
	
architecture Behavioral of SPRAM_MxN is

	type		memArray	is	ARRAY (0 to 2**M-1) of STD_LOGIC_VECTOR (N-1 downto 0);
	
	signal		mem_int		:	memArray := (
		others => (others => '0')
	);
	
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (wren = '1') then
				mem_int(to_integer(unsigned(wrAddr))) <= wrData;
			end if;
		end if;		
	end process;
	
	rdData <= (others => '0') when (reset = '1') else mem_int(to_integer(unsigned(rdAddr)));

end Behavioral;