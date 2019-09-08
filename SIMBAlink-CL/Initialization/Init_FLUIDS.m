%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUCKEYE CURRENT INVERTER THERMAL MANAGEMENT SYSTEM (TMS)
% Initialization of Fluid Parameters
% Created by Prof Canova 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% =================Coefficients for Coolant Properties====================

% Mixture Composition
COOLANT.x_g = 0.1;              % Fraction of glycol in coolant
% Density
COOLANT.rho_w_a = 0.0013;       % Density constant 1
COOLANT.rho_w_b = -2.164e-6;    % Density constant 2
COOLANT.rho_w_c = 3.987e-9;     % Density constant 3
COOLANT.rho_g_a  = 0.000833;    % Glycol Density constant 1
COOLANT.rho_g_b  = -9.313e-8;   % Glycol Density constant 2
COOLANT.rho_g_c  = 1.062e-9;    % Glycol Density constant 3
% Specific Heat Capacity
COOLANT.cp_w_a = 4.044;         % Specific heat constant 1
COOLANT.cp_w_b = 4.85e-4;       % Specific heat constant 2
COOLANT.cp_g_a  = 0.8924;       % Glycol Specific heat constant 1
COOLANT.cp_g_b  = 5.07e-3;      % Glycol Specific heat constant 2
% Dynamic Viscosity
COOLANT.mu_w_a = -27.65;
COOLANT.mu_w_b = 3786;
COOLANT.mu_w_c = 0.03332;
COOLANT.mu_w_d = -2.249e-5;
COOLANT.mu_g_a = -84.16;
COOLANT.mu_g_b = 11480;
COOLANT.mu_g_c = 0.1906;
COOLANT.mu_g_d = -1.714e-4;
% Thermal Conductivity
COOLANT.K_w_a = -0.3838;
COOLANT.K_w_b = 0.005254;
COOLANT.K_w_c = -6.369e-6;
COOLANT.K_g_a = 0.1974;
COOLANT.K_g_b = 2.918e-4;
COOLANT.K_g_c = -3.672e-7; 
 
%% ===============Coefficients for Ambient Air Properties===================
% Specific Heat Capacity
AIR.cpair_a = 3.653;
AIR.cpair_b = -1.337e-3;
AIR.cpair_c = 3.294e-6;
AIR.cpair_d = -1.913e-9;
AIR.cpair_e = 0.2763e-12;
