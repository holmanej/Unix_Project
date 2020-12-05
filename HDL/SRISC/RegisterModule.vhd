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
		wrEn		: in  STD_LOGIC;
		-- --
		regData_a	: out STD_LOGIC_VECTOR (7 downto 0);
		regData_b	: out STD_LOGIC_VECTOR (7 downto 0)
	);
end RegisterModule;
	
architecture Behavioral of RegisterModule is
	
	alias	io_rdAddr	is	inst_in(9 downto 8);
	alias	alu_rdAddr	is	inst_in(7 downto 6);
	alias	regB_rdAddr	is	inst_in(5 downto 4);
	alias	inst_imm	is	inst_in(7 downto 0);
	
	signal	wrData		:	STD_LOGIC_VECTOR (7 downto 0);
	signal	regA_rdAddr	:	STD_LOGIC_VECTOR (1 downto 0);

begin

	RegisterMux: Mux_4to1_nbit port map (
		in_1	=> inst_imm,
		in_2	=> alu_data,
		in_3	=> mem_data,
		in_4	=> io_data,
		sel		=> data_sel,
		output	=> wrData
	);

	AddrMux: Mux_2to1_nbit generic map(2) port map (
		a_in	=> alu_rdAddr,
		b_in	=> io_rdAddr,
		sel		=> addr_sel,
		output	=> regA_rdAddr
	);

	Memory: RegisterMemory port map (
		clk			=> clk,
		wrAddr		=> io_rdAddr,
		wrData		=> wrData,
		wrEn		=> wrEn,
		rdAddr_a	=> regA_rdAddr,
		rdAddr_b	=> regB_rdAddr,
		rdData_a	=> regData_a,
		rdData_b	=> regData_b
	);

end Behavioral;