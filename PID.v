
module PID (CLK, nRST2, FAN_RPM, PRV_FAN_RPM, kP, kI, kD, P_POINT, D_POINT, DATA_IN, PID_OUTPUT);

    input                CLK, nRST2;
    input         [13:0] FAN_RPM, PRV_FAN_RPM;
    input          [4:0] kP, kI, kD;
    input          [2:0] P_POINT, D_POINT;
    input  signed [31:0] DATA_IN;
    output reg signed [31:0] PID_OUTPUT;


    reg signed [31:0] ERROR, SUM_ERROR, PRV_ERROR, PRV2_ERROR, PRV3_ERROR, PRV4_ERROR, PRV5_ERROR, P_Controller, I_Controller, D_Controller;
    
    
    always @(posedge CLK or negedge nRST2) begin
        if (!nRST2) begin
            ERROR      <= (FAN_RPM - PRV_FAN_RPM);
            SUM_ERROR  <= (FAN_RPM - PRV_FAN_RPM);
            PRV_ERROR  <= (FAN_RPM - PRV_FAN_RPM);
            PRV2_ERROR <= (FAN_RPM - PRV_FAN_RPM);
            PRV3_ERROR <= (FAN_RPM - PRV_FAN_RPM);
            PRV4_ERROR <= (FAN_RPM - PRV_FAN_RPM);
            PRV5_ERROR <= (FAN_RPM - PRV_FAN_RPM);
            P_Controller <= 0;
            I_Controller <= 0;
            D_Controller <= 0;
            PID_OUTPUT <= 0;
        end
        else begin
            ERROR <= (FAN_RPM - PRV_FAN_RPM) - DATA_IN;
            SUM_ERROR <= SUM_ERROR + ERROR;
            PRV_ERROR <= ERROR;
            PRV2_ERROR <= PRV_ERROR;
            PRV3_ERROR <= PRV2_ERROR;
            PRV4_ERROR <= PRV3_ERROR;
            PRV5_ERROR <= PRV4_ERROR;
            P_Controller <=      (10**(3-P_POINT)) * kP * ERROR;
            I_Controller <=                          kI * (SUM_ERROR);
            D_Controller <= 20 * (10**(4-D_POINT)) * kD * (ERROR-PRV5_ERROR);
            PID_OUTPUT <= (P_Controller + I_Controller + D_Controller);
        end
    end

endmodule