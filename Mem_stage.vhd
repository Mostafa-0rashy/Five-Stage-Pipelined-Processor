LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY memoryStage IS
PORT (
        clk:                  IN std_logic;
        rst :                 IN std_logic;
	Control_register_IN : IN  Std_logic_vector (15 downto 0);
	alu_value :                IN std_logic_vector(31 DOWNTO 0);
	memaddress : IN std_logic_vector (31 downto 0);
	PC_push_in:		 in std_logic_vector (31 DOWNTO 0);
	int_in:		 in std_logic; 

	-------OUTPUT------
	mem_value_out: 	OUT std_logic_vector (31 downto 0);
	exception:	OUT std_logic;
	Rdst_address_in_memory: IN std_logic_vector (2 downto 0);
	Swap_address_in_memory: IN std_logic_vector (2 downto 0);
	Rdst_address_out_memory:out std_logic_vector (2 downto 0);
	Swap_address_out_memory:out std_logic_vector (2 downto 0);
	Control_register_out : out  Std_logic_vector (15 downto 0);
	B_in:		 in std_logic_vector (31 DOWNTO 0);
	B_out:		 out std_logic_vector (31 DOWNTO 0)
);
END ENTITY memoryStage;

ARCHITECTURE memoryStage_arch OF memoryStage  IS

--Control Register in

--15 INT 
--14 OUTe  in WB
--13 INe   IN WB
--12 IMM    XXXXX
--11 MR     XXXXX
--10 MW     XXXXX
--9 MP      XXXXX
--8 MF      XXXXX
--7 RW1
--6 RW2
-- 5 PCop
-- 4 Rsel
-- 3 FWmem
-- 2 FWalu
-- 1 PUSH 
-- 0 POP  

--Control Register out

--10 INT 
--9 OUTe  in WB
--8 INe   IN WB
--7 RW1
--6 RW2
-- 5 PCop
-- 4 Rsel
-- 3 FWmem
-- 2 FWalu
-- 1 PUSH 
-- 0 POP  



signal spOut    :std_logic_vector(11 DOWNTO 0);
Signal PUSH_sig :std_logic;--0 not pushing//1 pushing
Signal POP_Sig  :std_logic;--0 not pushing//1 pushing
signal memdatatemp : std_logic_vector ( 31 downto 0);
signal Memory_address,Memory_data : std_logic_vector ( 31 downto 0);
signal ex_temp : std_logic;

Component SP IS
	PORT ( 
clk,reset : IN  std_logic;
	  Push: IN std_logic;
	  Pop: IN std_logic;
	  sp  : OUT std_logic_vector(11 DOWNTO 0)
        );
END Component;
Component dataMem is
    port(
        clk:                  IN std_logic;
        rst,exception:                  IN std_logic;
	sp  : 		      IN std_logic_vector (11 DOWNTO 0);
	Control_register_IN : IN std_logic_vector (15 downto 0);
	memaddress :          IN std_logic_vector (31 DOWNTO 0);--FROM ALU
	mem_value_in :        IN std_logic_vector (31 downto 0);
	mem_value_out:	      OUT std_logic_vector (31 downto 0);
	int_sig:	      IN std_logic;
	PUSH_PC:	      IN std_logic_vector (31 downto 0)
    );
end Component;
BEGIN
PUSH_sig<= Control_register_IN(1);
POP_sig <= Control_register_IN(0);

--Control_register_out(10 downto 8)<=Control_register_in(15 downto 13);
--Control_register_out(7 downto 0)<=Control_register_in(7 downto 0);

The_Sp  :  SP PORT MAP(clk,rst,Push_sig,POP_Sig,spOut);

Memory_address <= alu_value when Control_register_IN(10)='1' or Control_register_IN(11)='1' or Control_register_IN(9)='1' or Control_register_IN(8)='1'
else memaddress;

Memory_data <= memaddress when Control_register_IN(10)='1' or Control_register_IN(11)='1' or Control_register_IN(9)='1' or Control_register_IN(8)='1'
else alu_value;



The_Data_Mem:dataMem PORT MAP(clk,rst,ex_temp,spOut,Control_register_IN,Memory_address,Memory_data,memdatatemp,int_in,PC_push_in);



ex_temp <= '1' when ((unsigned(Memory_address)>4095 or unsigned(Memory_address)<0) and (Control_register_IN(10)='1' or Control_register_IN(11)='1')) or (POP_Sig='1' and spOut = X"FFF")
else '0';
exception <= ex_temp;
Process(clk)
Begin
if rising_edge(clk) then 
b_out <= B_in;
	Rdst_address_out_memory <= Rdst_address_in_memory;
	Swap_address_out_memory <= Swap_address_in_memory;
	Control_register_out <= Control_register_IN;
	if Control_register_IN(0)='1' or Control_register_IN(11)='1' then
		mem_value_out <= memdatatemp;
	else
		mem_value_out <=  alu_value;
	end if;
end if;

end process;

END memoryStage_arch;
