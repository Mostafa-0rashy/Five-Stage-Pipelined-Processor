LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
USE IEEE.numeric_std.all;
Entity registers is 
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
end entity registers;


architecture registers_arch of registers is 

TYPE Arr IS ARRAY(0 TO 7) of std_logic_vector(31 DOWNTO 0);
SIGNAL Data_array: Arr :=("00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
			"00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
			"00000000000000000000000000000000","00000000000000000000000000000000");

begin
--Data_array(0) <=X"FFFFFFFF";
--Data_array(1) <=X"55555555";
--Data_array(2) <=X"ABCDABCD";
--Data_array(3) <=X"AAAAAAAA";
--Data_array(4) <=X"BBBBBBBB";
--Data_array(5) <=X"00000000";
--Data_array(6) <=X"44444444";
--Data_array(7) <=X"DDDDDDDD";



--initialize_memory : PROCESS
--    FILE memory_file : text OPEN READ_MODE IS "RegData.mem";
--    VARIABLE file_line : line;
--    VARIABLE temp_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
--    BEGIN
--
--        FOR i IN Data_array'RANGE LOOP
--            IF NOT endfile(memory_file) THEN
--                readline(memory_file, file_line);
--                read(file_line, temp_data);
--                Data_array(i) <= temp_data;
--
--            ELSE
--                file_close(memory_file);
--                WAIT;
--            END IF;
--        END LOOP;
--
--    END PROCESS;

--writing
---- REGISTER 0
Data_array(0)<= write_port1 when we1 = '1' and Write_address1 ="000" and rising_edge(clk)
else write_port2 when we2 = '1' and Write_address2 ="000"  and rising_edge(clk)
else X"00000000" when rst ='1' 
else Data_array(0);


---- REGISTER 1

Data_array(1)<= write_port1 when we1 = '1' and Write_address1 ="001" and rising_edge(clk)
else write_port2 when we2 = '1' and Write_address2 ="001" and rising_edge(clk)
else X"00000000" when rst ='1' 
else Data_array(1);

---- REGISTER 2



Data_array(2)<= write_port1 when we1 = '1' and Write_address1 ="010" and rising_edge(clk)  
else write_port2 when we2 = '1' and Write_address2 ="010" and rising_edge(clk)
else X"00000000" when rst ='1'  
else Data_array(2);

---- REGISTER 3


Data_array(3)<= write_port1 when we1 = '1' and Write_address1 ="011"   and rising_edge(clk)
else write_port2 when we2 = '1' and Write_address2 ="011" and rising_edge(clk)
else X"00000000" when rst ='1'  
else Data_array(3);

---- REGISTER 4


Data_array(4)<= write_port1 when we1 = '1' and Write_address1 ="100"   and rising_edge(clk)
else write_port2 when we2 = '1' and Write_address2 ="100" and rising_edge(clk)
else X"00000000" when rst ='1' 
else Data_array(4);

---- REGISTER 5


Data_array(5)<= write_port1 when we1 = '1' and Write_address1 ="101"  and rising_edge(clk)
else write_port2 when we2 = '1' and Write_address2 ="101" and rising_edge(clk)
else X"00000000" when rst ='1' 
else Data_array(5);

---- REGISTER 6


Data_array(6)<= write_port1 when we1 = '1' and Write_address1 ="110"  and rising_edge(clk) 
else write_port2 when we2 = '1' and Write_address2 ="110"and rising_edge(clk)
else X"00000000" when rst ='1' 
else Data_array(6);

---- REGISTER 7


Data_array(7)<= write_port1 when we1 = '1' and Write_address1 ="111"  and rising_edge(clk)
else write_port2 when we2 = '1' and Write_address2 ="111" and rising_edge(clk)
else X"00000000" when rst ='1'
else Data_array(7);


--- reading 
read_port1<= data_array(0) when re1='1'  and Read_address1="000" and falling_edge(clk)   
else data_array(1) when re1='1'  and Read_address1="001" and falling_edge(clk)
else data_array(2) when re1='1'  and Read_address1="010" and falling_edge(clk)
else data_array(3) when re1='1'  and Read_address1="011" and falling_edge(clk)
else data_array(4) when re1='1'  and Read_address1="100" and falling_edge(clk)
else data_array(5) when re1='1'  and Read_address1="101" and falling_edge(clk)
else data_array(6) when re1='1'  and Read_address1="110" and falling_edge(clk)
else data_array(7) when re1='1'  and Read_address1="111" and falling_edge(clk);



read_port2<= data_array(0) when re2='1'  and Read_address2="000" and falling_edge(clk)   
else data_array(1) when re2='1'  and Read_address2="001" and falling_edge(clk)
else data_array(2) when re2='1'  and Read_address2="010" and falling_edge(clk)
else data_array(3) when re2='1'  and Read_address2="011" and falling_edge(clk)
else data_array(4) when re2='1'  and Read_address2="100" and falling_edge(clk)
else data_array(5) when re2='1'  and Read_address2="101" and falling_edge(clk)
else data_array(6) when re2='1'  and Read_address2="110" and falling_edge(clk)
else data_array(7) when re2='1'  and Read_address2="111" and falling_edge(clk);




end registers_arch;
