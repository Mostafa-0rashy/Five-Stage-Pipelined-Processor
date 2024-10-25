LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.numeric_std.all;


ENTITY fetchStage IS
PORT( 
 clk, reset, enable,pcSel_jump,pcSel_jz,Rsel,Z_flag:             IN  std_logic; 
 jmp_Cond:					      		 IN std_logic;
 Call_Cond:							 IN std_logic;
 jz_cond:							 in std_logic;
 jumpPC:                                             		 IN  std_logic_vector(31 DOWNTO 0);
 JZPC:								 IN std_logic_vector(31 DOWNTO 0);
 pcRet:								 IN  std_logic_vector(31 DOWNTO 0);
 int_sig:					      IN std_logic;
 instruction:  					      		 OUT std_logic_vector(15 DOWNTO 0); 
 pcOut:                                                		 OUT std_logic_vector(31 DOWNTO 0);
 needs_imm:					      IN std_logic;
 out_imm:					      OUT std_logic_vector(15 DOWNTO 0);
 PC_push:					      OUT std_logic_vector(31 DOWNTO 0);
 int_sig_out:					      OUT std_logic
);
END fetchStage;

ARCHITECTURE fetchStageDesign OF fetchStage IS


Component instructionMem IS
    PORT (
        clk:                IN std_logic;
        rst :               IN std_logic;
        readAddress :       IN std_logic_vector(31 DOWNTO 0);
        instruction :       OUT std_logic_vector(15 DOWNTO 0);
	int_address:        OUT std_logic_vector(31 DOWNTO 0);
	start_address:		OUT std_logic_vector(15 DOWNTO 0)
    );
END Component;

Component PC IS
    PORT (
        clk, reset, enable : IN  std_logic;
        pcSel_jump : IN std_logic;
	pcSel_jz : IN std_logic;
	Rsel:	IN std_logic;
	z_flag : in std_logic;
	jmp_Cond :IN std_logic;
	Call_Cond:IN std_logic;
 	jz_cond: in std_logic;
        pcData : IN std_logic_vector(31 DOWNTO 0);
	int_sig: In std_logic;
	int_address: In std_logic_VECTOR(31 downto 0);
	pcRet : IN std_logic_vector(31 DOWNTO 0);
        pc_Address : OUT std_logic_vector(31 DOWNTO 0);
	PC_push:	OUT std_logic_vector(31 DOWNTO 0);
	start_address:		IN std_logic_vector(15 DOWNTO 0)
    );
END Component;

signal pcOutput:                            std_logic_vector(31 DOWNTO 0);
signal outInstruction:                      std_logic_vector(15 DOWNTO 0);
signal isImmediate:                         std_logic;
signal pcData : std_logic_vector(31 DOWNTO 0);
Signal INT_ADDRESS:			    std_logic_vector(31 DOWNTO 0);
Signal Start_ADDRESS:			    std_logic_vector(15 DOWNTO 0);

BEGIN

    pcc:  PC port map(clk, reset, enable, pcSel_jump,pcSel_jz,Rsel,Z_flag,jmp_Cond,Call_Cond,jz_cond,pcData,int_sig,INT_ADDRESS,pcRet ,pcOutput,PC_push,Start_ADDRESS);
    instruction_memory:   instructionMem port map(clk, reset, pcOutput, outInstruction,INT_ADDRESS,Start_ADDRESS);
    
    isImmediate <= outInstruction(15);
    pcOut <= pcOutput;

   pcData <= jumpPC when pcSel_jump = '1' and (jmp_Cond ='1' or Call_Cond ='1')  
     else  JZPC when pcSel_jz= '1' and jz_cond ='0' and z_flag='1'
     else  pcRet when rsel ='1';

--    instruction <= x"0000" when pcSel_jump = '1' and (jmp_Cond ='1' or Call_Cond ='1')
--    else x"0000" when pcSel_jz= '1' and jz_cond ='0' and z_flag='1'
--    else outInstruction;
 out_imm <= outInstruction when needs_imm = '1' else (others => '0');
instruction<=outInstruction;

END fetchStageDesign;

