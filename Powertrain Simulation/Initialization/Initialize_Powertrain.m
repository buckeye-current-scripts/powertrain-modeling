%% Initialization file for selecting Powertrain Components
%% EM Data
        if EM_MC_Selection == 1
            load Electric_Machine_Data\emrax268_PM150DZR;
        elseif EM_MC_Selection == 2
            load Electric_Machine_Data\RemyHVH25090s_nocontrollerlim;
        elseif EM_MC_Selection == 3
            load Electric_Machine_Data\emrax228_Twin;
        elseif EM_MC_Selection == 4
            load Electric_Machine_Data\emrax228_Twin_contpower;
        elseif EM_MC_Selection == 5
            load Electric_Machine_Data\parker210-150Q6_PM150DZR_600V;  
        elseif EM_MC_Selection == 6
            load Electric_Machine_Data\parker210-100P6_GenericController_600V;
            load Thermal_Models\parker210-100P6_ThermalModelParameters;
        end