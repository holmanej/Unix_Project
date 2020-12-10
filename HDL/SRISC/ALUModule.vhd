library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUModule is
	port(
		clk			: in  STD_LOGIC;
		alu_sel		: in  STD_LOGIC_VECTOR (3 downto 0);
		regData_a	: in  STD_LOGIC_VECTOR (7 downto 0);
		regData_b	: in  STD_LOGIC_VECTOR (7 downto 0);
		cmp_wrEn	: in  STD_LOGIC;
		-- --
		alu_out		: out STD_LOGIC_VECTOR (7 downto 0);
		cmp_out		: out STD_LOGIC
	);
end ALUModule;
	
architecture Behavioral of ALUModule is

	

	signal		aData		:	UNSIGNED (8 downto 0);
	signal		bData		:	UNSIGNED (8 downto 0);
	signal		result		:	UNSIGNED (8 downto 0);
	signal 		cmp			:	STD_LOGIC;

begin

	aData <= unsigned('0' & regData_a);
	bData <= unsigned('0' & regData_b);

	process(aData, bData, alu_sel, result)
	begin
		case alu_sel is
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
		
		case alu_sel is
			when x"0" => cmp <= result(8);
			when x"1" => cmp <= result(8);
			when x"8" => cmp <= result(8);
			when x"9" => cmp <= result(8);
			when x"B" => cmp <= '1' when (aData < bData) else '0';
			when x"C" => cmp <= '1' when (signed(aData(7 downto 0)) < signed(bData(7 downto 0))) else '0';
			when x"D" => cmp <= '1' when (aData = bData) else '0';
			when x"E" => cmp <= '1' when (aData = 0) else '0';
			when x"F" => cmp <= '1';
			when others => cmp <= '0';
		end case;
			
	end process;
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (cmp_wren = '1') then
				cmp_out <= cmp;
			end if;
		end if;
	end process;
	
	alu_out <= std_logic_vector(result(7 downto 0));

end Behavioral;