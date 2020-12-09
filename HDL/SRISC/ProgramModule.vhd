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
		prog_addr	: out STD_LOGIC_VECTOR (9 downto 0);
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
	
	constant const_one		:	STD_LOGIC_VECTOR (9 downto 0) := (0 => '1', others => '0');
	
	alias	branchAddr	is	instruction(9 downto 0);
		
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
		inst_in		=> instruction,
		cmp_in		=> cmp_in,
		src_sel		=> src_sel,
		-- --
		prog_sel	=> nextAddr_sel,
		cmp_wren	=> cmp_wren,
		data_sel	=> data_sel,
		reg_addr_sel=> reg_addr_sel,
		reg_wren	=> reg_wren,
		mem_addr_sel=> mem_addr_sel,
		mem_wren	=> mem_wren,
		ind_wren	=> ind_wren,
		io_wren		=> io_wren,
		io_rden		=> io_rden,
		exec_cmd	=> exec_cmd,
		exit_cmd	=> exit_cmd
	);
	
	GuestEnable: SR_Latch port map (
		clk		=> clk,
		set		=> exec_cmd,
		reset	=> exit_cmd,
		output	=> src_sel
	);

	AddrRegister: Register_nbit generic map(10) port map (
		clk		=> clk,
		rst		=> exec_cmd,
		wrData	=> wrAddr,
		wren	=> '1',
		rdData	=> rdAddr
	);
	
	BranchMux: Mux_2to1_nbit generic map(10) port map (
		a_in	=> branchAddr,
		b_in	=> returnAddr,
		sel		=> exit_cmd,
		output	=> pc_branch
	);
	
	ROMReg: Register_nbit generic map(10) port map (
		clk		=> clk,
		rst		=> reset,
		wrData	=> pc_addone,
		wren	=> exec_cmd,
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
	
	prog_addr <= rdAddr;
	inst_out <= instruction(9 downto 0);

end Behavioral;