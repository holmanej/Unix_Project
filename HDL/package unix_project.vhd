library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library work;
use work.srisc.all;
----------------------------------------------------------------------------
package unix_project is

	-- MODULES --	
	component IO_Module is
		generic(
			-- 0..7 inputs; 8..15 outputs
			readonly	:	STD_LOGIC_VECTOR (15 downto 0) := x"00FF"
		);
		port(
			clk			: in  STD_LOGIC;
			cpu_din		: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_addr	: in  STD_LOGIC_VECTOR (3 downto 0);
			cpu_wren	: in  STD_LOGIC;
			cpu_dout	: out STD_LOGIC_VECTOR (7 downto 0);
			-- --
			io_ports	: inout IO_ARRAY (0 to 15)
		);
	end component;
	
	component MemoryController is
		generic(
			M			:	INTEGER := 8
		);
		port(
			clk			: in  STD_LOGIC;
			input		: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_wren	: in  STD_LOGIC;
			-- --
			addrOut		: out STD_LOGIC_VECTOR (M-1 downto 0);
			dataOut		: out STD_LOGIC_VECTOR (7 downto 0);
			wrenOut		: out STD_LOGIC
		);
	end component;
	
	component InsnRAM_12bit is
		generic(
			M		:	INTEGER := 10
		);
		port(
			clk		: in  STD_LOGIC;
			reset	: in  STD_LOGIC := '0';
			-- --
			wrAddr	: in  STD_LOGIC_VECTOR (M downto 0) := (others => '0');
			wrData	: in  STD_LOGIC_VECTOR (7 downto 0);
			wren	: in  STD_LOGIC;
			-- --
			rdAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0);
			rdData	: out STD_LOGIC_VECTOR (11 downto 0)
		);
	end component;
	
	-- ENTITY --
	component Unix_Computer is
		port(
			clk			: in  STD_LOGIC
		);
	end component;
	
end unix_project;