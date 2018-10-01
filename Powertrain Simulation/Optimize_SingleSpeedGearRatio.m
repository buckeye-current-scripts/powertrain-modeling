%% Single Speed Gear Optimization
%Calculates the fastest gear ratio for a given electric motor
optimize_gearing = 1;

%Initial Conditions
maxAvgVelocity = 0;
Best_Rear_Sprocket = 0;

%Vector of teeth for rear sprocket
for Rear_Sprocket = 21:75

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

end

figure()
plot(distance,velocity);
clearvars -except maxAvgVelocity Best_Rear_Sprocket EnergyReq reqpower