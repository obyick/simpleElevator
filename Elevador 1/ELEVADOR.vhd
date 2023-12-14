-- Biblioteca IEEE para utilizar a lógica padrão
library ieee;
use ieee.std_logic_1164.all;

-- Entidade ELEVADOR
entity ELEVADOR is
    port(
		  -- Input
        ST            : in bit_vector(2 downto 0);   -- Entrada: Estado do elevador
        LT, GT, EQ    : in bit;                      -- Entradas: Sinais de comparação
        btnInternal   : in bit_vector(2 downto 0);   -- Entrada: Botões internos do elevador
        btnCall       : in bit_vector(2 downto 0);   -- Entrada: Botões de chamada externa
		  
		  -- Output
        openDoor      : out bit;                     -- Saída: Sinal para abrir a porta
        NS            : out bit_vector(2 downto 0);  -- Saída: Próximo estado do elevador
        statusElev    : out bit_vector(1 downto 0);  -- Saída: Status interno do elevador
        ledFloor      : out bit_vector(2 downto 0);  -- Saída: LEDs indicadores de andar
        lcdData       : out bit_vector(7 downto 0);  -- Saída: Dados para o display LCD
        lcdEnable     : out bit;                     -- Saída: Ativar o display LCD
        lcdRS         : out bit                      -- Saída: Seleção de registro no display LCD
    );
end ELEVADOR;

-- Arquitetura do ELEVADOR
architecture main of ELEVADOR is
    signal SE1 : bit;  -- Sinal interno: Status interno 1
    signal SE2 : bit;  -- Sinal interno: Status interno 2

    signal NS0 : bit;  -- Sinal interno: Próximo estado 0
    signal NS1 : bit;  -- Sinal interno: Próximo estado 1
    signal NS2 : bit;  -- Sinal interno: Próximo estado 2

    signal ST0 : bit;  -- Sinal interno: Estado 0
    signal ST1 : bit;  -- Sinal interno: Estado 1
    signal ST2 : bit;  -- Sinal interno: Estado 2

    signal btnCall0     : bit;  -- Sinal interno: Botão de chamada 0
    signal btnCall1     : bit;  -- Sinal interno: Botão de chamada 1
    signal btnCall2     : bit;  -- Sinal interno: Botão de chamada 2

    signal btnInternal0 : bit;  -- Sinal interno: Botão interno 0
    signal btnInternal1 : bit;  -- Sinal interno: Botão interno 1
    signal btnInternal2 : bit;  -- Sinal interno: Botão interno 2

    signal ledFloor0 : bit;  -- Sinal interno: LED de andar 0
    signal ledFloor1 : bit;  -- Sinal interno: LED de andar 1
    signal ledFloor2 : bit;  -- Sinal interno: LED de andar 2

    signal currentFloor : integer := 0;  -- Variável interna: Andar atual

begin
	 -- Sinais de entrada para sinais internos
    ST0 <= ST(0);  -- Estado 0
    ST1 <= ST(1);  -- Estado 1
    ST2 <= ST(2);  -- Estado 2

    btnCall0 <= btnCall(0);  -- Botão de chamada 0
    btnCall1 <= btnCall(1);  -- Botão de chamada 1
    btnCall2 <= btnCall(2);  -- Botão de chamada 2

    btnInternal0 <= btnInternal(0);  -- Botão interno 0
    btnInternal1 <= btnInternal(1);  -- Botão interno 1
    btnInternal2 <= btnInternal(2);  -- Botão interno 2

    -- Lógica para acender os LEDs dos andares
    ledFloor0 <= ST0 and (not ST1) and (not ST2);
    ledFloor1 <= (not ST0) and ST1 and (not ST2);
    ledFloor2 <= (not ST0) and (not ST1) and ST2;

    -- Lógica para determinar quando abrir a porta
    SE1 <= ST0 and (not ST1) and (not ST2) and (not LT) and (GT xor EQ);
    SE2 <= (not ST0) and ST1 and ST2 and (not GT) and (LT xor EQ);

    openDoor <= (not ST0) and (not ST1) and (((not ST2) and (not LT) and (not GT) and EQ) or (ST2 and (((not LT) and (not GT) and EQ) or ((not EQ) and (LT XOR GT)))));

    -- Lógica para determinar o próximo estado do elevador
    NS0 <= ST2 and (not LT) and GT and (ST0 xor ST1);
    NS1 <= ((not ST0) and ((ST2 and ((not ST1) and (not EQ) and (LT XOR GT))) or (ST1 and (not GT) and (LT XOR EQ)))) or (((not ST2) and (not GT) and ((not ST0) and ST1 and LT and (not EQ))) or (ST0 and (not ST1) and (not LT) and EQ));
    NS2 <= (not ST0) and (not GT) and (((not ST1) and (not LT) and EQ) or (ST1 and LT and (not GT) and (not EQ)));

    -- Status internos
    statusElev(0) <= SE1;
    statusElev(1) <= SE2;

    -- Próximo estado
    NS(0) <= NS0;
    NS(1) <= NS1;
    NS(2) <= NS2;

    -- Lógica para determinar o andar atual com base no estado atual
    process(ST)
    begin
        if ST = "000" then
            currentFloor <= 0;
        elsif ST = "001" then
            currentFloor <= 1;
        elsif ST = "010" then
            currentFloor <= 2;
        else
            currentFloor <= -1;  -- Estado desconhecido
        end if;
    end process;

    -- Display LCD com base no andar atual
    process(currentFloor)
    begin
        case currentFloor is
            when 0 =>
                lcdData <= "00000001";  -- Exibir o número "0"
            when 1 =>
                lcdData <= "00000010";  -- Exibir o número "1"
            when 2 =>
                lcdData <= "00000011";  -- Exibir o número "2"
            when others =>
                lcdData <= "00000000";  -- Exibir um caractere inválido ou espaço em branco
        end case;

        lcdEnable <= '1';   -- Ativar o display LCD
        lcdRS <= '1';       -- Selecionar registro no display
        lcdEnable <= '0';   -- Desativar o display LCD
    end process;

    -- Atribuição dos LEDs de andar
    ledFloor <= ledFloor2 & ledFloor1 & ledFloor0;

end architecture main;