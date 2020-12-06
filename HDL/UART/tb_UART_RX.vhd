library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.uart.all;

entity tb_UART_RX is
end tb_UART_RX;
	
architecture Behavioral of tb_UART_RX is

	constant	sixnine	:	STD_LOGIC_VECTOR (7 downto 0) := x"69";
	
	signal	clk			:	STD_LOGIC := '0';
	signal	rx			:	STD_LOGIC := '1';

begin

	process
	begin
		wait for 5 ns;
		rx <= '0';
		wait for 10 us;
		for i in 0 to 7 loop
			rx <= sixnine(i);
			wait for 10 us;
		end loop;
		rx <= '1';
		
		wait;
	end process;

	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	uut: UART_RX port map(
		clk			=> clk,
		RX			=> rx,
		-- --
		output		=> open,
		wrFlag		=> open
	);

end Behavioral;