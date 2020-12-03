library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library work;
----------------------------------------------------------------------------
package unix_project is

	-- MODULES --
	component SRISC_CPU is
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
	end component;
	
	component IO_Module is
		generic(
			-- 0..7 inputs; 8..15 outputs
			readonly	:	STD_LOGIC_VECTOR (15 downto 0) := x"00FF"
		);
		port(
			clk			: in  STD_LOGIC;
			cpu_in		: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_addr	: in  STD_LOGIC_VECTOR (3 downto 0);
			cpu_wren	: in  STD_LOGIC;
			cpu_dout	: out STD_LOGIC_VECTOR (7 downto 0);
			-- --
			io_ports	: inout IO_ARRAY (0 to 15)
		);
	end component;
	
	component SPRAM_MxN is
		generic(
			M		:	INTEGER := 8;	-- depth
			N		:	INTEGER := 16	-- width
		);
		port(
			clk		: in  STD_LOGIC;
			reset	: in  STD_LOGIC := '0';
			-- --
			wrAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0) := (others => '0');
			wrData	: in  STD_LOGIC_VECTOR (N-1 downto 0);
			wren	: in  STD_LOGIC;
			-- --
			rdAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0);
			rdData	: out STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end component;
	
end unix_project;