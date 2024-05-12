library verilog;
use verilog.vl_types.all;
entity ALU_1bit is
    generic(
        \AND\           : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        \OR\            : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        ADD             : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        SLT             : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        control         : in     vl_logic_vector(2 downto 0);
        Ain             : in     vl_logic;
        Bin             : in     vl_logic;
        cin             : in     vl_logic;
        Less            : in     vl_logic;
        result          : out    vl_logic;
        cout            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of \AND\ : constant is 1;
    attribute mti_svvh_generic_type of \OR\ : constant is 1;
    attribute mti_svvh_generic_type of ADD : constant is 1;
    attribute mti_svvh_generic_type of SLT : constant is 1;
end ALU_1bit;
