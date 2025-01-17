LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

Entity Exec_Stage IS 
PORT
(
clk, reset, enable,isnop:  IN  std_logic; 
A,B: in std_logic_vector (31 downto 0) ; 
In_Flags:in std_logic_vector(3 downto 0);
Control_register :in Std_logic_vector (16 downto 0);
Alu_Selector : in std_logic_vector (2 downto 0);
forwarded_data:in std_logic_vector(31 downto 0);
forward_operand:in std_logic;
hazard: in std_logic;
Out_Flags:out std_logic_vector(3 downto 0) ;
F : out std_logic_vector(31 DOWNTO 0);
exception:out std_logic

);
END Exec_Stage;

Architecture Exec_Stage_arch OF Exec_Stage IS
Component Alu is 
port(
A,B: in std_logic_vector (31 downto 0) ;
isnop : in std_logic; 
S: in std_logic_vector(2 downto 0);
In_Flags:in std_logic_vector(3 downto 0);
Out_Flags:out std_logic_vector(3 downto 0) ;
F : out std_logic_vector(31 DOWNTO 0)

);
end Component;

Signal Alu_enable_signal: std_logic;
--Control Register In
---Control Register IN
--16 INT 
--15 OUTe  in WB
--14 INe   IN WB
--13 IMM
--12 MR 
--11 MW
--10 MP
--9 MF
--8 RW1
--7 RW2
-- 6 AlUop   xxxxxx
-- 5 PCop
-- 4 Rsel
-- 3 FWmem
-- 2 FWalu
-- 1 PUSH 
-- 0 POP 


--Control Register OUT

--15 INT 
--14 OUTe  in WB
--13 INe   IN WB
--12 IMM
--11 MR 
--10 MW
--9 MP
--8 MF
--7 RW1
--6 RW2
-- 5 PCop
-- 4 Rsel
-- 3 FWmem
-- 2 FWalu
-- 1 PUSH 
-- 0 POP



Signal F_temp,A_sig,B_sig :  std_logic_vector(31 DOWNTO 0);
Signal output_flags: std_logic_vector(3 downto 0);
Begin

A_sig<=forwarded_data when hazard='1' and forward_operand='0' 
else A;
B_sig<= forwarded_data when hazard='1' and forward_operand='1'
else B;


The_Alu:Alu Port Map(A_sig,B_sig,isnop,Alu_Selector,In_Flags,output_flags,F_temp);
out_flags<=output_flags;

F <= F_temp when control_register(6) ='1' 
ELSE A;
Process(clk)
begin
If(output_flags(3)='1') then
	exception<='1';
else 
	exception<='0';
end if;
end process;
end Exec_Stage_arch;
