library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library work;
use work.srisc.all;
----------------------------------------------------------------------------
package unix_project is

	-- SUBMODULES --
	component MemoryController is
		generic(
			M			:	INTEGER := 8
		);
		port(
			clk			: in  STD_LOGIC;
			input		: in  STD_LOGIC_VECTOR (7 downto 0);
			wrFlag		: in  STD_LOGIC;
			cpu_wren	: in  STD_LOGIC;
			cpu_rden	: in  STD_LOGIC;
			-- --
			addrOut		: out STD_LOGIC_VECTOR (M-1 downto 0);
			dataOut		: out STD_LOGIC_VECTOR (7 downto 0);
			wrenOut		: out STD_LOGIC := '0';
			clrFlag		: out STD_LOGIC := '0'
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
	
	-- Top Modules
	component IO_Module is
		port(
			clk				: in  STD_LOGIC;
			cpu_din			: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_addr		: in  STD_LOGIC_VECTOR (3 downto 0);
			cpu_wren		: in  STD_LOGIC;
			cpu_rden		: in  STD_LOGIC;
			cpu_dout		: out STD_LOGIC_VECTOR (7 downto 0);
			-- --
			input_sets		: in  STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
			output_resets	: in  STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
			input_flags		: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');			
			output_flags	: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
			inputs			: in  IO_ARRAY (0 to 15) := (others => (others => '0'));
			outputs			: out IO_ARRAY (0 to 15) := (others => (others => '0'))
		);
	end component;
	
	component ProgramMemory is
		port(
			clk			: in  STD_LOGIC;
			reset		: in  STD_LOGIC;
			cpu_din		: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_wren	: in  STD_LOGIC;
			wrFlag		: in  STD_LOGIC;
			clrFlag		: out STD_LOGIC;
			prog_addr	: in  STD_LOGIC_VECTOR (9 downto 0);
			instruction	: out STD_LOGIC_VECTOR (11 downto 0)
		);
	end component;
	
	component GP_RAM is
		port(
			clk			: in  STD_LOGIC;
			reset		: in  STD_LOGIC;
			cpu_din		: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_wren	: in  STD_LOGIC;
			cpu_rden	: in  STD_LOGIC;
			cpu_dout	: out STD_LOGIC_VECTOR (7 downto 0);
			wrFlag		: in  STD_LOGIC;
			clrFlag		: out STD_LOGIC
		);
	end component;
	
	-- ENTITY --
	component Unix_Computer is
		port(
			clk			: in  STD_LOGIC;
			-- --
			switches	: in  STD_LOGIC_VECTOR (7 downto 0);
			rx			: in  STD_LOGIC;
			-- --
			leds		: out STD_LOGIC_VECTOR (7 downto 0);
			tx			: out STD_LOGIC
		);
	end component;
	
end unix_project;