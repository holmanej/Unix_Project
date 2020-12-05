library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.ALL;

entity SRISC_CPU is
	port(
		clk			: in  STD_LOGIC;
		reset		: in  STD_LOGIC;
		guest_insn	: in  STD_LOGIC_VECTOR (11 downto 0);
		guest_pc	: out STD_LOGIC_VECTOR (9 downto 0);
		io_din		: in  STD_LOGIC_VECTOR (7 downto 0);
		io_dout		: out STD_LOGIC_VECTOR (7 downto 0);
		io_addr		: out STD_LOGIC_VECTOR (3 downto 0);
		io_wrEn		: out STD_LOGIC
	);
end SRISC_CPU;
	
architecture Behavioral of SRISC_CPU is
	
	signal	inst_int		:	STD_LOGIC_VECTOR (9 downto 0);
		alias	lit_addr	is	inst_int(6 downto 0);
		alias	io_addr_int	is	inst_int(3 downto 0);
		alias	alu_sel		is	inst_int(3 downto 0);
		
	signal	alu_data		:	STD_LOGIC_VECTOR (7 downto 0);
	signal	regData_a		:	STD_LOGIC_VECTOR (7 downto 0);
	signal	regData_b		:	STD_LOGIC_VECTOR (7 downto 0);
	signal	ind_addr		:	STD_LOGIC_VECTOR (6 downto 0);
	signal	mem_addr		:	STD_LOGIC_VECTOR (6 downto 0);
	signal	mem_data		:	STD_LOGIC_VECTOR (7 downto 0);
	
	signal	data_sel		:	STD_LOGIC_VECTOR (1 downto 0);
	signal	cmp_int			:	STD_LOGIC;
	signal	cmp_wrEn		:	STD_LOGIC;
	signal	carry_wrEn		:	STD_LOGIC;
	signal	reg_addr_sel	:	STD_LOGIC;
	signal	reg_wrEn		:	STD_LOGIC;
	signal	mem_addr_sel	:	STD_LOGIC;
	signal	mem_wrEn		:	STD_LOGIC;
	signal	ind_wrEn		:	STD_LOGIC;
	
begin

	ProgramMod: ProgramModule port map (
		clk			=> clk,
		reset		=> '0',
		cmp_in		=> cmp_int,		
		guest_insn	=> guest_insn,
		-- --
		guest_pc	=> guest_pc,
		inst_out	=> inst_int,
		cmp_wrEn	=> cmp_wrEn,
		data_sel	=> data_sel,
		reg_addr_sel=> reg_addr_sel,
		reg_wrEn	=> reg_wrEn,
		mem_addr_sel=> mem_addr_sel,
		mem_wrEn	=> mem_wrEn,
		ind_wrEn	=> ind_wrEn,
		io_wrEn		=> io_wrEn
	);
	
	ALUMod: ALUModule port map (
		clk			=> clk,
		alu_sel		=> alu_sel,
		-- --
		regData_a	=> regData_a,
		regData_b	=> regData_b,
		cmp_wrEn	=> cmp_wrEn,
		alu_out		=> alu_data,
		cmp_out		=> cmp_int
	);
	
	RegisterMod: RegisterModule port map (
		clk			=> clk,
		inst_in		=> inst_int,
		alu_data	=> alu_data,
		mem_data	=> mem_data,
		io_data		=> io_din,
		data_sel	=> data_sel,
		addr_sel	=> reg_addr_sel,
		wrEn		=> reg_wrEn,
		-- --
		regData_a	=> regData_a,
		regData_b	=> regData_b
	);
	
	Indirect: Register_nbit generic map(7) port map (
		clk			=> clk,
		rst			=> reset,
		wrData		=> regData_a(6 downto 0),
		wrEn		=> ind_wrEn,
		rdData		=> ind_addr
	);
	
	MemAddrSel: Mux_2to1_nbit generic map(7) port map (
		a_in		=> lit_addr,
		b_in		=> ind_addr,
		sel			=> mem_addr_sel,
		-- --
		output		=> mem_addr
	);

	MemoryMod: MemoryModule port map (
		clk			=> clk,
		wrAddr		=> mem_addr,
		wrData		=> regData_a,
		wrEn		=> mem_wrEn,
		rdAddr		=> mem_addr,
		-- --
		rdData		=> mem_data
	);
	
	io_addr <= io_addr_int;
	io_dout <= regData_a;
	
end Behavioral;