// ������ʼ��
`define RESET_ADDR      32'h0
`define ZERO_WORD       32'h0
`define DB_ZERO_WORD    64'h0
`define ZERO_REG_ADDR   5'h0

// �Ĵ���λ���ʼ��
`define INST_ADDR_BUS     31:0    // ��ַ����
`define INST_DATA_BUS     31:0    // ��������
`define INST_REG_ADDR     4:0     // ͨ�üĴ�����ַλ��
`define INST_REG_DATA     31:0    // ͨ�üĴ�������λ��
`define INST_DB_REG_DATA  63:0    // ˫���Ĵ�������λ��

// ��������
`define CLK_FREQ            'd50_000_000  // ϵͳʱ��Ƶ��(Hz)
`define UART_BPS            'd19200       // ���ڲ�����(Bps)
`define REG_NUM             32
`define ROM_NUM             4096
`define RAM_NUM             2048
`define REG_ADDR_WIDTH      5

// ALU��������
`define ALU_ADD      4'b0001
`define ALU_SUB      4'b0010
`define ALU_SLL      4'b0011  // �߼�����
`define ALU_SLT      4'b0100  // �з���С����1
`define ALU_SLTU     4'b0101  // �޷���С����1
`define ALU_XOR      4'b0110
`define ALU_SRL      4'b0111  // �߼�����
`define ALU_SRA      4'b1000  // ��������
`define ALU_OR       4'b1001
`define ALU_AND      4'b1010

// MUL��������
`define MUL          3'b001   // �з��ų˷�
`define MULSU        3'b010   // �з��ų����޷���
`define MULU         3'b011   // �޷��ų˷�

// DIV��������
`define DIV          3'b001   // �з��ų���
`define DIVU         3'b010   // �޷��ų���
`define REM          3'b011   // �з���ȡ��
`define REMU         3'b100   // �޷���ȡ��

// CSR�Ĵ�����ַ
`define CSR_CYCLE    12'hc00
`define CSR_CYCLEH   12'hc80
`define CSR_MTVEC    12'h305
`define CSR_MCAUSE   12'h342
`define CSR_MEPC     12'h341
`define CSR_MIE      12'h304
`define CSR_MSTATUS  12'h300
`define CSR_MSCRATCH 12'h340

// ��ͣ��ˮ��
`define HOLD_NONE    3'b000
`define HOLD_PC      3'b001
`define HOLD_IF_ID   3'b010
`define HOLD_ID_EX   3'b011

// �첽�ж�
`define INT_BUS     7:0
`define INT_NONE      8'b0000_0000
`define INT_TIMER     8'b0000_0001
`define INT_UART_REV  8'b0000_0010

// ��Ȩģʽ
`define PRIVILEG_USER        2'b00
`define PRIVILEG_SUPERVISOR  2'b01
`define PRIVILEG_MACHINE     2'b11

/* ָ��� */

// R��M��ָ��
`define INS_TYPE_R_M  7'b011_0011
// R�࣬funct7+funct3
`define INS_ADD     10'b00_0000_0000
`define INS_SUB     10'b01_0000_0000
`define INS_SLL     10'b00_0000_0001  // �߼�����
`define INS_SLT     10'b00_0000_0010  // С����1
`define INS_SLTU    10'b00_0000_0011  // �޷������Ƚ�С����1
`define INS_XOR     10'b00_0000_0100  // ���
`define INS_SRL     10'b00_0000_0101  // �߼�����
`define INS_SRA     10'b01_0000_0101  // ��������
`define INS_OR      10'b00_0000_0110
`define INS_AND     10'b00_0000_0111
// M�࣬funct7+funct3
`define INS_MUL     10'b00_0000_1000  
`define INS_MULH    10'b00_0000_1001  
`define INS_MULHSU  10'b00_0000_1010  
`define INS_MULHU   10'b00_0000_1011  
`define INS_DIV     10'b00_0000_1100  
`define INS_DIVU    10'b00_0000_1101  
`define INS_REM     10'b00_0000_1110  
`define INS_REMU    10'b00_0000_1111  

// I��ָ��
`define INS_TYPE_I  7'b001_0011
// funct3
`define INS_ADDI         3'b000
`define INS_SLTI         3'b010
`define INS_SLTIU        3'b011
`define INS_XORI         3'b100
`define INS_ORI          3'b110
`define INS_ANDI         3'b111
`define INS_SLLI         3'b001
`define INS_SRLI_SRAI    3'b101

// U��ָ��
`define INS_LUI         7'b011_0111  // ���������߼�����12λ�����Ĵ���rd
`define INS_AUIPC       7'b001_0111  // ���������߼�����12λ����PC��ǰֵ��Ӻ����Ĵ���rd

// ��������תָ��
`define INS_JAL         7'b110_1111  // ������+pc
`define INS_JALR        7'b110_0111  // ������+�Ĵ���+pc

// ��֧��תָ��
`define INS_TYPE_BRANCH         7'b110_0011
// funct3
`define INS_BEQ         3'b000  // �����ת
`define INS_BNE         3'b001  // ������ת
`define INS_BLT         3'b100  // С����ת
`define INS_BGE         3'b101  // ������ת
`define INS_BLTU        3'b110  // С����ת���޷�������
`define INS_BGEU        3'b111  // ������ת���޷�������

// �ô�ָ��SAVE
`define INS_TYPE_SAVE        7'b010_0011 
// funct3
`define INS_SB          3'b000  // ��8λ
`define INS_SH          3'b001  // ��16λ
`define INS_SW          3'b010  // ��32λ

// �ô�ָ��LOAD  
`define INS_TYPE_LOAD        7'b000_0011 
// funct3
`define INS_LB          3'b000  // ȡ8λ
`define INS_LH          3'b001  // ȡ16λ
`define INS_LW          3'b010  // ȡ32λ
`define INS_LBU         3'b100  // ȡ8λ���޷�����չ
`define INS_LHU         3'b101  // ȡ16λ���޷�����չ

// CSR�Ĵ�������ָ��
`define INS_TYPE_CSR         7'b1110011
// funct3
`define INS_CSRRW       3'b001
`define INS_CSRRS       3'b010
`define INS_CSRRC       3'b011
`define INS_CSRRWI      3'b101
`define INS_CSRRSI      3'b110
`define INS_CSRRCI      3'b111

`define INS_ECALL  32'h0000_0073
`define INS_EBREAK 32'h0010_0073
`define INS_MRET   32'h3020_0073
`define INS_NOP    32'h0000_0013  // �ղ���ָ�NOP������ΪADDI x0,x0,0