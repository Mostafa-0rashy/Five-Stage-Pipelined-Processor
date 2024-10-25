LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity Processor is 
port (

	in_port : in std_logic_vector (31 downto 0);
	out_port : out std_logic_vector ( 31 downto 0);
	Hardware_rst : in std_logic := '0';
	exception_out_port: out std_logic:='0';
	INT_In: IN std_logic


);
end entity processor ;

architecture Processor_arch of Processor is 

Component fetchStage IS
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
END component ;

component IF_ID IS
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
END component IF_ID;


component Decode_stage is
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
end component;


Component ID_EX IS
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
END component ID_EX;
component Exec_Stage IS 
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
END component Exec_Stage;


component EX_Mem is
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
end component;

Component memoryStage IS
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
END component memoryStage;





COMPONENT Mem_WB IS
PORT (
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
end COMPONENT;
Component Hazard_Detection IS 
PORT
(
clk: std_logic;
Rdst_address_in_exec: in std_logic_vector (2 downto 0);
Rsrc1_address_in_decode: in std_logic_vector (2 downto 0);
Rsrc2_address_in_decode: in std_logic_vector (2 downto 0);
Rdst_in_memory:  in std_logic_vector (2 downto 0);--for load data hazard
data_forward_alu_alu:in std_logic_vector (31 downto 0);

data_hazard:	out std_logic;
stall:		out std_logic;
forward_operand: out std_logic;
forward_data:	 out std_logic_vector (31 downto 0)
);
END Component;



constant CLK_PERIOD : time := 10 ns; -- Clock period





signal Write_enable1,Write_enable2 : std_logic;
signal Write_data1,Write_data2 : std_logic_vector (31 downto 0);
signal write_address1,write_address2: std_logic_vector ( 2 downto 0);



--- FETCH STAGE 
signal Passed_rst,clk,PC_enable : std_logic :='0';
signal PcData,PcAddress,PcOut : std_logic_vector (31 downto 0):= ( others => '0');
signal needs_imm:		std_logic; 
signal out_imm:              std_logic_vector(15 DOWNTO 0);
signal isnop : std_logic;
signal Conditional,jz_cond: std_logic;
signal Pc_push:			std_logic_vector (31 downto 0);
signal int_sig_out_fetch:		std_logic; 
--- IF/ID regsiter 
signal instruction_out_fetch,instruction_in_Decode : std_logic_vector(15 DOWNTO 0):= ( others => '0');
signal Control_register_out_decode : std_logic_vector (20 downto 0):= ( others => '0');
signal control_register_in_execute: std_logic_vector (16 downto 0):= ( others => '0');
signal int_sig_in_dec:			std_logic;
signal Pc_Push_in_dec:			std_logic_vector (31 downto 0);
--- DECODE STAGE -- ID/EX 
signal Rdst_address_out_decode,Swap_Address_out_decode,Alu_Selector_out_decode: std_logic_vector ( 2 downto 0):= ( others => '0');
signal Alu_Selector_in_Execute : std_logic_vector ( 2 downto 0):= ( others => '0');
signal A_out_Decode,B_out_Decode,A_in_execute,B_in_execute, PCvalTOFetch: std_logic_vector ( 31 downto 0):= ( others => '0');
signal imm_rayha_eldecode,is_imm_out_decode,is_imm_in_execute : std_logic :='0';
signal int_sig_in_ex : 		std_logic;
signal PC_push_in_ex:		std_logic_vector (31 downto 0);

--- EXECUTE STAGE 
signal Flag_register_out_execute,Flag_register_in_execute : std_logic_vector (3 downto 0);
signal Result_out_execute: std_logic_vector ( 31 downto 0);
signal exception_out_ex: std_logic;
--- EX/MEM
signal Mem_data_out_decode,Mem_data_in_EXMEM,Mem_data_in_Memory,result_in_Memory,B_out_EXMEM: std_logic_vector ( 31 downto 0):= ( others => '0');
signal Rdst_address_in_EXMEM,Swap_Address_in_EXMEM : std_logic_vector ( 2 downto 0) := ( others => '0'); 
signal Control_register_in_memory ,Control_register_out_memory: std_logic_vector (15 downto 0);
signal Rdst_address_out_MEMEX, Swap_Address_out_MEMEX : std_logic_vector (2 downto 0);



----Memory stage 
signal mem_Value_in_memory : std_logic_vector ( 31 downto 0);
signal Rdst_address_in_memory,Swap_address_in_memory,Rdst_address_out_memory,Swap_address_out_memory,Read_address1,Read_address2: std_logiC_vector (2 downto 0);
signal mem_Value_out_memory : std_logic_vector (31 downto 0);
signal Control_register_out_MemWB : std_logic_vector (10 downto 0);
signal exception_out_mem : std_logic;
signal int_sig_out_ex_mem:	std_logic;
signal PC_push_out_ex_mem,B_out_memory:		std_logic_vector (31 downto 0);
--
--
---- MEM/WB 
signal Swap_data_out ,Memory_value_out_MEMWB: std_logic_vector ( 31 downto 0);
--
--
signal hazard:		std_logic;
signal stall:		std_logic;
signal forward_operand:	std_logic;
signal forward_data: 	std_logic_vector(31 downto 0);









begin


clk_process : process
    begin
	wait for 10 ps;
        for i in 0 to 1000 loop  -- Simulate 1000 clock cycles
            clk <= '1';
            wait for CLK_PERIOD / 2;
            clk <= '0';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;  -- Wait indefinitely after simulation is done
    end process clk_process;



Fetch_stage : FetchStage port map (clk,Passed_rst,'1',Control_register_out_Decode(8),control_register_in_execute(5),Control_register_out_memory(4)
,flag_register_out_execute(0),instruction_in_Decode(10),instruction_in_Decode(11),jz_cond,PCvalTOFetch,A_in_execute,mem_Value_out_memory,INT_In,instruction_out_fetch,PcOut,needs_imm,out_imm,Pc_push,int_sig_out_fetch);


Fecth_decode_reg : IF_ID port map (clk,passed_rst,instruction_out_fetch,needs_imm,Pc_push,int_sig_out_fetch,stall,instruction_in_Decode,Pc_Push_in_dec,int_sig_in_dec);

Decoding_stage : Decode_stage port map (clk,Hardware_rst,instruction_in_Decode,Control_register_out_Decode,
			Rdst_address_out_decode,Swap_Address_out_decode,
			A_out_decode,B_out_decode,Alu_Selector_out_decode,
			'0',passed_rst,Mem_data_out_decode,needs_imm,out_imm,isnop,Conditional,PCout,PCvalTOFetch,write_enable1,Write_enable2,
			Write_data1,Write_data2,write_address1,write_address2,Read_address1,Read_address2);




---flag register hagez makan lhd ma newsal el ALU 
Decode_execute_register : ID_EX port map (clk,Passed_rst,conditional,jz_cond,Control_register_out_decode,
			Rdst_address_out_decode,Swap_address_out_decode,A_out_decode,B_out_decode
			,alu_selector_out_decode,mem_data_out_decode,is_imm_out_decode,Pc_Push_in_dec,int_sig_in_dec,stall,
			Alu_Selector_in_Execute,A_in_execute,B_in_execute,
			Control_register_in_execute,rdst_address_in_EXMEM
			,swap_address_in_EXMEM,mem_data_in_EXMEM,is_imm_in_execute,PC_push_in_ex,int_sig_in_ex);


Execute_stage : Exec_stage port map (clk,passed_rst,control_register_in_execute(6),isnop,A_in_execute,B_in_execute
		,Flag_register_in_execute,Control_register_in_execute,alu_Selector_in_execute,forward_data,forward_operand,hazard,
		Flag_register_out_execute,Result_out_execute,exception_out_ex);

Execute_memory_register : Ex_mem port map (clk,passed_rst,control_register_in_execute,
			Flag_register_out_Execute,result_out_Execute,rdst_address_in_EXMEM,
			swap_address_in_EXMEM,Mem_data_in_EXMEM,B_in_execute,exception_out_ex,int_sig_in_ex,PC_push_in_ex,
			Control_register_in_memory,flag_register_in_execute,result_in_Memory
			,Rdst_address_out_MEMEX,Swap_address_out_MEMEX,Mem_data_in_Memory,B_out_EXMEM,int_sig_out_ex_mem,PC_push_out_ex_mem);

Memory_stage : memoryStage port map (clk,passed_rst,Control_register_in_memory,
		result_in_Memory,mem_data_in_memory,PC_push_out_ex_mem,int_sig_out_ex_mem,Mem_Value_out_memory,exception_out_mem,Rdst_address_out_MEMEX,
			Swap_address_out_MEMEX,Rdst_address_out_memory,Swap_address_out_memory,Control_register_out_memory,B_out_EXMEM,B_out_memory);


Memory_Write_back_register : Mem_WB port map(clk,passed_rst,mem_Value_out_memory,Control_register_out_memory,
				Rdst_address_out_memory,Swap_address_out_memory,B_out_memory,in_port,exception_out_mem,Write_data1,
				Control_register_out_MemWB,write_address1,
				Write_address2,Write_data2,Write_enable1,Write_enable2,out_port);	



			


exception_out_port<=(exception_out_ex or exception_out_mem);

Hazard_Detection_Unit:Hazard_Detection port map(clk,rdst_address_in_EXMEM,Read_address1,Read_address2,Rdst_address_out_MEMEX,Result_out_execute,hazard,stall,forward_operand,forward_data);









end architecture;
