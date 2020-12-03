library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_nbit is
	generic(
		w		: INTEGER := 4
	);
	port(
		clk		: in  STD_LOGIC;
		rst		: in  STD_LOGIC;
		wrData	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		wrEn	: in  STD_LOGIC;
		rdData	: out STD_LOGIC_VECTOR (w-1 downto 0) := (others => '0')
	);
end Register_nbit;
	
architecture Behavioral of Register_nbit is

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				rdData <= (others => '0');
			elsif (wrEn = '1') then
				rdData <= wrData;
			end if;
		end if;
	end process;

end Behavioral;