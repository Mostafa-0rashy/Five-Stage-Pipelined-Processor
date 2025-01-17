LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Alu is 
port(
A,B: in std_logic_vector (31 downto 0) ;
isnop : in std_logic; 
S: in std_logic_vector(2 downto 0);
In_Flags:in std_logic_vector(3 downto 0);
Out_Flags:out std_logic_vector(3 downto 0) ;
F : out std_logic_vector(31 DOWNTO 0)

);
end entity Alu;

architecture AluArch of Alu is 

component my_nadder IS
PORT   (     a, b : IN std_logic_vector(31 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(31 DOWNTO 0);
             cout : OUT std_logic);
end component my_nadder;

-----------------------------------------------------------------------------------
--------------------------------OneOP----------------------------------------------
signal NEG_A       : std_logic_vector(31 downto 0);
signal A_NOT         : std_logic_vector(31 downto 0);

-----------------------------------------------------------------------------------
--------------------------------TwoOP----------------------------------------------
signal AND_Output    : std_logic_vector(31 downto 0);
signal OR_Output     : std_logic_vector(31 downto 0);
signal ADD_Output    : std_logic_vector(31 downto 0);
signal SUB_Output    : std_logic_vector(31 downto 0);
signal B_NOT         : std_logic_vector(31 downto 0);
signal F_Temp        : std_logic_vector(31 downto 0);
signal XOR_Output    : std_logic_vector(31 downto 0);

----------------------------------------------------------------------------------
---------------------------------Flags--------------------------------------------
signal ADD_Carry : std_logic;
signal SUB_Carry : std_logic;
signal INC_Carry : std_logic;
signal DEC_Carry : std_logic;
signal dummySub    : std_logic;
signal dummyDec    : std_logic;
signal Flag_temp : std_logic_vector(3 downto 0) := "0000";
begin 
-----------------------------------------------------------------------------------
--------------------------------OneOP----------------------------------------------
NEG_A <= not A + "00000000000000000000000000000001"; --000

A_NOT <= not A; -- 001


-----------------------------------------------------------------------------------
--------------------------------TwoOP----------------------------------------------
ADDlabel : my_nadder port map(A,B,'0',ADD_output,ADD_Carry); --010

B_NOT <= not B;
SUBlabel: my_nadder port map(A,B_NOT,'1',SUB_output,dummySub); --011

AND_Output <= A and B;--101

OR_Output <= A or B; --110

XOR_Output <= A xor B; --100

----------------------------------------------------------------------------------
---------------------------------Flags--------------------------------------------

------------------subtraction flag
SUB_Carry <= '0' when S = "011" and to_integer(signed(B)) < to_integer(signed(A)) else '1';
------------------Decrease flag
DEC_Carry <= '1' when S = "011" and to_integer(signed(A)) <= 0 else '0';

------------------ flag(0) -> Zero flag
Flag_temp(0) <= '1' when F_Temp =  "00000000000000000000000000000000" and S /= "111" else 
'0' when F_Temp /=  "00000000000000000000000000000000" and S /= "111"-- AND isnop ='0'
 else Flag_temp(0) ;
------------------ flag(1) -> Ne
Flag_temp(1) <= F_Temp(31) when S /= "111" else Flag_temp(1);

------------------ flag(2) -> C
Flag_temp(2) <= ADD_Carry when  S="010"
else SUB_Carry when S = "011" 
else Flag_temp(2) ;

----------------- Flag (3) -> Overflow
Flag_temp(3) <= '1' when (S="010" or S="011") and A(31)= B(31) and A(31)/=F_temp(31)
else '0' when  (A(31)/= B(31) or (A(31)= B(31) and A(31)=F_temp(31))) and S/="111"
else Flag_temp(3);
    
--------------------------------------------------------------------------------------
------------------------------------F(Rdst)-------------------------------------------
F_Temp <= (NEG_A)   When S = "000"
    else (A_NOT)    when  S =  "001"
    else (ADD_Output)   when  S =  "010"
    else (SUB_Output) when  S =  "011"
    else (AND_Output)   when  S =  "101"
    else (OR_Output)  when  S =  "110"
    else (XOR_Output)  when  S =  "100"
    else(A);
	
    F <= F_Temp;
 Out_Flags <= flag_temp;
end architecture AluArch;

