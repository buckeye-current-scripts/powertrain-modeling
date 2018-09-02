clear all;
clc;

%Load in excel file Motor and controller pairing 2018-19
[motor_num, motor_txt, motor_raw] = xlsread('Motor_data.xlsx');
[ctrl_num, ctrl_txt, ctrl_raw] = xlsread('Controller_data.xlsx');

%Sort each motor/controller into its own mat file
[row,col] = size(motor_txt);

for a = 2:row
    filename = motor_txt(a,1);
    motor.PolePair = motor_raw(a,2);
    motor.MaxBusVoltage = motor_raw(a,3);
    motor.MaxPeakPhaseCurrent = motor_raw(a,4);
    motor.MaxContPhaseCurrent = motor_raw(a,5);
    motor.PeakTorque = motor_raw(a,6);
    motor.ContTorque = motor_raw(a,7);
    motor.MotorKv = motor_raw(a,8);
    motor.MotorKt = motor_raw(a,9);
    motor.PeakPower = motor_raw(a,10);
    motor.ContPower = motor_raw(a,11);
    motor.MaxMechSpeed = motor_raw(a,12);
    motor.Weight = motor_raw(a,13);
    motor.OuterFrameWidth = motor_raw(a,14);
    motor.RotorLength = motor_raw(a,15);
    save(sprintf('Motor_%s.mat',filename{1}),'motor');
end


[row,col] = size(ctrl_txt);

for b = 2:row
    filename = ctrl_txt(b,1);
    %controller.PeakPower = ctrl_raw(b,2);
    %controller.ContPower = ctrl_raw(b,3);
    controller.DCVoltage = ctrl_raw(b,4);
    controller.MaxOutputCurrent = ctrl_raw(b,5);
    controller.ContOutputCurrent = ctrl_raw(b,6);
    controller.SwitchingFreq = ctrl_raw(b,7);
    controller.MaxCommutationFreq = ctrl_raw(b,8);
    controller.EstimationBit = ctrl_raw(b,9);
    save(sprintf('Controller_%s.mat',filename{1}),'controller');
end






