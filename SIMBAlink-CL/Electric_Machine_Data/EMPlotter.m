%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMPlotter
% Plots interesting data from Motor Parameters
% Created by Zach Salyer: 1/31/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%% Load Desired data
load parker210-100P6_GenericController_600V;


%% Plots

%Create 2-D contour plot of Losses to show magnitude
[C,h] = contour(EM.RPMLookup,EM.TorqueLookup,EM.Losses_W);
clabel(C,h)
ylabel('Torque [N-m]')
xlabel('Speed [rpm]')
title('Electric Machine Losses [W]')

hold on;
%% Plot Different Simulated Operating Points of Electric Machine
% load Parker210-100_IOM_Torque+Speed_FullPower;
% FullPower = plot(Motor_RPM,Motor_Torque,'.','MarkerSize',8);
% AvgFullPower_HeatRejection = sum(Motor_Heat_Rejection_W)/length(Motor_Heat_Rejection_W);
% 
% load Parker210-100_IOM_Torque+Speed_80PercPower;
% LowPower = plot(Motor_RPM,Motor_Torque,'.','MarkerSize',8);
% AvgLowPower_HeatRejection = sum(Motor_Heat_Rejection_W)/length(Motor_Heat_Rejection_W);
% 
% legend([FullPower LowPower],['Full Power - Average Heat Rejection: ' num2str(AvgFullPower_HeatRejection) ' W'],['80 % Power - Average Heat Rejection: ' num2str(AvgLowPower_HeatRejection) ' W']);

%% Plot Peak/Continuous Power of EM
FullPower = plot(EM.N_RPM,EM.T_max_Peak,'linewidth',2);

LowPower = plot(EM.N_RPM,EM.T_max_cont,'linewidth',2);

legend([FullPower LowPower],'Peak Power','Continuous Power');