library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SR_Latch is
	port(
		clk		: in  STD_LOGIC;
		set		: in  STD_LOGIC;
		reset	: in  STD_LOGIC;
		output	: out STD_LOGIC := '0'
	);
end SR_Latch;
	
architecture Behavioral of SR_Latch is

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				output <= '0';
			elsif (set = '1') then
				output <= '1';
			end if;
		end if;
	end process;

end Behavioral;