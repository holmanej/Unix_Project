library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_4to1_nbit is
	generic(
		w		: INTEGER := 8
	);
	port(
		in_1	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		in_2	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		in_3	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		in_4	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		sel		: in  STD_LOGIC_VECTOR (1 downto 0);
		-- --
		output	: out STD_LOGIC_VECTOR (w-1 downto 0)
	);
end Mux_4to1_nbit;
	
architecture Behavioral of Mux_4to1_nbit is

begin

	with sel select output <=
		in_4 when "11",
		in_3 when "10",
		in_2 when "01",
		in_1 when others;

end Behavioral;