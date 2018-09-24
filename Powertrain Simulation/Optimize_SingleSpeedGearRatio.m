%% Single Speed Gear Optimization
%Calculates the fastest gear ratio for a given electric motor

%Initial Conditions
maxAvgVelocity = 0;
Best_Rear_Sprocket = 0;

%Vector of teeth for rear sprocket
for Rear_Sprocket = 21:75

%Set all gears equal to rear sprocket since it is single speed
Rear_Sprocket_FirstGear = Rear_Sprocket;
Rear_Sprocket_SecondGear = Rear_Sprocket;

%Run model
sim('BuckeyeCurrent_Simulation_gearoptimization');

%Check if Velocity was faster than fastest so far
if mean(Vehicle_Velocity) > maxAvgVelocity
    maxAvgVelocity = mean(Vehicle_Velocity);
    Best_Rear_Sprocket = Rear_Sprocket;
    EnergyReq = Energy_req(end);
    distance = Vehicle_Distance;
    velocity = Vehicle_Velocity;
end

end

figure()
plot(distance,velocity);
clearvars -except maxAvgVelocity Best_Rear_Sprocket EnergyReq reqpower