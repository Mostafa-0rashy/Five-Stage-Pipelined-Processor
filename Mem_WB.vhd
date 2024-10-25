LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Mem_WB IS
PORT
(
	CLK,RST: in std_logic;
	mem_value_in: 	in std_logic_vector (31 downto 0);
	Control_register_in : in  Std_logic_vector (15 downto 0);
	Rdst_address_in : in std_logic_vector(2 downto 0);
	Swap_address_in: in std_logic_vector(2 downto 0);
        Swap_data_in : in std_logic_vector ( 31 downto 0);
	data_inport:in std_logic_vector ( 31 downto 0);
	exception: in std_logic;
------------Output-----------

	mem_value_out: 	out std_logic_vector (31 downto 0);
	Control_register_out : out  Std_logic_vector (10 downto 0);
	Rdst_address_out : out std_logic_vector(2 downto 0);
	Swap_address_out: out std_logic_vector(2 downto 0);
        Swap_data_out : out std_logic_vector ( 31 downto 0);
	WE1,WE2 : out std_logic;
	data_outport:out std_logic_vector ( 31 downto 0)
);
end entity;

Architecture Mem_WB_Arch of Mem_WB IS
BEGIN

Control_register_out(10 downto 8)<=Control_register_in(15 downto 13);
Control_register_out(7 downto 0)<=Control_register_in(7 downto 0);

	Process(CLK, RST)
    	Begin
	If rising_edge(CLK) Then
		IF(RST='0') THEN
			--Control_register_out<=Control_register_in;
			IF(Control_register_in(13)='1') THEN--"In" Instruction
				mem_value_out<=data_inport;
			Else
				mem_value_out<=mem_value_in;
			END IF;

			IF(Control_register_in(14)='1') THEN--"OUT" Instruction
				data_outport<=mem_value_in;
			END IF;
			--Control_register_out<=Control_register_in;
			Rdst_address_out<=Rdst_address_in;
			Swap_address_out<=Swap_address_in;
			Swap_data_out <= Swap_data_in;
			WE1 <= control_register_in(7);
			WE2 <= control_register_in(6);


		elsif (exception='1' or rst ='1') then
			Control_register_out<=(OTHERS=>'0');
			mem_value_out<=(OTHERS=>'0');
			Rdst_address_out<=(OTHERS=>'0');
			Swap_address_out<=(OTHERS=>'0');
			swap_data_out <= ( others => '0');
			WE1 <= '0';
			WE2 <= '0';
		end if ;
end if;
end process;
end Mem_WB_Arch;
