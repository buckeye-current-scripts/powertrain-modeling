%Velocity Profile from Corner-Radius Profile - Buckeye Current
%Created by Zach Salyer - 7/11/2018

clearvars;
clc;
close all;

%% Load Corner-Radius Profile Script
[file, path] = uigetfile();
filename = fullfile(path, file);
Data = importdata(filename); 
CornerRadius(:,1) = Data.distance;                                    %Must Make Corner-Radius is in array with distance in first column and radius in second
CornerRadius(:,2) = Data.radius;
%% Find Apexes of Track
%Find troughs of corner radius profile to find smallest radii aka the apex
InverseRadii = 1./CornerRadius(:,2);
[apex_radius, locs] = findpeaks(InverseRadii,CornerRadius(:,1));

%Locs returns x value, so find all indexes of values
for j = 1:length(locs)
    locs(j) = find(CornerRadius(:,1) == locs(j));
end

for n = 1:length(locs) %Change from inverse radius back to actual radius
    apex_radius(n,1) = CornerRadius(locs(n,1),2);
end
%% Load Race Data for Friction Ellipse
Data = csvread('ZachJacobs_CBR600RR_FullRace_062914_MODIFIED.csv');
%% Create acceleration limits

% Establish friction elipse acceleration limits - values chosen based on common racebike values found
longlim = 9.81; %Acceleration and braking limit (m/s^2)
latlim = 9.81*1.28; %Lateral acceleration at 52 deg lean angle (m/s^2) - 2017 spec was 55 deg true and 49.5 effective, but this didn't account for rider changing position and changing CG so 52 deg effective should be achievable

% At any time the acceleration must be less than sqrt(longacc^2 + latacc^2) - this is  the friction elipse

%% Calculate maximum possible Speed at all apexes
apex_velocity = zeros(length(apex_radius),1);

for n = 1:length(apex_radius)
    apex_velocity(n) = sqrt(latlim*apex_radius(n));
end

%% Use apex velocities as initial conditions/limits to calc velocity profile
velocity_profile = zeros(length(CornerRadius(:,1)),1); %Should be a velocity for each distance point

%Set velocities of each apex
velocity_profile(locs) = apex_velocity';

%% Use apex velocities and intial velocity of zero to populate velocity profile
velocity_profile_braking = velocity_profile;
velocity_profile_acceleration = velocity_profile;
n=0;

while n<length(locs)
    n=n+1;
    flag = 0; %Reset flag
    
    %Case of start line to first apex
   if n == 1 
       %Sets velocities based on braking into apex ------------------------
       for j = locs(n):-1:2
           
           %Calculate lateral acceleration of point before apex
           lat_g(j) = (velocity_profile_braking(j)^2)/CornerRadius(j,2);
           %Calculate longitudinal acceleration available at previous point
           long_g(j) = sqrt((1-(lat_g(j)^2)/(latlim^2))*(longlim^2));
           %Apply acceleration for distance until previous point
           velocity_profile_braking(j-1) = sqrt(velocity_profile_braking(j)^2 + 2*long_g(j)*abs((CornerRadius(j-1,1)-CornerRadius(j,1))));
       end
       
       %Find Velocities based on accelerating towards apex ----------------
       for j = 1:locs(n)-1
           if velocity_profile_acceleration(j) < velocity_profile_braking(j) %if this is false then we need to start braking and if we keep accelerating we will get imaginary numbers speed is too fast for radius
           %Calculate lateral acceleration of point before apex
           lat_g(j) = (velocity_profile_acceleration(j)^2)/CornerRadius(j,2);
           %Calculate longitudinal acceleration available at previous point
           long_g(j) = sqrt((1-lat_g(j)^2/latlim^2)*longlim^2);
           %Apply acceleration for distance until previous point
           velocity_profile_acceleration(j+1) = sqrt(velocity_profile_acceleration(j)^2 + 2*long_g(j)*abs((CornerRadius(j,1)-CornerRadius(j+1,1))));
           else
           velocity_profile_acceleration(j+1) = velocity_profile_acceleration(j);
           end
       end
       
