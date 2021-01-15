`timescale 10ns/10ns
module PC060HA_top_tb;

//resets
reg             nIC = 1'b0;
wire            nROUT;

//clock
reg             CLK = 1'b1;

//slave side
reg             nSCS = 1'b1;
reg             nSRD = 1'b1;
reg             nSWR = 1'b1;
reg             SA0 = 1'b1;
wire    [3:0]   SD;
reg     [3:0]   slaveDataReg = 4'b0000;

//slave side
reg             nMCS = 1'b1;
reg             nMRD = 1'b1;
reg             nMWR = 1'b1;
reg             MA0 = 1'b1;
wire    [3:0]   MD;
reg     [3:0]   masterDataReg = 4'b0000;

//GPIO
reg             IN0 = 1'b1;
reg             IN1 = 1'b0;
wire            nNMI;
wire            AMP;



PC060HA_top PC060HA_top
(
	.nIC (nIC),
    .nROUT (nROUT),

    .SCLK (CLK),
    .MCLK (CLK),

    .nSCS (nSCS),
    .nSRD (nSRD),
    .nSWR (nSWR),
    .SA0 (SA0),
    .SD (SD),

    .nMCS (nMCS),
    .nMRD (nMRD),
    .nMWR (nMWR),
    .MA0 (MA0),
    .MD (MD),

    .IN0 (IN0),
    .IN1 (IN1),
    .nNMI (nNMI),
    .AMP (AMP)
);

//inout port switcher
reg            slave_data_reg_write = 1'b1;   //active low
reg            master_data_reg_write = 1'b1;  //active low
assign          SD = ((slave_data_reg_write) == 1'b1) ? 4'bZZZZ : slaveDataReg;
assign          MD = ((master_data_reg_write) == 1'b1) ? 4'bZZZZ : masterDataReg;

always #1 CLK = ~CLK;

initial
begin
    #7 nIC = 1'b1;
    #1 nIC = 1'b0; //glitch
    #1 nIC = 1'b1; 
end

initial
begin
    #10;

    //cycle 0 = 100ns: 이상한데 읽기
    #0 MA0 = 1'b0;
    #0 nMCS = 1'b1;
    #1 nMRD = 1'b0;
    #4 nMRD = 1'b1;
    #1 nMCS = 1'b1;

    //cycle 1 = 160ns: 이상한데 쓰기
    #0 MA0 = 1'b1;
    #0 nMCS = 1'b1;
    #3 nMWR = 1'b0;
    #2 nMWR = 1'b1;
    #1 nMCS = 1'b1;

    //cycle 2 = 220ns: 마스터 레지스터 읽기 0번
    #0 MA0 = 1'b1;
    #0 nMCS = 1'b0;
    #1 nMRD = 1'b0;
    #4 nMRD = 1'b1;
    #1 nMCS = 1'b0;

    //cycle 3 = 280ns: 마스터 레지스터 읽기 1번
    #0 MA0 = 1'b1;
    #0 nMCS = 1'b0;
    #1 nMRD = 1'b0;
    #4 nMRD = 1'b1;
    #1 nMCS = 1'b0;

    //cycle 4 = 340ns: 마스터 레지스터 읽기 2번
    #0 MA0 = 1'b1;
    #0 nMCS = 1'b0;
    #1 nMRD = 1'b0;
    #4 nMRD = 1'b1;
    #1 nMCS = 1'b0;

    //cycle 5 = 460ns: 마스터 페이지 레지스터 쓰기 (NMI ON 6번)
    #0 MA0 = 1'b0;
    #0 nMCS = 1'b0;
    #0 masterDataReg = 4'b0110;
    #1 master_data_reg_write = 1'b0;
    #2 nMWR = 1'b0;
    #2 nMWR = 1'b1;
    #1 nMCS = 1'b0;
    #0 master_data_reg_write = 1'b1;

    //cycle 5 = 400ns: 마스터 레지스터 쓰기 6번
    #0 MA0 = 1'b1;
    #0 nMCS = 1'b0;
    #0 masterDataReg = 4'b0001;
    #1 master_data_reg_write = 1'b0;
    #2 nMWR = 1'b0;
    #2 nMWR = 1'b1;
    #1 nMCS = 1'b0;
    #0 master_data_reg_write = 1'b1;

    //cycle 5 = 460ns: 마스터 페이지 레지스터 쓰기 (1로 돌림)
    #0 MA0 = 1'b0;
    #0 nMCS = 1'b0;
    #0 masterDataReg = 4'b0001;
    #1 master_data_reg_write = 1'b0;
    #2 nMWR = 1'b0;
    #2 nMWR = 1'b1;
    #1 nMCS = 1'b0;
    #0 master_data_reg_write = 1'b1;

    //cycle 7 = 520ns: 마스터 레지스터 쓰기 1
    #0 MA0 = 1'b1;
    #0 nMCS = 1'b0;
    #0 masterDataReg = 4'b0111;
    #1 master_data_reg_write = 1'b0;
    #2 nMWR = 1'b0;
    #2 nMWR = 1'b1;
    #1 nMCS = 1'b0;
    #0 master_data_reg_write = 1'b1;



end

endmodule