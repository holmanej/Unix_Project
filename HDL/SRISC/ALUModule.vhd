library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.ALL;

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

	signal	cmp_int		:	STD_LOGIC_VECTOR (0 downto 0);

begin

	ALU: ALULogic port map (
		a_in	=> regData_a,
		b_in	=> regData_b,
		sel		=> alu_sel,
		output	=> alu_out,
		cmp_out	=> cmp_int(0)
	);
	
	Compare: Register_nbit generic map(1) port map (
		clk			=> clk,
		rst			=> '0',
		wrData		=> cmp_int,
		wrEn		=> cmp_wrEn,
		rdData(0)	=> cmp_out
	);

end Behavioral;