%Determine velocity profile between these points  
        %Find smallest difference between acc and braking profiles
        velocity_dif = abs(velocity_profile_acceleration - velocity_profile_braking);
        velocity_dif = velocity_dif(1:locs(n));
        %Find index of smallest difference
        [~,change_index] = (min(velocity_dif));
        %Check if velocity of acc of this point is greater than next apex velocity
        if velocity_profile(locs(n)) > velocity_profile_acceleration(change_index)
           %This means we cannot accelerate to the maximum speed the corner can be taken at in time
           velocity_profile(1:locs(n)) = velocity_profile_acceleration(1:locs(n));
        else
           if velocity_profile_acceleration(change_index) < velocity_profile_braking(change_index)
            velocity_profile(1:change_index) = velocity_profile_acceleration(1:change_index);
            velocity_profile(change_index:locs(n)) = velocity_profile_braking(change_index:locs(n));
           else
            velocity_profile(1:change_index-1) = velocity_profile_acceleration(1:change_index-1);
            velocity_profile(change_index-1:locs(n)) = velocity_profile_braking(change_index-1:locs(n));
           end
        end

        
   %Cases between apex points 
   else
      
       velocity_profile_acceleration = velocity_profile; %reset to correct velocity profiles
       velocity_profile_braking = velocity_profile;
       
       %Sets velocities based on braking into apex ------------------------
       for j = locs(n):-1:locs(n-1)+1
           %Calculate lateral acceleration of point at apex
           lat_g = (velocity_profile_braking(j)^2)/CornerRadius(j,2);
           %Calculate longitudinal acceleration available at previous point
           long_g = sqrt((1-(lat_g^2)/(latlim^2))*(longlim^2));
            
           if ~isreal(long_g)  %This can happen if lat_g and latlim are slightly different values (ie corner radius slightly different)
               long_g = 0;
           end
           
           %Apply acceleration for distance until previous point
           velocity_profile_braking(j-1) = sqrt(velocity_profile_braking(j)^2 + 2*long_g*abs((CornerRadius(j-1,1)-CornerRadius(j,1))));
           %Check if we are going too fast as we enter the previous apex
           if ~isreal(velocity_profile_braking(j-1))
               velocity_profile_braking(j-1) = velocity_profile_braking(j);
           end
           
           %Check if we are going to fast to decelerate to next apex
           if j == locs(n-1)+1
            if velocity_profile_braking(j-1) < velocity_profile(j-1)
               velocity_profile(j-1) = velocity_profile_braking(j-1); %Reset apex value so you can brake fast enough for following apex
               n= n-2; %Subtract 2 so when you add 1 you will be recalculating from previous apex
               flag = 1; %No need to finish this iteration
            end
           end
       end
       
 if flag ==1
     continue;
 end
       
       for j = locs(n-1):locs(n)
           if velocity_profile_acceleration(j) < velocity_profile_braking(j) %if this is false then we need to start braking and if we keep accelerating we will get imaginary numbers speed is too fast for radius
           %Calculate lateral acceleration of point before apex
           lat_g = (velocity_profile_acceleration(j)^2)/CornerRadius(j,2);
           %Calculate longitudinal acceleration available at previous point
           long_g = sqrt((1-lat_g^2/latlim^2)*longlim^2);
           if ~isreal(long_g)  %This can happen if lat_g and latlim are slightly different values (ie corner radius slightly different)
               long_g = 0;
           end
           %Apply acceleration for distance until previous point
           velocity_profile_acceleration(j+1) = sqrt(velocity_profile_acceleration(j)^2 + 2*long_g*abs((CornerRadius(j,1)-CornerRadius(j+1,1))));
           else
           velocity_profile_acceleration(j+1) = velocity_profile_acceleration(j);
           end
       end
       
%Determine velocity profile between these points  
        %Find smallest difference between acc and braking profiles
        velocity_dif = abs(velocity_profile_acceleration(locs(n-1):locs(n)) - velocity_profile_braking(locs(n-1):locs(n)));
        %Find index of smallest difference
        [~,change_index] = (min(velocity_dif));
        change_index = change_index + locs(n-1)-1; %Need to set to correct index in velocity_profile
        %Check if velocity of acc of this point is greater than next apex velocity
        if velocity_profile(locs(n)) > velocity_profile_acceleration(change_index)
           %This means we cannot accelerate to the maximum speed the corner can be taken at in time
           velocity_profile(locs(n-1)+1:locs(n)) = velocity_profile_acceleration(locs(n-1)+1:locs(n));
        else
           if velocity_profile_acceleration(change_index) < velocity_profile_braking(change_index)
            velocity_profile(locs(n-1)+1:change_index) = velocity_profile_acceleration(locs(n-1)+1:change_index);
            velocity_profile(change_index:locs(n)) = velocity_profile_braking(change_index:locs(n));
           else
            velocity_profile(locs(n-1)+1:change_index-1) = velocity_profile_acceleration(locs(n-1)+1:change_index-1);
            velocity_profile(change_index-1:locs(n)) = velocity_profile_braking(change_index-1:locs(n));
           end
        end
     
        
   end
end

%% Accelerating from final apex to finish line
velocity_profile_acceleration = velocity_profile; %reset to correct velocity profiles
for j = locs(end):1:(length(CornerRadius(:,1))-1)
      lat_g = (velocity_profile_acceleration(j)^2)/CornerRadius(j,2);
      %Calculate longitudinal acceleration available at previous point
      long_g = sqrt((1-lat_g^2/latlim^2)*longlim^2);
      
      if ~isreal(long_g)
          long_g = 0;
      end
      %Apply acceleration for distance until previous point
      velocity_profile_acceleration(j+1) = sqrt(velocity_profile_acceleration(j)^2 + 2*long_g*abs((CornerRadius(j,1)-CornerRadius(j+1,1))));
    
end

%Set velocity profile to end
velocity_profile(locs(end):length(CornerRadius(:,1))) = velocity_profile_acceleration(locs(end):length(CornerRadius(:,1)));

%% Plot Friction Ellipse
%Calc lat acceleration based on velocity profile and radius at that point
lat_g = (velocity_profile.^2)./(CornerRadius(:,2));
%How to calc long acc?  Can use formula but that isn't the actual applied at each point

%% Plot Velocity Profile
figure(1)
plot(CornerRadius(:,1),velocity_profile,'linewidth',2);
xlabel('Distance (m)');
ylabel('Velocity (m/s)');
title('IOM Velocity Profile')
hold on;
%% Plot lean angle at each point
lean_angle = atan((lat_g./9.81)).*360./2./pi; %Calc lean angle in deg based on long acc
yyaxis right
plot(CornerRadius(:,1),lean_angle);
xlabel('Distance (m)');
ylabel('Lean Angle (deg)');

%% Lap Time
LapTime = CornerRadius(end,1)/mean(velocity_profile)/60; %In minutes

