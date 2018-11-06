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
f1 = figure('color',[1 1 1]);
title('Velocity Comparison');
h(1) = plot(Veh_Distance,Veh_Velocity);
%Should also plot the entire velocity profile to see how far we made it,
%need to figure out how to export this from simulink or load it
%automatically here
set(h(1),'linewidth',2);
ylabel('Velocity (m/s');
xlabel('Distance (m)');
legend('Simulated Velocity');


%Pack Voltage, Current, Power, Energy, SOC -- Maybe make these on the same
%figure but different plots, if you google 'matlab subplot' that'd help
f2 = figure('color',[1 1 1]);
title('Pack Performance');
ax(1) = subplot(311);
h(1) = plot(Batt_Voltage);
hold on;
grid on;
h(2) = plot(Batt_Current);
ylabel('Voltage/Current (V/A)');
yyaxis right
h(3) = plot(Batt_Power);
set(h(1),'linewidth',2);
set(h(2),'linewidth',2);
set(h(3),'linewidth',2);
legend('Pack Voltage','Pack Current','Pack Power','Location','northwest')
ylabel('Power (kW)')
xlabel('Time (s)')

ax(2) = subplot(312);
h(1) = plot(Batt_SOC);
hold on;
grid on;
ylabel('SOC');
yyaxis right
h(2) = plot(Batt_Energy);
ylabel('Energy Used kWh');
set(h(1),'linewidth',2);
set(h(2),'linewidth',2);
legend('Pack SOC','Energy Useage','Location','northwest')
xlabel('Time (s)')

ax(3) = subplot(313);
h(1) = plot(Batt_TerminalVoltage);
set(h(1),'linewidth',2);
ylabel('Terminal Voltage (V)');
xlabel('Time (s)');
legend('Terminal Voltage');
linkaxes(ax,'x')

%Motor torque, speed

%Anything else you think would be interesting

figure('color', [1 1 1])
title('IOM Current Profile - Unfiltered')
yyaxis left
plot(Batt_Current);
hold on;
ylabel('Current [A]')
yyaxis right
plot(Veh_Velocity);
plot(Target_Velocity);
ylabel('Speed [m/s]');
xlabel('Time [s]');
legend('Pack Current','Simulated Velocity','Target Velocity')