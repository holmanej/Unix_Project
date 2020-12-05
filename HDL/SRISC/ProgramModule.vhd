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
		guest_insn	: in  STD_LOGIC_VECTOR (11 downto 0);
		-- --
		guest_pc	: out STD_LOGIC_VECTOR (9 downto 0);
		inst_out	: out STD_LOGIC_VECTOR (9 downto 0);
		cmp_wrEn	: out STD_LOGIC;
		data_sel	: out STD_LOGIC_VECTOR (1 downto 0);
		reg_addr_sel: out STD_LOGIC;
		reg_wrEn	: out STD_LOGIC;
		mem_addr_sel: out STD_LOGIC;
		mem_wrEn	: out STD_LOGIC;
		ind_wrEn	: out STD_LOGIC;
		io_wrEn		: out STD_LOGIC
	);
end ProgramModule;
	
architecture Behavioral of ProgramModule is
	
	constant const_one		:	STD_LOGIC_VECTOR (9 downto 0) := (0 => '1', others => '0');
	
	signal	terminal_insn	:	STD_LOGIC_VECTOR (11 downto 0);
	signal	insn_int		:	STD_LOGIC_VECTOR (11 downto 0);
		alias	branchAddr	is	insn_int(9 downto 0);
		
	signal	rdAddr			:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal	wrAddr			:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal	pc_addone		:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal	pc_branch		:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal	returnAddr		:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	
	signal	nextAddr_sel	:	STD_LOGIC := '0';
	signal	src_sel			:	STD_LOGIC := '0';
	signal	exec_cmd		:	STD_LOGIC := '0';
	signal	exit_cmd		:	STD_LOGIC := '0';

begin

	Decoder: ProgramDecoder port map (
		inst_in		=> insn_int,
		cmp_in		=> cmp_in,
		src_sel		=> src_sel,
		-- --
		prog_sel	=> nextAddr_sel,
		cmp_wrEn	=> cmp_wrEn,
		data_sel	=> data_sel,
		reg_addr_sel=> reg_addr_sel,
		reg_wrEn	=> reg_wrEn,
		mem_addr_sel=> mem_addr_sel,
		mem_wrEn	=> mem_wrEn,
		ind_wrEn	=> ind_wrEn,
		io_wrEn		=> io_wrEn,
		exec_cmd	=> exec_cmd,
		exit_cmd	=> exit_cmd
	);
		
	InsnMux: Mux_2to1_nbit generic map(12) port map (
		a_in	=> terminal_insn,
		b_in	=> guest_insn,
		sel		=> src_sel,
		output	=> insn_int
	);
	
	GuestEnable: SR_Latch port map (
		clk		=> clk,
		set		=> exec_cmd,
		reset	=> exit_cmd,
		output	=> src_sel
	);
	
	Memory: ProgramMemory port map (
		rdAddr	=> rdAddr,
		rdData	=> terminal_insn
	);

	AddrRegister: Register_nbit generic map(10) port map (
		clk		=> clk,
		rst		=> exec_cmd,
		wrData	=> wrAddr,
		wrEn	=> '1',
		rdData	=> rdAddr
	);
	
	BranchMux: Mux_2to1_nbit generic map(10) port map (
		a_in	=> branchAddr,
		b_in	=> returnAddr,
		sel		=> exit_cmd,
		output	=> pc_branch
	);
	
	ReturnReg: Register_nbit generic map(10) port map (
		clk		=> clk,
		rst		=> reset,
		wrData	=> pc_addone,
		wrEn	=> exec_cmd,
		rdData	=> returnAddr
	);
	
	AddrMux: Mux_2to1_nbit generic map(10) port map (
		a_in	=> pc_addone,
		b_in	=> pc_branch,
		sel		=> nextAddr_sel,
		output	=> wrAddr
	);
	
	AddrAdder: UnsignedAdder_nbit generic map(10) port map (
		a_in	=> rdAddr,
		b_in	=> const_one,
		output	=> pc_addone
	);
	
	guest_pc <= rdAddr;
	inst_out <= insn_int(9 downto 0);

end Behavioral;