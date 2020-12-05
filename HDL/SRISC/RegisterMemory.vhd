library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterMemory is
	port(
		clk		: in  STD_LOGIC;
		wrAddr	: in  STD_LOGIC_VECTOR (1 downto 0);
		wrData	: in  STD_LOGIC_VECTOR (7 downto 0);
		wrEn	: in  STD_LOGIC;
		rdAddr_a: in  STD_LOGIC_VECTOR (1 downto 0);
		rdAddr_b: in  STD_LOGIC_VECTOR (1 downto 0);
		-- --
		rdData_a: out STD_LOGIC_VECTOR (7 downto 0);
		rdData_b: out STD_LOGIC_VECTOR (7 downto 0)
	);
end RegisterMemory;
	
architecture Behavioral of RegisterMemory is

	type		regArray	is	ARRAY (0 to 3) of STD_LOGIC_VECTOR (7 downto 0);
	
	signal		regMem		:	regArray := (others => (others => '0'));

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (wrEn = '1') then
				regMem(to_integer(unsigned(wrAddr))) <= wrData;
			end if;
		end if;
	end process;
	
	rdData_a <= regMem(to_integer(unsigned(rdAddr_a)));
	rdData_b <= regMem(to_integer(unsigned(rdAddr_b)));

end Behavioral;