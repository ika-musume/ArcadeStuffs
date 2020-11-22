module FlagToggler
(
    input   wire            nRESET,
    input   wire            nFLAGRESET,
    input   wire            nFLAGSET,
    output  reg             FLAGOUT = 1'b0
);

reg     flagreset_DFF_Q;
wire    flagset_DFF_R = ~(flagreset_DFF_Q | nRESET);

//Flag reset DFF
always @(negedge FLAGOUT or posedge nFLAGRESET)
begin
    if(FLAGOUT == 1'b0)
    begin
        flagreset_DFF_Q <= 1'b0;
    end
    else
    begin
        flagreset_DFF_Q <= 1'b1;   
    end
end

//Flag set DFF
always @(negedge flagset_DFF_R or posedge nFLAGSET)
begin
    if(flagset_DFF_R == 1'b0)
    begin
        FLAGOUT <= 1'b0;
    end
    else
    begin
        FLAGOUT <= 1'b1;   
    end
end

endmodule