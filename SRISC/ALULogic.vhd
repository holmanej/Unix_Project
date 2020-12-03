library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALULogic is
	port(
		a_in	: in  STD_LOGIC_VECTOR (7 downto 0);
		b_in	: in  STD_LOGIC_VECTOR (7 downto 0);
		sel		: in  STD_LOGIC_VECTOR (3 downto 0);
		-- --
		output	: out STD_LOGIC_VECTOR (7 downto 0);
		cmp_out	: out STD_LOGIC
	);
end ALULogic;
	
architecture Behavioral of ALULogic is

	signal aData		:	UNSIGNED (8 downto 0);
	signal bData		:	UNSIGNED (8 downto 0);
	signal result		:	UNSIGNED (8 downto 0);

begin

	aData <= unsigned('0' & a_in);
	bData <= unsigned('0' & b_in);

	process(aData, bData, sel, result)
	begin
		case sel is
			when x"0" => result <= aData + bData;
			when x"1" => result <= aData - bData;
			when x"2" => result <= aData and bData;
			when x"3" => result <= aData or bData;
			when x"4" => result <= aData xor bData;
			when x"5" => result <= not aData;
			when x"6" => result <= aData sll to_integer(bData);
			when x"7" => result <= aData srl to_integer(bData);
			when x"8" => result <= aData + 1;
			when x"9" => result <= aData - 1;			
			when others => result <= aData;
		end case;
		
		case sel is
			when x"0" => cmp_out <= result(8);
			when x"1" => cmp_out <= result(8);
			when x"8" => cmp_out <= result(8);
			when x"9" => cmp_out <= result(8);
			when x"B" => cmp_out <= '1' when (aData < bData) else '0';
			when x"C" => cmp_out <= '1' when (signed(aData(7 downto 0)) < signed(bData(7 downto 0))) else '0';
			when x"D" => cmp_out <= '1' when (aData = bData) else '0';
			when x"E" => cmp_out <= '1' when (aData = 0) else '0';
			when x"F" => cmp_out <= '1';
			when others => cmp_out <= '0';
		end case;
			
	end process;
	
	output <= std_logic_vector(result(7 downto 0));

end Behavioral;