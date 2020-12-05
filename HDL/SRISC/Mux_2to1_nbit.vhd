library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_2to1_nbit is
	generic(
		w		: INTEGER := 8
	);
	port(
		a_in	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		b_in	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		sel		: in  STD_LOGIC;
		-- --
		output	: out STD_LOGIC_VECTOR (w-1 downto 0)
	);
end Mux_2to1_nbit;
	
architecture Behavioral of Mux_2to1_nbit is

begin

	output <= b_in when (sel = '1') else a_in;

end Behavioral;