%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizes Rider Model to Match Velocity Distance Profile from Testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Clear Variables and Screen and close graphs
clear; clc; close all;

%Turn optimization off for gearing
optimize_gearing = 0; %Set to Zero so that whatever gears are specified in simulation are used
Rear_Sprocket_FirstGear_Optimize = 1; %These need to be declared so they exist even though they aren't used
Rear_Sprocket_SecondGear_Optimize = 1;

% Add Initialization Folder to Path
addpath('./Initialization')
run Init_FLUIDS;
%% Load Data Used for Comparison
load Velocity_Profiles\PPIHC_2017_RW3x2;

%Convert Velocity-Time to Velocity Distance
d_cyc(1) = 0;
for i=2:length(t_cyc)
    d_cyc(i) = d_cyc(i-1) + v_cyc(i)*(t_cyc(i)-t_cyc(i-1));
end
d_cyc = d_cyc';

%% Simulate Motorcycle Performance
sim('BuckeyeCurrent_Simulation');

figure()
h(1) = plot(Veh_Distance,Veh_Velocity);
set(h(1),'linewidth',2);
ylabel('Velocity (m/s');
xlabel('Distance (m)');
hold on;
h(2) = plot(d_cyc,v_cyc);
set(h(2),'linewidth',2);
legend('Simulated Velocity','Measured Velocity');