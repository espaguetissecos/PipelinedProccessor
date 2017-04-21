----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:43:48 09/23/2015 
-- Design Name: 
-- Module Name:    UnidadControl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UnidadControl is
    Port ( 
			OPCode : in  STD_LOGIC_VECTOR (31 downto 26);
			Funct: in std_logic_vector(5 downto 0); -- Funcion si es R-type
			RegDest : out  STD_LOGIC;
			MemtoReg : out  STD_LOGIC;
			ALUControl : out  STD_LOGIC_VECTOR (3 downto 0);
			MemWrite : out  STD_LOGIC;
			AluSrc : out  STD_LOGIC;
			RegWrite : out  STD_LOGIC;
			PCSrc: out std_logic_vector(1 downto 0) -- Señal de salida PCToReg
	);

end UnidadControl;

architecture Behavioral of UnidadControl is

begin


	-----------

	RegEscribir: process(OPCode) -- Este proceso guarda relacion con lo que saldra de RegWrite dependiendo de OPCode
	
	begin
		case OPCode is 
			when "000000" => -- Sera la salida AND si corresponde con R-TYPE
				RegWrite <= '1'; -- Sera la salida 1 si OPCode corresponde a R-Type(todos escriben en Reg)

			when "100011" => RegWrite <= '1'; -- Sera 1 si LW
			when "001010" => RegWrite <= '1'; -- Sera uno si SLTI
			when "001111" => RegWrite <= '1'; -- Sera uno si LUI
			
			when others => RegWrite <= '0'; -- En el resto de casos serï¿½ 0(J, BNE, BEQ, SW) 
			
		end case;
	end process RegEscribir;
	
	-----------

	SrcALU: process(OPCode) -- Este proceso guarda relacion con lo que saldra de ALUSrc dependiendo de OPCode
	begin
		case OPCode is 	
		
			when "100011" => ALUSrc <= '1'; -- Sera la salida 1 si OPCode corresponde a LW
			when "101011" => ALUSrc <= '1'; -- Sera la salida 1 si OPCode corresponde a SW
			when "001010" => ALUSrc <= '1'; -- Sera la salida 1 si OPCode corresponde a SLTI
			when "001111" => ALUSrc <= '1'; -- Sera la salida 1 si OPCode corresponde a LUI

			when others => ALUSrc <= '0'; -- En el resto de casos serï¿½ 0 
		end case;
	end process SrcALU;

	----------
	
	EscribirMemoria: process(OPCode) -- Este proceso guarda relacion con lo que saldra de MemWrite dependiendo de OPCode
	begin
		case OPCode is 
			when "101011" => MemWrite <= '1';-- Sera la salida 1 si OPCode corresponde a SW			  
			when others => MemWrite <= '0'; -- En el resto de casos serï¿½ 0 
		end case;
	end process EscribirMemoria;
	
	----------
	
	MemToRegistro: process(OPCode) -- Este proceso guarda relacion con lo que saldra de ALUControl dependiendo de OPCode
	begin
		case OPCode is 
			when "100011" => MemtoReg <= '1';-- Sera la salida 1 si OPCode corresponde a LW			  
			when others => MemtoReg <= '0'; -- En el resto de casos serï¿½ 0 
		end case;
 	end process MemToRegistro;
	
	----------
	
	RegDestino: process(OPCode, Funct) -- Este proceso guarda relacion con lo que saldra de RegDest dependiendo de OPCode y Funct
	begin
		case OPCode is 
			when "000000" => 
				RegDest <= '1'; -- Sera la salida 1 si OPCode corresponde a R-TYPE
			when others => RegDest <= '0'; -- En el resto de casos serï¿½ 0 
		end case;
	end process RegDestino;
	
	
	LogSalto: process(OPCode)
	begin 
		case OPCode is 
			when "000101"=> PCSrc<="10";	-- BNE
			when "000100" => PCSrc<="11"; 	-- BEQ
			when "000010"=> PCSrc<="01";	-- JMP DST
			when others => PCSrc<="00";	-- PC+4
		end case;
	end process LogSalto;
	
	ControlALU: process(OPCode, Funct) -- Este proceso guarda relacion con lo que saldra de ALUControl dependiendo de OPCode y de Funct
	begin
		case OPCode is 
			when "000000" => 
			case Funct is --miramos el valor del campo funct
				when "100000" => ALUControl<="0011"; -- Operacion Add
				when "100010" => ALUControl<="1000"; -- Operacion Sub
				when "100100" => ALUControl<="0000"; -- Operacion and
				when "100101" => ALUControl<="0001"; -- Operacion or
				when others => ALUControl<="0010"; -- Operacion xor	
				end case;

			when "001111" => ALUControl<="1001"; -- Operacion lui
			when "001010" => ALUControl<="1010"; -- Operacion slti
			when "100011"=> ALUControl <= "0011" ; -- lw
			when others=> ALUControl <= "0011" ; -- sw

		end case;
	end process ControlALU;
	
	
end Behavioral;

