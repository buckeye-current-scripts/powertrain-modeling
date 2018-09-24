%% Two Speed Gear Optimization
%Calculates the fastest gear ratio for a given electric motor
%Note: it doesnt matter whether first or second gear gives more torque, the
%gear with the larger number of teeth is first and lower is second

%Set switchpoint b/w first and second at fastest for single speed?

%Initial Conditions
maxAvgVelocity = 0;
Best_Rear_Sprocket = 0;

%Vector of teeth for rear sprocket
for Rear_Sprocket_FirstGear = 40:75
    
    %Vector of teeth for second gear
    for Rear_Sprocket_SecondGear = 21:70
        %Run model
        sim('BuckeyeCurrent_Simulation_gearoptimization');

        %Check if Velocity was faster than fastest so far
        if mean(Vehicle_Velocity) > maxAvgVelocity
            maxAvgVelocity = mean(Vehicle_Velocity);
            maxVelocity = max(Vehicle_Velocity);
            time = tout(end);
            Best_FirstGear = Rear_Sprocket_FirstGear;
            Best_SecondGear = Rear_Sprocket_SecondGear;
            EnergyReq = Energy_req(end);
        end
    end
end