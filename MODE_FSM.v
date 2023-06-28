module MODE_FSM (CLK,
                 nRST,
                 nRST2,
                 LEVER,
                 DIRECTION,
                 kP,
                 kI,
                 kD,
                 P_POINT,
                 D_POINT,
                 DATA_IN1,
                 DATA_IN2,
                 DATA_IN3,
                 DATA_IN4,
                 FAN1_RPM,
                 FAN2_RPM,
                 FAN3_RPM,
                 FAN4_RPM,
                 PRV_FAN1_RPM,
                 PRV_FAN2_RPM,
                 PRV_FAN3_RPM,
                 PRV_FAN4_RPM,
                 PID_OUT1,
                 PID_OUT2,
                 PID_OUT3,
                 PID_OUT4
                                );


    input                CLK, nRST, nRST2;
    input                LEVER;
    input          [2:0] DIRECTION;
    input          [4:0] kP, kI, kD;
    input          [2:0] P_POINT, D_POINT;
    input  signed [31:0] DATA_IN1, DATA_IN2, DATA_IN3, DATA_IN4;
    output    reg [13:0] FAN1_RPM, FAN2_RPM, FAN3_RPM, FAN4_RPM;
    output    reg [13:0] PRV_FAN1_RPM, PRV_FAN2_RPM, PRV_FAN3_RPM, PRV_FAN4_RPM;
    output signed [31:0] PID_OUT1, PID_OUT2, PID_OUT3, PID_OUT4;
    
    parameter HOVER    = 4'b0000,
              FORWARD  = 4'b0001,
              BACKWARD = 4'b0010,
              RIGHT    = 4'b0011,
              LEFT     = 4'b0100,
              CW       = 4'b0101,
              CCW      = 4'b0110,
              UP       = 4'b0111,
              DOWN     = 4'b1000;


    reg  [3:0] NEXT, STATE, PRV_STATE;
    reg        TOGGLE;


    always @(posedge CLK or negedge nRST) begin
        if (!nRST) begin
                STATE <= HOVER;
            PRV_STATE <= HOVER;    
        end
        else begin
                STATE <= NEXT;
        end
    end

    always @(posedge CLK) begin
        if (TOGGLE) begin
            PRV_STATE <= STATE;
            TOGGLE <= 0;
        end
        else begin
            PRV_STATE <= PRV_STATE;
            TOGGLE <= 0;
        end
    end

    always @(*) begin
        NEXT <= 4'bx;
        case (STATE)
            HOVER   : if      ((LEVER == 1) && (DIRECTION == 1)) begin
                        NEXT <= FORWARD;
                        TOGGLE <= 1;
                      end 
                      else if ((LEVER == 1) && (DIRECTION == 2)) begin
                        NEXT <= BACKWARD; 
                        TOGGLE <= 1;
                      end
                      else if ((LEVER == 1) && (DIRECTION == 3)) begin
                        NEXT <= RIGHT;
                        TOGGLE <= 1;                        
                      end
                      else if ((LEVER == 1) && (DIRECTION == 4)) begin
                        NEXT <= LEFT;
                        TOGGLE <= 1;                        
                      end
                      else if ((LEVER == 0) && (DIRECTION == 4)) begin
                        NEXT <= CW;
                        TOGGLE <= 1;                        
                      end
                      else if ((LEVER == 0) && (DIRECTION == 3)) begin
                        NEXT <= CCW;
                        TOGGLE <= 1;                        
                      end
                      else if ((LEVER == 0) && (DIRECTION == 1)) begin
                        NEXT <= UP;
                        TOGGLE <= 1;                        
                      end
                      else if ((LEVER == 0) && (DIRECTION == 2)) begin
                        NEXT <= DOWN;
                        TOGGLE <= 1;                        
                      end
                      else begin
                        NEXT <= HOVER;                       
                      end


           FORWARD  : if ((DIRECTION == 0)) begin
                        NEXT <= HOVER;
                        TOGGLE <= 1;            
                      end
                      else NEXT <= FORWARD;

           BACKWARD : if ((DIRECTION == 0)) begin
                        NEXT <= HOVER;
                        TOGGLE <= 1;            
                      end
                      else NEXT <= BACKWARD;

           RIGHT    : if ((DIRECTION == 0)) begin
                        NEXT <= HOVER;
                        TOGGLE <= 1;            
                      end
                      else NEXT <= RIGHT;

           LEFT     : if ((DIRECTION == 0)) begin
                        NEXT <= HOVER;
                        TOGGLE <= 1;            
                      end
                      else NEXT <= LEFT;

           CW       : if ((DIRECTION == 0)) begin
                        NEXT <= HOVER;
                        TOGGLE <= 1;
                      end
                      else NEXT <= CW;

           CCW      : if ((DIRECTION == 0)) begin
                        NEXT <= HOVER;
                        TOGGLE <= 1;            
                      end
                      else NEXT <= CCW;

           UP       : if ((DIRECTION == 0)) begin
                        NEXT <= HOVER;
                        TOGGLE <= 1;
                      end
                      else NEXT <= UP;

           DOWN     : if ((DIRECTION == 0)) begin
                        NEXT <= HOVER;
                        TOGGLE <= 1;            
                      end
                      else NEXT <= DOWN;
        endcase
    end


    always @(*) begin
        if (STATE == FORWARD) begin
            FAN1_RPM <= 15'd6000;
            FAN2_RPM <= 15'd10000;
            FAN3_RPM <= 15'd10000;
            FAN4_RPM <= 15'd6000;
        end
        else if (STATE == BACKWARD) begin
            FAN1_RPM <= 15'd10000;
            FAN2_RPM <= 15'd6000;
            FAN3_RPM <= 15'd6000;
            FAN4_RPM <= 15'd10000;
        end       
        else if (STATE == RIGHT) begin
            FAN1_RPM <= 15'd6000;
            FAN2_RPM <= 15'd6000;
            FAN3_RPM <= 15'd10000;
            FAN4_RPM <= 15'd10000;
        end
        else if (STATE == LEFT) begin
            FAN1_RPM <= 15'd10000;
            FAN2_RPM <= 15'd10000;
            FAN3_RPM <= 15'd6000;
            FAN4_RPM <= 15'd6000;
        end        
        else if (STATE == CW) begin
            FAN1_RPM <= 15'd10000;
            FAN2_RPM <= 15'd6000;
            FAN3_RPM <= 15'd10000;
            FAN4_RPM <= 15'd6000;
        end
        else if (STATE == CCW) begin
            FAN1_RPM <= 15'd6000;
            FAN2_RPM <= 15'd10000;
            FAN3_RPM <= 15'd6000;
            FAN4_RPM <= 15'd10000;
        end
        else if (STATE == UP) begin
            FAN1_RPM <= 15'd10000;
            FAN2_RPM <= 15'd10000;
            FAN3_RPM <= 15'd10000;
            FAN4_RPM <= 15'd10000;
        end
        else if (STATE == DOWN) begin
            FAN1_RPM <= 15'd6000;
            FAN2_RPM <= 15'd6000;
            FAN3_RPM <= 15'd6000;
            FAN4_RPM <= 15'd6000;
        end
        else begin
            FAN1_RPM <= 15'd8000;
            FAN2_RPM <= 15'd8000;
            FAN3_RPM <= 15'd8000;
            FAN4_RPM <= 15'd8000;
        end
    end


    always @(*) begin
        if (PRV_STATE == FORWARD) begin
            PRV_FAN1_RPM <= 15'd6000;
            PRV_FAN2_RPM <= 15'd10000;
            PRV_FAN3_RPM <= 15'd10000;
            PRV_FAN4_RPM <= 15'd6000;
        end
        else if (PRV_STATE == BACKWARD) begin
            PRV_FAN1_RPM <= 15'd10000;
            PRV_FAN2_RPM <= 15'd6000;
            PRV_FAN3_RPM <= 15'd6000;
            PRV_FAN4_RPM <= 15'd10000;
        end
        else if (PRV_STATE == RIGHT) begin
            PRV_FAN1_RPM <= 15'd6000;
            PRV_FAN2_RPM <= 15'd6000;
            PRV_FAN3_RPM <= 15'd10000;
            PRV_FAN4_RPM <= 15'd10000;
        end
        else if (PRV_STATE == LEFT) begin
            PRV_FAN1_RPM <= 15'd10000;
            PRV_FAN2_RPM <= 15'd10000;
            PRV_FAN3_RPM <= 15'd6000;
            PRV_FAN4_RPM <= 15'd6000;
        end
        else if (PRV_STATE == CW) begin
            PRV_FAN1_RPM <= 15'd10000;
            PRV_FAN2_RPM <= 15'd6000;
            PRV_FAN3_RPM <= 15'd10000;
            PRV_FAN4_RPM <= 15'd6000;
        end
        else if (PRV_STATE == CCW) begin
            PRV_FAN1_RPM <= 15'd6000;
            PRV_FAN2_RPM <= 15'd10000;
            PRV_FAN3_RPM <= 15'd6000;
            PRV_FAN4_RPM <= 15'd10000;
        end
        else if (PRV_STATE == UP) begin
            PRV_FAN1_RPM <= 15'd10000;
            PRV_FAN2_RPM <= 15'd10000;
            PRV_FAN3_RPM <= 15'd10000;
            PRV_FAN4_RPM <= 15'd10000;
        end
        else if (PRV_STATE == DOWN) begin           
            PRV_FAN1_RPM <= 15'd6000;
            PRV_FAN2_RPM <= 15'd6000;
            PRV_FAN3_RPM <= 15'd6000;
            PRV_FAN4_RPM <= 15'd6000;
        end
        else begin // HOVER의 RPM 값
            PRV_FAN1_RPM <= 15'd8000;
            PRV_FAN2_RPM <= 15'd8000;
            PRV_FAN3_RPM <= 15'd8000;
            PRV_FAN4_RPM <= 15'd8000;
        end
    end    

    PID PID_FAN1 (.CLK(CLK), .nRST2(nRST2), .FAN_RPM(FAN1_RPM), .PRV_FAN_RPM(PRV_FAN1_RPM), .kP(kP), .kI(kI), .kD(kD), .P_POINT(P_POINT), .D_POINT(D_POINT), .DATA_IN(DATA_IN1), .PID_OUTPUT(PID_OUT1));
    PID PID_FAN2 (.CLK(CLK), .nRST2(nRST2), .FAN_RPM(FAN2_RPM), .PRV_FAN_RPM(PRV_FAN2_RPM), .kP(kP), .kI(kI), .kD(kD), .P_POINT(P_POINT), .D_POINT(D_POINT), .DATA_IN(DATA_IN2), .PID_OUTPUT(PID_OUT2));
    PID PID_FAN3 (.CLK(CLK), .nRST2(nRST2), .FAN_RPM(FAN3_RPM), .PRV_FAN_RPM(PRV_FAN3_RPM), .kP(kP), .kI(kI), .kD(kD), .P_POINT(P_POINT), .D_POINT(D_POINT), .DATA_IN(DATA_IN3), .PID_OUTPUT(PID_OUT3));
    PID PID_FAN4 (.CLK(CLK), .nRST2(nRST2), .FAN_RPM(FAN4_RPM), .PRV_FAN_RPM(PRV_FAN4_RPM), .kP(kP), .kI(kI), .kD(kD), .P_POINT(P_POINT), .D_POINT(D_POINT), .DATA_IN(DATA_IN4), .PID_OUTPUT(PID_OUT4));
   
endmodule