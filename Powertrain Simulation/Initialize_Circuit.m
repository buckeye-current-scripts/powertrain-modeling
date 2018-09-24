%% Initialization file for selecting Circuit
%% Circuit Velocity Profiles
        if Circuit_Selection == 1
            load Velocity_Profiles/IOM_VelocityProfile;
        elseif Circuit_Selection == 2
            load Velocity_Profiles/QuarterMile_VelocityProfile;
        end