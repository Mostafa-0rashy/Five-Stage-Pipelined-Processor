library ieee;
use ieee.std_logic_1164.all;

entity Decoding_unit is
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
end entity; 


architecture Decoding_unit_Arch of Decoding_unit is
signal OpCode : std_logic_vector (5 downto 0);
signal Rsrc1_address_internal,Rsrc2_address_internal,Rdst_address_internal,alu_selector_internal : std_logic_vector (2 downto 0); 
signal Control_Signals_register_internal : std_logic_vector (20 downto 0):= (others => '0');
signal rst_continue : std_logic;

begin 


opCode <= Fetch_instruction( 15 downto 10);
 
Control_Signals_register_internal <= "000000000000000000000" when opCode = "000000" else --done
            "000000000101000000010" when opCode = "000001" or opCode = "000011" else ---done
            "000000000101000010010" when opCode = "000100" or opCode = "000101" else --done 
            "001000000000000000010" when opCode = "000110" else
            "000100000100000000000" when opCode = "000111" else
            "000000000100000000010" when opCode = "001000" else
            "000000000110000000011" when opCode = "001001" else
            "000000000101000000011" when opCode = "001010" else 
	    "000010000101000000010" when opCode = "101010" else --done
            "000000000101000000011" when opCode = "001011" else --done
            "000010000101000000010" when opCode = "101011" else --done
            "000000000101000000011" when opCode = "001100" else
            "000000000101000000011" when opCode = "001101" else --done
            "000000000101000000011" when opCode = "001110" else --DONE
            "000000000001000000011" when opCode = "001111" else
            "000000000000000001010" when opCode = "010000" else
            "000000000100000000100" when opCode = "010001" else
            "000010000100000000000" when opCode = "110010" else
            "000011000101000000001" when opCode = "110011" else
            "000010100001000000011" when opCode = "110100" else
            "000000010000000000010" when opCode = "010101" else
            "000000001000000000010" when opCode = "010110" else
            "000000000000100000010" when opCode = "011000" else
            "000000000000100000010" when opCode = "011001" else
 	    "000000000001100001010" when opCode = "011010" else
            "000000000000010000100" when opCode = "011011" else 
	    "000000000000010000100" when opCode = "011100" else
            "010000000000100000000" when opCode = "111111" else
            "100000000000100000000" when opCode = "111000"; 




--Control_Signals_register_internal(16) <= '0' when imm_in ='1'
--else Control_Signals_register_internal(16);



--ALU SELECTOR 
Alu_selector_internal <= "000" when opCode = "000001" else
       "001" when opCode = "000011" else
       "010" when opCode = "000100" or opCode = "001010" or opCode = "101010" or opCode = "110011" or opCode = "110010"  OR opCode = "110100" else
       "011" when opCode = "000101" or opCode = "001011" or opCode = "101011" or opCode = "001111" or opCode = "001111" else
       "101" when opCode = "001100" else
       "110" when opCode = "001101" else
       "100" when opCode = "001110"
	else "111";

Rsrc2_address_internal <=Fetch_instruction(6 downto 4) when opCode = "001001"
else Fetch_instruction(3 downto 1);


Rdst_address_internal <= Fetch_instruction(6 downto 4)  when opCode = "001001" 
else Fetch_instruction(9 downto 7);

Rsrc1_address_internal <= Fetch_instruction(9 downto 7) when opCode ="000001" or OpCode ="000011" or Opcode ="000100" or 
Opcode ="000101" or opCode ="000110" or opCode ="000110" or opCode ="010000" or opCode ="010001" or opCode ="110010" or opCode = "010110" or
opCode = "011000" or opCode ="011001" or opCode ="011010" or 
OpCode ="111000"or opcode="000110" or opCode = "001001" or opCode = "010101"
else  Fetch_instruction(6 downto 4)  ;



rst_out <= Rst_IN or Control_signals_register_internal(19);



rst_continue <= Rst_IN or Control_signals_register_internal(19);


Rdst_address <= (others => '0') when rst_continue ='1'
else Rdst_address_internal ;



Control_signals_register <= (others => '0') when rst_continue ='1'
else Control_signals_register_internal ;


Rsrc1_address <= (others => '0') when rst_continue ='1'
else Rsrc1_address_internal ;


Rsrc2_address <= (others => '0') when rst_continue ='1'
else Rsrc2_address_internal ;


Alu_selector <= (others => '0') when rst_continue ='1'
else Alu_selector_internal ;

ISnop <= '1' when opcode="000000"
else '0';

IScall <= '1' when opcode ="011010"
else '0';




end Decoding_unit_Arch;
