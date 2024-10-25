LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.numeric_std.all;

Entity ID_EX IS
Port
(
	CLK,RST: 	IN std_logic;
	Conditional : 	IN std_logic;
	jz_cond:       out std_logic;
	Control_register :in Std_logic_vector (20 downto 0);
	Rdst_address : in std_logic_vector(2 downto 0);
	Swap_address : in std_logic_vector(2 downto 0);
        Value1 : in std_logic_vector (31 downto 0);--A operand
        Value2 : in std_logic_vector (31 downto 0);--B operand
        Alu_Selector : in std_logic_vector (2 downto 0);
	---Rst_in : IN std_logic;--to reset EX stage
	mem_value_in : IN std_logic_vector (31 downto 0);
        is_imm_in : in std_logic;
	PC_push_in:		IN std_logic_vector(31 DOWNTO 0);
	int_sig_in:		IN std_logic;
	stall:			IN std_logic;
-------------------Output Ports-------------------------
	Alu_selector_out: out std_logic_vector (2 downto 0);
	--Rst_out: out std_logic;--to reset EX stage
	A:  out std_logic_vector (31 downto 0);--A operand value1
	B: out std_logic_vector (31 downto 0);--B operand value 2
	Control_register_out: out std_logic_vector (16 downto 0);
	Rdst_address_out : out std_logic_vector(2 downto 0);
	Swap_address_out: out std_logic_vector(2 downto 0);
	mem_value_out : out std_logic_vector (31 downto 0);
        Is_imm_out : out std_logic;  ---elvalue B is Imm dlw2ty 
	PC_push_out:		OUT std_logic_vector(31 DOWNTO 0);
	int_sig_out:		OUT std_logic
	
);
END ID_EX;
ARCHITECTURE ID_EX_arch of ID_EX IS
BEGIN
    Process(CLK, RST)
    Begin
        If rising_edge(CLK) Then
		
        	If RST = '1' Then
		Control_register_out<=(others=>'0');
		Rdst_address_out<=(others=>'0');
		Swap_address_out<=(others=>'0');
        	A<=(others=>'0');--A operand
        	B<=(others=>'0') ; --B operand
        	Alu_selector_out <=(others=>'0');
		mem_value_out <= (others=>'0');
		jz_cond <='0';
	--	Rst_out <='0';
        	Else
		Control_register_out (16)  <= Control_register(20);
		Control_register_out (15 downto 2)  <= Control_register(18 downto 5);
		Control_register_out (1 downto 0 )  <=Control_register(3 downto 2) ;
		Is_imm_out <= Is_imm_in;
		Rdst_address_out<=Rdst_address;
		Swap_address_out<=Swap_address;
        	A<=Value1;--A operand
        	B<=Value2 ; --B operand
        	Alu_selector_out <= Alu_Selector;
		mem_value_out <= mem_value_in;
		Jz_cond<=Conditional;
		PC_push_out<=PC_push_in;
		int_sig_out<=int_sig_in;
--		Rst_out <= Rst_in;
            	End If;
		
        End If;
    End Process;
END ID_EX_arch;
