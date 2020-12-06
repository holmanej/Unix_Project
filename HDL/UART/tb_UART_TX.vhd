library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.uart.all;

entity tb_UART_TX is
end tb_UART_TX;
	
architecture Behavioral of tb_UART_TX is
	
	signal	clk			:	STD_LOGIC := '0';
	signal	input		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin

	process
	begin
		wait for 5 ns;
		input <= x"A9";
		wait;
	end process;

	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	uut: UART_TX port map(
		clk			=> clk,
		input		=> input,
		rdFlag		=> '0',
		-- --
		clrFlag		=> open,
		doneBit		=> open,
		TX			=> open
	);

end Behavioral;