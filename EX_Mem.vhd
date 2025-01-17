LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.numeric_std.all;
Entity EX_Mem is
port
(
	CLK,RST :in std_logic;

	Control_register_in :in Std_logic_vector (16 downto 0);
	IN_Flags:IN std_logic_vector(3 downto 0) ;
	F_IN : IN std_logic_vector(31 DOWNTO 0);
	Rdst_address_IN : IN std_logic_vector(2 downto 0);
	Swap_address_in : in std_logic_vector(2 downto 0);
	mem_value_in : IN std_logic_vector (31 downto 0);
	B_in : in std_logic_vector (31 downto 0);
	exception_out_ex:in std_logic;
	int_sig_in:	in std_logic;
	PC_push_in:	in std_logic_vector (31 downto 0);

	Control_register_out :out  Std_logic_vector (15 downto 0);
	Out_Flags:out std_logic_vector(3 downto 0) ;
	F_Out : out std_logic_vector(31 DOWNTO 0);
	Rdst_address_Out : out std_logic_vector(2 downto 0);
	Swap_address_Out : out std_logic_vector(2 downto 0);
	mem_value_out : out std_logic_vector (31 downto 0);
	B_out : out std_logic_vector (31 downto 0);
	int_sig_out:	out std_logic;
	PC_push_out:	out std_logic_vector (31 downto 0)
	
);
end entity;

Architecture EX_Mem_Arch of EX_Mem is 
BEGIN


    Process(CLK, RST)
    Begin
	If rising_edge(CLK) Then

        	If RST = '1' Or exception_out_ex='1' Then
			Control_register_out <= (Others =>'0');
			Out_Flags <= (Others =>'0');
			F_Out <= (Others =>'0');
			Rdst_address_Out <= (Others =>'0');
			Swap_address_Out <= (Others =>'0');
			B_out <= ( others => '0');
			mem_value_out <=( others => '0');
        	Else
           		--Control_register_out <= Control_register_in;
			Control_Register_out(15 downto 6)<=Control_register_in(16 downto 7);
			Control_Register_out(5 downto 0)<=Control_register_in(5 Downto 0);
			Out_Flags <= IN_Flags;
			F_Out <= F_IN;
			Rdst_address_Out <= Rdst_address_IN;
			Swap_address_Out <= Swap_address_in;
			mem_value_out <= mem_value_in;
			B_out <= B_in;
			int_sig_out<=int_sig_in;
			PC_push_out<=PC_push_in;
            	End If;
		
       End If;
    End Process;
END EX_Mem_Arch;
