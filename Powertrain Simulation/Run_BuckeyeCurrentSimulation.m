%*************************************************************************
%Run Simulation and Process Results
%Make sure Simulink model has parameters you want to be set: what
%velocity proifle to use, elevation profile, motor you want to use, gearing, etc.

%*************************************************************************
%Clear Variables and Screen and close graphs
clear; clc; close;

%Turn optimization off for gearing
optimize_gearing = 0; %Set to Zero so that whatever gears are specified in simulation are used
Rear_Sprocket_FirstGear_Optimize = 1; %These need to be declared so they exist even though they aren't used
Rear_Sprocket_SecondGear_Optimize = 1;

%% Run Model
sim('BuckeyeCurrent_Simulation');

%% Process Results and Plotting --- Chris add your plots here

%Vehicle Speed vs Distance and Target Speed Versus Distance

%Pack Voltage, Current, Power, Energy, SOC -- Maybe make these on the same
%figure but different plots, if you google 'matlab subplot' that'd help

%Motor torque, speed

%Anything else you think would be interesting