

library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity sign_extender is 
port ( 
		rst: in std_logic;
                input : in std_logic_vector(15 downto 0);
                output : out std_logic_vector(31 downto 0)

);
end entity sign_extender;


architecture sign_extender_arch of sign_extender is 
begin
Process (rst)
begin 
if rst = '0' then
if input(15) = '0' then 
output <= X"0000"& input;
elsif input(15) ='1' then 
output <= X"FFFF"& input;
end if;
elsif rst ='1' then 
output <= X"00000000";
end if;
end process;


end sign_extender_arch;