library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.ALL;

entity RegisterModule is
	port(
		clk			: in  STD_LOGIC;
		inst_in		: in  STD_LOGIC_VECTOR (9 downto 0);
		alu_data	: in  STD_LOGIC_VECTOR (7 downto 0);
		mem_data	: in  STD_LOGIC_VECTOR (7 downto 0);
		io_data		: in  STD_LOGIC_VECTOR (7 downto 0);
		data_sel	: in  STD_LOGIC_VECTOR (1 downto 0);
		addr_sel	: in  STD_LOGIC;
		wren		: in  STD_LOGIC;
		-- --
		regData_a	: out STD_LOGIC_VECTOR (7 downto 0);
		regData_b	: out STD_LOGIC_VECTOR (7 downto 0)
	);
end RegisterModule;
	
architecture Behavioral of RegisterModule is	
	
	alias		io_rdAddr	is	inst_in(9 downto 8);
	alias		alu_rdAddr	is	inst_in(7 downto 6);
	alias		regB_rdAddr	is	inst_in(5 downto 4);
	alias		inst_imm	is	inst_in(7 downto 0);
	
	signal		regMem		:	BIT8_ARRAY (0 to 3) := (others => (others => '0'));
	
	signal		wrData		:	STD_LOGIC_VECTOR (7 downto 0);
	signal		regA_rdAddr	:	STD_LOGIC_VECTOR (1 downto 0);

begin

	with data_sel select wrData <=
		inst_imm when "00",
		alu_data when "01",
		mem_data when "10",
		io_data  when others;
		
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (wren = '1') then
				regMem(to_integer(unsigned(io_rdAddr))) <= wrData;
			end if;
		end if;
	end process;
	
	regA_rdAddr <= io_rdAddr when (addr_sel = '1') else alu_rdAddr;
	regData_a <= regMem(to_integer(unsigned(regA_rdAddr)));
	regData_b <= regMem(to_integer(unsigned(regB_rdAddr)));

end Behavioral;