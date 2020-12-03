library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UnsignedAdder_nbit is
	generic(
		w		: INTEGER := 4
	);
	port(
		a_in	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		b_in	: in  STD_LOGIC_VECTOR (w-1 downto 0);
		output	: out STD_LOGIC_VECTOR (w-1 downto 0)
	);
end UnsignedAdder_nbit;
	
architecture Behavioral of UnsignedAdder_nbit is

begin

	output <= std_logic_vector(unsigned(a_in) + unsigned(b_in));

end Behavioral;