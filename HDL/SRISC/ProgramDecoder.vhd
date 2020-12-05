library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramDecoder is
	port(
		inst_in		: in  STD_LOGIC_VECTOR (11 downto 0);
		cmp_in		: in  STD_LOGIC;
		src_sel		: in  STD_LOGIC;
		-- --
		prog_sel	: out STD_LOGIC;
		cmp_wrEn	: out STD_LOGIC;
		data_sel	: out STD_LOGIC_VECTOR (1 downto 0);
		reg_addr_sel: out STD_LOGIC;
		reg_wrEn	: out STD_LOGIC;
		mem_addr_sel: out STD_LOGIC;
		mem_wrEn	: out STD_LOGIC;
		ind_wrEn	: out STD_LOGIC;
		io_wrEn		: out STD_LOGIC;
		exec_cmd	: out STD_LOGIC;
		exit_cmd	: out STD_LOGIC
	);
end ProgramDecoder;
	
architecture Behavioral of ProgramDecoder is

	constant	jmp_3ff	:	STD_LOGIC_VECTOR (11 downto 0) := (others => '1');

	alias	opcode		is	inst_in(11 downto 10);
	alias	rw_sel		is	inst_in(7);
	alias	addrHigh	is	inst_in(6 downto 4);
	alias	mem_addr	is	inst_in(6 downto 0);
	alias	alu_op		is	inst_in(3 downto 0);

begin

	prog_sel	<= '1' when (opcode = "11" and cmp_in = '1') or (inst_in = jmp_3ff and src_sel = '1') else '0';
	cmp_wrEn	<= '1' when (opcode = "01") else '0';
	data_sel	<= "11" when (opcode = "10" and addrHigh = "111") else opcode;
	reg_addr_sel<= '1' when (opcode = "10") else '0';
	reg_wrEn	<= '1' when (opcode = "00" or (opcode = "01" and unsigned(alu_op) <= 9) or (opcode = "10" and rw_sel = '0')) else '0';
	mem_addr_sel<= '1' when (mem_addr = "0000000") else '0';
	mem_wrEn	<= '1' when (opcode = "10" and rw_sel = '1' and addrHigh /= "111") else '0';
	ind_wrEn	<= '1' when (opcode = "01" and alu_op = x"A") else '0';
	io_wrEn		<= '1' when (opcode = "10" and rw_sel = '1' and addrHigh = "111") else '0';
	exec_cmd	<= '1' when (inst_in = jmp_3ff and src_sel = '0') else '0';
	exit_cmd	<= '1' when (inst_in = jmp_3ff and src_sel = '1') else '0';

end Behavioral;