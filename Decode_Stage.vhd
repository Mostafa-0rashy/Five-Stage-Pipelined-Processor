library ieee;
use ieee.std_logic_1164.all;

entity Decode_stage is
	port( 




	       clk : in std_logic;
	       rst_Hardware : in std_logic;


              --DECODING
               Instruction : in std_logic_vector (15 downto 0);
               Control_register_out :out Std_logic_vector (20 downto 0);
               Rdst_address : out std_logic_vector(2 downto 0);
               Swap_address : out std_logic_vector(2 downto 0);
               Value1 : out std_logic_vector (31 downto 0);
               Value2 : out std_logic_vector (31 downto 0); 
               Alu_Selector : out std_logic_vector (2 downto 0);
               Zero_flag : in std_logic :='0';  ---hteegy mn flag register  
               Rst_out : out std_logic := '0';
	       Memory_value : out std_logic_vector (31 downto 0);
               needs_imm : out std_logic;
	       in_imm:	in  std_logic_vector (15 downto 0);
	       iSnop : out std_logic;
	       Conditional : out std_logic;
	       PCout : in std_logic_vector (31 downto 0);
		PCvalTOFetch : out std_logic_vector(31 downto 0);
            --WriteBack 
             we1,we2  : in std_logic;
            writedata1,writedata2 : in std_logic_vector(31 downto 0);
            writeaddress1,writeaddress2 : in std_logic_vector (2 downto 0);
	    read_address1,Read_address2 : out std_logic_vector(2 downto 0)


);
end entity;



architecture Decode_stage_Arch of Decode_Stage is 

component Decoding_unit is
	port(
		--External input 
	       rst_in : std_logic  ;
	       rst_out : out std_logic ;
               Zero_flag : std_logic ; 
               Fetch_instruction : in std_logic_vector(15 downto 0);
	     
              --control Signals 
		Isnop : out std_logic;
		IScall : out std_logic;

   Control_Signals_register :out std_logic_vector (20 downto 0):= "000000000000000000000";


--20 INT 
--19 RST
--18 OUTe
--17 INe
--16 IMM
--15 MR 
--14 MW
--13 MP
--12 MF
--11 RW1
--10 RW2
-- 9 AlUop
-- 8 PCop
-- 7 Rsel
-- 6 FWmem
-- 5 FWalu
-- 4 INC/DECsel
-- 3 PUSH 
-- 2 POP 
-- 1 RE1
-- 0 RE2





             --Output
             Rdst_address : out std_logic_vector(2 downto 0);
             rsrc1_address : out std_logic_vector (2 downto 0);
             rsrc2_address : out std_logic_vector (2 downto 0);
             Alu_selector  : out std_logic_vector (2 downto 0)


);
end component; 




component registers is 
port ( 
		we1,we2,re1,re2,clk,rst  : IN std_logic;
		Write_address1 : IN  std_logic_vector(2 DOWNTO 0);
                Write_address2 : IN  std_logic_vector(2 DOWNTO 0);
		write_port1 : IN  std_logic_vector(31 DOWNTO 0);
		write_port2 : IN  std_logic_vector(31 DOWNTO 0);
		Read_address1 : IN  std_logic_vector(2 DOWNTO 0); 
                Read_address2 : IN  std_logic_vector(2 DOWNTO 0);
		Read_port1 : OUT std_logic_vector(31 DOWNTO 0);
		Read_port2 : OUT std_logic_vector(31 DOWNTO 0)

);
end component;
component sign_extender is 
port ( 
		rst: in std_logic;
                input : in std_logic_vector(15 downto 0);
                output : out std_logic_vector(31 downto 0)

);
end component sign_extender;


signal Control_reg_internal : std_logic_vector (20 downto 0);
signal RegValue1_internal,RegValue2_internal : std_logic_vector (31 downto 0);
signal RegAddress1,RegAddress2,rdst_internal : std_logic_vector (2 downto 0);
signal Sign_Extender_output : std_logic_vector ( 31 downto 0);
signal Alu_selector_internal : std_logic_vector (2 downto 0);
signal rst_passed : std_logic;
signal test,iscall:std_logic;
signal in_imm_32bit:std_logic_vector (31 downto 0);

begin



Decodingunit : decoding_unit port map (rst_hardware,rst_passed,zero_flag,Instruction,iSnop,iscall,Control_reg_internal,rdst_internal,RegAddress1,RegAddress2,Alu_Selector_internal); 
regs : registers port map(we1,we2,Control_reg_internal(1),Control_reg_internal(0),clk,rst_passed,writeaddress1,writeaddress2,writedata1,writedata2,RegAddress1,RegAddress2,RegValue1_internal,RegValue2_internal);
signextender : Sign_extender Port map(rst_passed,Instruction,sign_extender_output);

process (in_imm)
begin
    if in_imm(15) = '0' then
        in_imm_32bit <= X"0000" & in_imm;
    else
        in_imm_32bit <= X"FFFF" & in_imm;
    end if;
end process;


--
--next_is_imm <= next_is_imm2 xor '1' when control_reg_internal(16) ='1' 
--else '0';
--
--
--
--next_is_imm2 <= next_is_imm;

rst_out <= rst_passed ;


swap_address <=rdst_internal;


Control_register_out <=Control_reg_internal;


Read_address1<=regAddress1;
Read_address2<=regAddress2;



value1<=in_imm_32bit when Control_reg_internal(16)='1' and instruction(15 downto 10)="110011" -- for LDD
else in_imm_32bit when Control_reg_internal(16)='1' and instruction(15 downto 10)="110100" --for STD
else in_imm_32bit when Control_reg_internal(16)='1' and instruction(15 downto 10) ="110010" --for LDM
else X"00000000" when rst_passed = '1'  or Control_reg_internal(1) ='0' or instruction(15 downto 10) ="110010" -- rst or LDM 
else RegValue2_internal when instruction(15 downto 10)="001001" 
else PCout when iscall='1'
else RegValue1_internal;


value2 <=X"00000001" when Control_reg_internal(4) = '1' or iscall='1' -- inc/dec instruction
else X"00000000" when Control_reg_internal(16)='1' and instruction(15 downto 10) ="110010" --for LDM
else in_imm_32bit when Control_reg_internal(16)='1' and instruction(15 downto 10) ="101010" -- for addi
else in_imm_32bit when Control_reg_internal(16)='1' and instruction(15 downto 10) ="101011" -- for subi
else RegValue1_internal when instruction(15 downto 10)="001001" 
else X"00000000" when rst_passed = '1' 
else RegValue2_internal;



rdst_address <= "000" when rst_passed ='1'
else RegAddress1 when instruction(15 downto 10)="110011" -- for LDD
else RegAddress1 when instruction(15 downto 10)="001001" -- for Swap
else  Rdst_internal;


alu_Selector <="000" when rst_passed ='1' 
else "010" when iscall ='1'
else Alu_selector_internal;



memory_value <= (others => '0') when rst_passed ='1'
else RegValue1_internal when Control_reg_internal(14) = '1'
else (others => '0');


needs_imm<=Control_reg_internal(16);
Conditional <= instruction(10);
PCvalTOFetch <=RegValue1_internal;

end Decode_stage_Arch;
