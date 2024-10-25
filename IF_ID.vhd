LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.numeric_std.all;

Entity IF_ID IS
Port
(
	CLK,RST: 	IN std_logic;
	fetched_instruction: IN std_logic_vector(15 downto 0);
	needs_imm:		IN std_logic;
	PC_push_in:		IN std_logic_vector(31 DOWNTO 0);
	int_sig_in:		IN std_logic;
	stall:			IN std_logic;
	instruction_out: 	OUT std_logic_vector(15 downto 0);
	PC_push_out:		OUT std_logic_vector(31 DOWNTO 0);
	int_sig_out:		OUT std_logic	

);
END IF_ID;
ARCHITECTURE IF_ID_arch of IF_ID IS
BEGIN
    Process(CLK, RST)
    Begin
        If rising_edge(CLK) Then
            If RST = '1' OR needs_imm='1' Then
                instruction_out <= (OTHERS => '0');
            Else
                instruction_out <= fetched_instruction;
		PC_push_out<=PC_push_in;
		int_sig_out<=int_sig_in;
            End If;
        End If;
    End Process;
END IF_ID_arch;
