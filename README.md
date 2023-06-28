# PID-Controllers-for-Quadrotor-drone-DC-Motors

## A simple proeject written in Verilog using Modelsim. Performs PID calculations based on the RPM difference of DC Motors.
This was a three week project for my "Hardware Programming" course. I implemented the PID control algorithm from another course, "Automatic Control".

## What is included in the Repository

* Design Results (Verilog)
* Design layout, simulations, testbench data (MATLAB) (to be uploaded...)
* Design Report in Word files (to be uploaded...)


## Design Assumptions

Verified only on simulations. This was not implemented on FPGA boards, so I'm unaware of its actual outcome.
The project focuses on performing 9 basic MODE operations specified in the project topic rather than achieving the level of control seen in commercial drones.
It is assumed that the project will strictly follow the procedure outlined for the desired functionalities.
Additionally, this project primarily aims to observe the output of the DC motor when given input in the form of "step input",
therefore, the it will not extensively cover the aerodynamic perspective.


## These are some key features worth marking!

* Controlled by the user input, the MODE_FSM module passes the corresponding RPM difference values to the instantiated subordinate module.
* The robust PID calculation performance despite the input data's non-liear rate of change.
* The outcome of the wave analog(automatic) meeting an error rate of a 0.22% compared to the MATLAB simulation results.


## Verilog Instructions
## MATLAB Instructions
## Future updates to come!!

* Updating the verilog code following the IEEE754 standards, along with C codes for input data modifications for IEEE754 standards.
