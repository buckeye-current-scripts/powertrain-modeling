%% Single Speed Gear Optimization

% Add Initialization Folder to Path
addpath('./Initialization')
run Init_FLUIDS;

%Calculates the fastest gear ratio for a given electric motor
optimize_gearing = 1;

%Initial Conditions
maxAvgVelocity = 0;
Best_Rear_Sprocket = 0;
i=0;

%Vector of teeth for rear sprocket
for Rear_Sprocket = 21:110

i = i+1; %Index increases

%Set all gears equal to rear sprocket since it is single speed
Rear_Sprocket_FirstGear_Optimize = Rear_Sprocket;
Rear_Sprocket_SecondGear_Optimize = Rear_Sprocket;

%Run model
sim('BuckeyeCurrent_Simulation');

%Check if Velocity was faster than fastest so far
if mean(Veh_Velocity) > maxAvgVelocity
    maxAvgVelocity = mean(Veh_Velocity);
    Best_Rear_Sprocket = Rear_Sprocket;
    EnergyReq = Batt_Energy(end);
    distance = Veh_Distance;
    velocity = Veh_Velocity;
end

Avg_Vel(i) = mean(Veh_Velocity);
Gear_Ratio(i) = Rear_Sprocket/21;

end

figure()
plot(distance,velocity);

Avg_Vel = Avg_Vel.*2.236936;

figure()
plot(Gear_Ratio,Avg_Vel,'linewidth',2)
ylabel('Average Speed [mph]')
xlabel('Gear Ratio [-]')
clearvars -except maxAvgVelocity Best_Rear_Sprocket EnergyReq reqpower