library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.all;
use work.unix_project.ALL;

entity Unix_Computer is
	port(
		clk			: in  STD_LOGIC;
		-- --
		switches	: in  STD_LOGIC_VECTOR (7 downto 0);
		-- --
		leds		: out STD_LOGIC_VECTOR (7 downto 0)
	);
end Unix_Computer;
	
architecture Behavioral of Unix_Computer is

	-- IO --
	signal		io_wrData		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal		io_rdData		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal		io_rwAddr		:	STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
	signal		io_wren			:	STD_LOGIC := '0';
	signal		io_ports		:	IO_ARRAY (0 to 15);
		alias	sw_in			is	io_ports(1);
		alias	led_out			is	io_ports(10);
		alias	gpm_wrData		is	io_ports(8);
		alias	ram_rdData		is	io_ports(0);
		alias	ram_wrData		is	io_ports(9);
	
	-- GPM --
	signal		guest_pc		:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal		guest_insn		:	STD_LOGIC_VECTOR (11 downto 0) := (others => '0');

begin

	sw_in <= switches;
	leds <= led_out;

	CPU: SRISC_CPU port map (
		clk			=> clk,
		reset		=> '0',
		guest_insn	=> guest_insn,
		guest_pc	=> guest_pc,
		io_din		=> io_rdData,
		io_dout		=> io_wrData,
		io_addr		=> io_rwAddr,
		io_wrEn		=> io_wren
	);
	
	IO: IO_Module generic map(x"FF00") port map(
		clk			=> clk,
		cpu_din		=> io_wrData,
		cpu_addr	=> io_rwAddr,
		cpu_wren	=> io_wren,
		cpu_dout	=> io_rdData,
		-- --
		io_ports	=> io_ports
	);
	
	GPM: Guest_ProgramMemory port map(
		clk			=> clk,
		reset		=> '0',
		cpu_din		=> gpm_wrData,
		cpu_wren	=> io_wren,
		guest_pc	=> guest_pc,
		guest_insn	=> guest_insn
	);
	
	RAM: GP_RAM port map(
		clk			=> clk,
		reset		=> '0',
		cpu_din		=> ram_wrData,
		cpu_wren	=> io_wren,
		cpu_dout	=> ram_rdData
	);

end Behavioral;