%% Two Speed Gear Optimization
%Calculates the fastest gear ratio for a given electric motor
%Note: it doesnt matter whether first or second gear gives more torque, the
%gear with the larger number of teeth is first and lower is second
optimize_gearing = 1;

%Initial Conditions
maxAvgVelocity = 0;
Best_Rear_Sprocket = 0;

%Vector of teeth for rear sprocket
for Rear_Sprocket_FirstGear_Optimize = 40:75
    
    %Vector of teeth for second gear
    for Rear_Sprocket_SecondGear_Optimize = 21:70
        %Run model
        sim('BuckeyeCurrent_Simulation');

        %Check if Velocity was faster than fastest so far
        if mean(Veh_Velocity) > maxAvgVelocity
            maxAvgVelocity = mean(Veh_Velocity);
            maxVelocity = max(Veh_Velocity);
            time = tout(end);
            Best_FirstGear = Rear_Sprocket_FirstGear_Optimize;
            Best_SecondGear = Rear_Sprocket_SecondGear_Optimize;
            EnergyReq = Batt_Energy(end);
        end
    end
end

clearvars -except maxAvgVelocity Best_FirstGear Best_SecondGear EnergyReq