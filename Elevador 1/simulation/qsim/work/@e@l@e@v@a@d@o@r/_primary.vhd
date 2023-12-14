library verilog;
use verilog.vl_types.all;
entity ELEVADOR is
    port(
        ST              : in     vl_logic_vector(2 downto 0);
        LT              : in     vl_logic;
        GT              : in     vl_logic;
        EQ              : in     vl_logic;
        openDoor        : out    vl_logic;
        NS              : out    vl_logic_vector(2 downto 0);
        statusElev      : out    vl_logic_vector(1 downto 0)
    );
end ELEVADOR;
