library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.ALL;

entity Unix_Project is
	port(
		clk			: in  STD_LOGIC;
	);
end Unix_Project;
	
architecture Behavioral of Unix_Project is

begin

	CPU: SRISC_CPU port map (
		clk			=> clk,
		reset		=> '0',
		guest_insn	=> guest_insn,
		guest_pc	=> guest_pc,
		io_din		=> x"00",
		io_dout		=> open,
		io_addr		=> open,
		io_wrEn		=> open
	);

end Behavioral;