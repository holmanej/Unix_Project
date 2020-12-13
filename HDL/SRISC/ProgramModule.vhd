library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.ALL;

entity ProgramModule is
	port(
		clk			: in  STD_LOGIC;
		reset		: in  STD_LOGIC;
		cmp_in		: in  STD_LOGIC;
		instruction	: in  STD_LOGIC_VECTOR (11 downto 0);
		-- --
		prog_addr	: out STD_LOGIC_VECTOR (10 downto 0);
		inst_out	: out STD_LOGIC_VECTOR (9 downto 0);
		cmp_wren	: out STD_LOGIC;
		data_sel	: out STD_LOGIC_VECTOR (1 downto 0);
		reg_addr_sel: out STD_LOGIC;
		reg_wren	: out STD_LOGIC;
		mem_addr_sel: out STD_LOGIC;
		mem_wren	: out STD_LOGIC;
		ind_wren	: out STD_LOGIC;
		io_wren		: out STD_LOGIC;
		io_rden		: out STD_LOGIC
	);
end ProgramModule;
	
architecture Behavioral of ProgramModule is
	
	constant	jmp_3ff	:	STD_LOGIC_VECTOR (11 downto 0) := (others => '1');

	alias	opcode		is	instruction(11 downto 10);
	alias	branch_addr	is	instruction(9 downto 0);
	alias	rw_sel		is	instruction(7);
	alias	addrHigh	is	instruction(6 downto 4);
	alias	mem_addr	is	instruction(6 downto 0);
	alias	alu_op		is	instruction(3 downto 0);	
	
	signal	branch_en		:	STD_LOGIC := '0';
	signal	src_sel			:	STD_LOGIC := '0';
	signal	exec_cmd		:	STD_LOGIC := '0';
	signal	exit_cmd		:	STD_LOGIC := '0';
	
	signal	rom_addr		:	UNSIGNED (9 downto 0) := (others => '0');
	signal	guest_addr		:	UNSIGNED (9 downto 0) := (others => '0');
	

begin	

	branch_en	<= '1' when (opcode = "11" and cmp_in = '1') else '0';
	cmp_wren	<= '1' when (opcode = "01") else '0';
	data_sel	<= "11" when (opcode = "10" and addrHigh = "111") else opcode;
	reg_addr_sel<= '1' when (opcode = "10") else '0';
	reg_wren	<= '1' when (opcode = "00" or (opcode = "01" and unsigned(alu_op) <= 9) or (opcode = "10" and rw_sel = '0')) else '0';
	mem_addr_sel<= '1' when (mem_addr = "0000000") else '0';
	mem_wren	<= '1' when (opcode = "10" and rw_sel = '1' and addrHigh /= "111") else '0';
	ind_wren	<= '1' when (opcode = "01" and alu_op = x"A") else '0';
	io_wren		<= '1' when (opcode = "10" and rw_sel = '1' and addrHigh = "111") else '0';
	io_rden		<= '1' when (opcode = "10" and rw_sel = '0' and addrHigh = "111") else '0';
	exec_cmd	<= '1' when (instruction = jmp_3ff and src_sel = '0') else '0';
	exit_cmd	<= '1' when (instruction = jmp_3ff and src_sel = '1') else '0';
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (exit_cmd = '1') then
				src_sel <= '0';
			elsif (exec_cmd = '1') then
				src_sel <= '1';
			end if;
			
			if (src_sel = '0') then
				if (exec_cmd = '1') then
				elsif (branch_en = '1') then
					rom_addr <= unsigned(branch_addr) + 1;
				else
					rom_addr <= rom_addr + 1;
				end if;
			else
				if (exec_cmd = '1') then
					guest_addr <= (others => '0');
				elsif (branch_en = '1') then
					guest_addr <= unsigned(branch_addr) + 1;
				else
					guest_addr <= guest_addr + 1;
				end if;
			end if;
			
		end if;
	end process;
	
	process(src_sel, branch_en, rom_addr, guest_addr)
	begin
		if (branch_en = '1') then
			prog_addr <= src_sel & branch_addr;
		else
			if (src_sel = '1') then
				prog_addr <= '1' & std_logic_vector(guest_addr);
			else
				prog_addr <= '0' & std_logic_vector(rom_addr);
			end if;
		end if;
	end process;
	
	inst_out <= instruction(9 downto 0);

end Behavioral;