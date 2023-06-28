`timescale 100us/100us

module TESTBENCH;
    reg                CLK, nRST, nRST2;                                            // CLK is for clock inputs, nRST is for MODE_FSM's input reset, nRST2 is for PID module input reset
    reg                LEVER;                                                       // Gets the user's input for LEVER 
    reg          [2:0] DIRECTION;                                                   // Gets the user's input for DIRECTION
    reg          [4:0] kP, kI, kD;                                                  // kP is the P_Controller's gain value, kI is the I_Controller's gain value, kD is the D_Controller's gain value
    reg          [2:0] P_POINT, D_POINT;                                            // P_POINT is the number of digit under the decimal point of P_Controller's gain value, D_POINT is the number of digit under the decimal point of D_Controller's gain value
    reg  signed [31:0] DATA_IN1, DATA_IN2, DATA_IN3, DATA_IN4;                      // DATA_IN is the step response output of the total system, it is utilized with to calculate errors in the PID modules
    wire        [13:0] FAN1_RPM, FAN2_RPM, FAN3_RPM, FAN4_RPM;                      // FAN1~4_RPM is FAN1~4's current MODE's RPM
    wire        [13:0] PRV_FAN1_RPM, PRV_FAN2_RPM, PRV_FAN3_RPM, PRV_FAN4_RPM;      // PRV_FAN1~4_RPM is FAN1~4's past MODE's RPM
    wire signed [31:0] PID_OUT1, PID_OUT2, PID_OUT3, PID_OUT4;                      // PID_OUT1~4 is FAN1's output value of PID Control calculation

    initial begin
            nRST  = 0; // Sets the initial nRST to 0
        #3  nRST  = 1; // Turns on the nRST to 1
        #10;
    end

    initial begin
        CLK = 0;
        forever begin
            #5 CLK = ~CLK;
        end
    end


    initial begin
        kP = 3; kI = 3; kD = 3;  // Acutal values fo kP, kI, kD
        P_POINT = 0; D_POINT= 1; // P_POINT is the number of digit under the decimal point of P_Controller's gain value, D_POINT is the number of digit under the decimal point of D_Controller's gain value
    end


    reg signed [31:0] REF_DATA1 [0:2999]; // vector array for storing the DATA_IN inputs
    reg signed [31:0] REF_DATA2 [0:2999]; // vector array for storing the DATA_IN inputs


    reg [13:0] CNT; // Counter variable
    integer i, f_RPM_PLUS_2000, f_RPM_MINUS_2000;// handle variables for opening DATA_IN files

    always @(posedge CLK or negedge nRST or negedge nRST2) begin
        if (!nRST) begin
            f_RPM_PLUS_2000  = $fopen("ROUNDED_SYS_OUT_3_3_03_PLUS_2000RPM.txt", "r+");  // allocate handlers to ROUNDED_SYS_OUT_3_3_03_PLUS_2000RPM.txt
            f_RPM_MINUS_2000 = $fopen("ROUNDED_SYS_OUT_3_3_03_MINUS_2000RPM.txt", "r+"); // allocate handlers to ROUNDED_SYS_OUT_3_3_03_MINUS_2000RPM.txt
            CNT <= 0;
                if ((f_RPM_PLUS_2000) != 0) begin
                    for (i = 0; i < 3000; i = i + 1) begin
                    $fscanf(f_RPM_PLUS_2000 , "%d\n", REF_DATA1[i]);            // Receives the DATA_IN data, and stores it to vector array
                    $fscanf(f_RPM_MINUS_2000, "%d\n", REF_DATA2[i]);            // Receives the DATA_IN data, and stores it to vector array
                end
            end
        end
        else begin
            if (!nRST2) begin
                CNT <= 0;           // resets the counter to 0 for new PID calculations
            end
            else begin
                CNT <= CNT + 1;     // adds 1 to the counter variable to read the next vector array
            end
        end
    end


    always @(*) begin
        if      ((FAN1_RPM - PRV_FAN1_RPM) == 2000) begin       // put in DATA_IN based on the difference value between FAN1_RPM and PRV_FAN1_RPM
            DATA_IN1 = REF_DATA1[CNT];
        end
        else if ((FAN1_RPM - PRV_FAN1_RPM) == -2000) begin
            DATA_IN1 = REF_DATA2[CNT];
        end
    end

    always @(*) begin
        if      ((FAN2_RPM - PRV_FAN2_RPM) == 2000) begin
            DATA_IN2 = REF_DATA1[CNT];
        end
        else if ((FAN2_RPM - PRV_FAN2_RPM) == -2000) begin
            DATA_IN2 = REF_DATA2[CNT];
        end
    end

    always @(*) begin
        if      ((FAN3_RPM - PRV_FAN3_RPM) == 2000) begin
            DATA_IN3 = REF_DATA1[CNT];
        end
        else if ((FAN3_RPM - PRV_FAN3_RPM) == -2000) begin
            DATA_IN3 = REF_DATA2[CNT];
        end
    end

    always @(*) begin
        if      ((FAN4_RPM - PRV_FAN4_RPM) == 2000) begin
            DATA_IN4 = REF_DATA1[CNT];
        end
        else if ((FAN4_RPM - PRV_FAN4_RPM) == -2000) begin
            DATA_IN4 = REF_DATA2[CNT];
        end
    end



    initial begin
        
               LEVER = 0; DIRECTION = 1; nRST2 = 1;     // sets the user's input value to match the STATE UP
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        #19995 DIRECTION = 0;                           // sets the user's input value to match the STATE HOVER
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        
             
        #19995 LEVER = 0; DIRECTION = 2; nRST2 = 1;     // sets the user's input value to match the STATE DOWN
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        #19995 DIRECTION = 0;                           // sets the user's input value to match the STATE HOVER
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        

        #19995 LEVER = 0; DIRECTION = 3; nRST2 = 1;     // sets the user's input value to match the STATE CW
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        #19995 DIRECTION = 0;                           // sets the user's input value to match the STATE HOVER
        #8     nRST2 = 0;
        #7     nRST2 = 1;


        #19995 LEVER = 0; DIRECTION = 4; nRST2 = 1;     // sets the user's input value to match the STATE CCW
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        #19995 DIRECTION = 0;                           // sets the user's input value to match the STATE HOVER
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        

        #19995 LEVER = 1; DIRECTION = 1; nRST2 = 1;     // sets the user's input value to match the STATE FORWARD
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        #19995 DIRECTION = 0;                           // sets the user's input value to match the STATE HOVER
        #8     nRST2 = 0;
        #7     nRST2 = 1;


        #19995 LEVER = 1; DIRECTION = 2; nRST2 = 1;     // sets the user's input value to match the STATE BACKWARD
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        #19995 DIRECTION = 0;                           // sets the user's input value to match the STATE HOVER
        #8     nRST2 = 0;
        #7     nRST2 = 1;


        #19995 LEVER = 1; DIRECTION = 3; nRST2 = 1;     // sets the user's input value to match the STATE RIGHT
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        #19995 DIRECTION = 0;                           // sets the user's input value to match the STATE HOVER
        #8     nRST2 = 0;
        #7     nRST2 = 1;


        #19995 LEVER = 1; DIRECTION = 4; nRST2 = 1;     // sets the user's input value to match the STATE LEFT
        #8     nRST2 = 0;
        #7     nRST2 = 1;
        #19995 DIRECTION = 0;                           // sets the user's input value to match the STATE HOVER
        #8     nRST2 = 0;
        #7     nRST2 = 1;

        
    end


    MODE_FSM Q2(.CLK(CLK),                          // CLK is for clock inputs
                 .nRST(nRST),                       // nRST is for PID module input reset
                 .nRST2(nRST2),                     // nRST2 is for PID module input reset
                 .LEVER(LEVER),                     // LEVER is user's input for which LEVER to choose
                 .DIRECTION(DIRECTION),             // DIRECTION is user's input for the direction of the LEVER
                 .kP(kP),                           // kP is the P_Controller's gain value
                 .kI(kI),                           // kI is the I_Controller's gain value
                 .kD(kD),                           // kD is the D_Controller's gain value
                 .P_POINT(P_POINT),                 // P_POINT is the number of digit under the decimal point of P_Controller's gain value        
                 .D_POINT(D_POINT),                 // D_POINT is the number of digit under the decimal point of D_Controller's gain value
                 .DATA_IN1(DATA_IN1),               // DATA_IN1 is the FAN1's step response output of the total system, it is utilized with to calculate errors in the PID modules
                 .DATA_IN2(DATA_IN2),               // DATA_IN2 is the FAN2's step response output of the total system, it is utilized with to calculate errors in the PID modules
                 .DATA_IN3(DATA_IN3),               // DATA_IN3 is the FAN3's step response output of the total system, it is utilized with to calculate errors in the PID modules
                 .DATA_IN4(DATA_IN4),               // DATA_IN4 is the FAN4's step response output of the total system, it is utilized with to calculate errors in the PID modules
                 .FAN1_RPM(FAN1_RPM),               // FAN1_RPM is FAN1's current MODE's RPM
                 .FAN2_RPM(FAN2_RPM),               // FAN2_RPM is FAN2's current MODE's RPM
                 .FAN3_RPM(FAN3_RPM),               // FAN3_RPM is FAN3's current MODE's RPM
                 .FAN4_RPM(FAN4_RPM),               // FAN4_RPM is FAN4's current MODE's RPM
                 .PRV_FAN1_RPM(PRV_FAN1_RPM),       // PRV_FAN1_RPM is FAN1's past MODE's RPM
                 .PRV_FAN2_RPM(PRV_FAN2_RPM),       // PRV_FAN2_RPM is FAN2's past MODE's RPM
                 .PRV_FAN3_RPM(PRV_FAN3_RPM),       // PRV_FAN3_RPM is FAN3's past MODE's RPM
                 .PRV_FAN4_RPM(PRV_FAN4_RPM),       // PRV_FAN4_RPM is FAN4's past MODE's RPM
                 .PID_OUT1(PID_OUT1),               // PID_OUT1 is FAN1's output value of PID Control calculation
                 .PID_OUT2(PID_OUT2),               // PID_OUT2 is FAN2's output value of PID Control calculation
                 .PID_OUT3(PID_OUT3),               // PID_OUT3 is FAN3's output value of PID Control calculation
                 .PID_OUT4(PID_OUT4)                // PID_OUT4 is FAN4's output value of PID Control calculation
                                );
                                                            

endmodule
