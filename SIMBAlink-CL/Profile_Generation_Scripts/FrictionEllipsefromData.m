%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Friction Ellipse Generator
% Generates Friction Ellipse based on race data
% Created by Zach Salyer - 2/3/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

addpath('./RaceData')
%% Load Race Data
Data = csvread('ZachJacobs_CBR600RR_FullRace_062914_MODIFIED.csv');
%List order of inputs
% 1.) Lateral, g
% 2.) Longitudinal, g
% 3.) Lean Angle, deg
%% Generate Ellipse
figure();
xlabel('Lateral Acceleration [g]')
ylabel('Longitudinal Acceleration [g]')
hold on;

for i=1:length(Data(:,1))
    plot(Data(i,1),Data(i,2),'.')
end

figure();
xlabel('Lateral Acceleration [g]')
ylabel('Lean Angle [deg]')
hold on;

for i=1:length(Data(:,1))
    plot(Data(i,1),Data(i,3),'.')
end

%% Sort Data
Data = sortrows(Data,1);
