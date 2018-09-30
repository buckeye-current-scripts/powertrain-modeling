%script generates motor and motor controller profiles based upon common specs

clear

%ENTER PROFILE NAME:
folderName = 'Electric_Machine_Data\';

profileName = 'test3_mc_em_combo.mat';

%MOTOR PARAMETER INPUT-------------
%----------------------------------
Number_of_Motors = 3;

motor_kv = 75;
motor_torque_per_A = 0.13;
peak_motor_current = 300;
peak_motor_power_kw = 15;
peak_motor_voltage = 60;

motor_efficiency = 0.88;
motor_mass_kg = 12.7;
motor_specific_heatCap = 0.3;
motor_coolingSys_heatCap = 800;
%----------------------------------
%----------------------------------

%MC PARAMETER INPUT-------------
%----------------------------------
peak_mc_current = 400;
peak_mc_voltage = 56;
peak_mc_power_kw = 19;

mc_efficiency = 0.94;
mc_mass_kg = 12.7;
mc_specific_heatCap = 0.3;
mc_coolingSys_heatCap = 600;
%----------------------------------
%----------------------------------

%Profile Generation----------------------------------
if peak_motor_voltage <= peak_mc_voltage
    peak_voltage = peak_motor_voltage;
else
    peak_voltage = peak_mc_voltage;
end

if peak_motor_current <= peak_mc_current
    peak_current = peak_motor_current;
else
    peak_current = peak_mc_current;
end

if peak_motor_power_kw <= peak_mc_power_kw
    peak_power_kw = peak_motor_power_kw;
else
    peak_power_kw = peak_mc_power_kw;
end

max_no_load_motor_rpm = motor_kv * peak_voltage;
peak_motor_torque = motor_torque_per_A * peak_current;
field_weakening_rpm = (30*peak_power_kw*1000)/(3.14*peak_motor_torque);
field_weakening_motor_torque_slope = peak_motor_torque / (field_weakening_rpm - max_no_load_motor_rpm);

N_RPM(1) = 0;
T_max_Peak(1) = peak_motor_torque;
motor_power(1) = 0;
for i=2:1:45 
    N_RPM(i) = (i-1)*250;
    if N_RPM(i) < field_weakening_rpm
        T_max_Peak(i) = peak_motor_torque;
        motor_power(i) = (N_RPM(i)*T_max_Peak(i)*3.14)/(30*1000);
    else
        for j=i:1:45
            T_max_Peak(j) = T_max_Peak(j-1) + 250*field_weakening_motor_torque_slope;
            N_RPM(j) = (j-1)*250;
            motor_power(j) = (N_RPM(j)*T_max_Peak(j)*3.14)/(30*1000);
            if T_max_Peak(j) <= 0 || (field_weakening_motor_torque_slope >= 0)
                T_max_Peak(j) = 0;
                motor_power(j) = 0;
            else
            end
            
        end
    end
end

motor_power = Number_of_Motors.*motor_power;

%define electric motor profile-----------------
EM.N_RPM = N_RPM;
EM.T_min_Peak = Number_of_Motors*(-1).*T_max_Peak;
EM.T_max_Peak = Number_of_Motors.*T_max_Peak;
EM.eff = motor_efficiency;
EM.specificHeatCap = motor_specific_heatCap;
EM.COOLSYS_heatCap = Number_of_Motors*motor_coolingSys_heatCap;
EM.torqueConstant = motor_torque_per_A;
EM.kv = motor_kv;
EM.mass_kg = Number_of_Motors*motor_mass_kg;

%define motor controller profile---------------
MC.eff = mc_efficiency;
MC.specificHeatCap = mc_specific_heatCap;
MC.COOLSYS_heatCap = Number_of_Motors*mc_coolingSys_heatCap;
MC.mass_kg = Number_of_Motors*mc_mass_kg;

%save new profile
saveName = strcat(folderName, profileName);
save(saveName, 'EM', 'MC');

%plot torque curve as verification
figure;
plot(EM.N_RPM, EM.T_max_Peak);
hold on;
plot(EM.N_RPM, EM.T_min_Peak);
plot(EM.N_RPM, motor_power);
hold off;

%output peak power as a check
Peak_Motor_Power = max(motor_power)