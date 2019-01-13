%% Initialization file for selecting Circuit
%% Circuit Velocity Profiles
if Circuit_Selection == 1
    load Velocity_Profiles/IOM_VelocityProfile;
    load Elevation_Profiles/IOM_ElevationProfile;
elseif Circuit_Selection == 2
    load Velocity_Profiles/QuarterMile_VelocityProfile;
    load Elevation_Profiles/QuarterMile_ElevationProfile;
elseif Circuit_Selection == 3
    load Velocity_Profiles/PPIHC_VelocityProfile;
    load Elevation_Profiles/PPIHC_ElevationProfile;
end