----------------------------------------------------------------------
-- Fichero: Regs.vhd
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity RegsMIPS is
	port (
		Clk : in std_logic; -- Reloj
		Reset : in std_logic; -- Reset asíncrono a nivel bajo
		we3 : in std_logic; 
		wd3 : in std_logic_vector(31 downto 0); -- Dato de entrada RT
		A1 : in std_logic_vector(4 downto 0); -- Dirección RT
		A2 : in std_logic_vector(4 downto 0); -- Dirección RS
		A3 : in std_logic_vector(4 downto 0); -- Dirección RS
		Rd1 : out std_logic_vector(31 downto 0); -- Salida RS
		Rd2 : out std_logic_vector(31 downto 0) -- Salida RS
	); 
end RegsMIPS;

architecture Practica of RegsMIPS is

	-- Tipo para almacenar los registros
	type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);

	-- Esta es la señal que contiene los registros. El acceso es de la
	-- siguiente manera: regs(i) acceso al registro i, donde i es
	-- un entero. Para convertir del tipo std_logic_vector a entero se
	-- hace de la siguiente manera: conv_integer(slv), donde
	-- slv es un elemento de tipo std_logic_vector

	-- Registros inicializados a '0' 
	-- NOTA: no cambie el nombre de esta señal.
	signal regs : regs_t;
begin  -- PRACTICA
	------------------------------------------------------
	-- Escritura del registro RT
	------------------------------------------------------
process(Clk,Reset) 
begin 
	if Reset='1' then
		for i in 0 to 31 loop
		regs(i)<=(others=>'0');
		end loop;
	elsif falling_edge(Clk) then 
			if A3/="00000" then 
				if we3 = '1' then	
					regs(conv_integer(A3))<=wd3;
				end if;
			end if;
	end if;	
end process;
	------------------------------------------------------
	-- Lectura del registro RS
	------------------------------------------------------

		Rd1<=regs(conv_integer(A1)); 
		Rd2<=regs(conv_integer(A2));

end Practica;
