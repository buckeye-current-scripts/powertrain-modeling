%creates CDTS profile from Dist-cornerRad data

maxLatAccel = 9.8;  %max lateral acceleration in m/s^2
maxBrakeAccel = 9.8;    %max braking acceleration in m/s^2

%Set data sets to imported arrays------
Dist = dist_interp_m;
cornerRadius = radius_interp_m;
%--------------------------------------


%calculate max corner speed in m/s
maxCornerSpeed = zeros(length(Dist),1);
for i=1:length(Dist)
    maxCornerSpeed(i) = sqrt(maxLatAccel * cornerRadius(i));
end


%calculate CDTS backwards
CDTS_ms = zeros(length(Dist),1);
CDTS_mph = zeros(length(Dist),1);
CDTS_ms(length(Dist)) = 0;
CDTS_mph(length(Dist)) = 0;
for i=(length(Dist)-1):-1:1
    CDTS_ms(i) = sqrt(CDTS_ms(i+1)^2 + 2 * maxBrakeAccel * (Dist(i+1) - Dist(i)));
    if (CDTS_ms(i) > maxCornerSpeed(i))
       CDTS_ms(i) = maxCornerSpeed(i); 
    end
    CDTS_mph(i) = CDTS_ms(i) * 3600 / 1609.344;
end

%create clock signal array for simulink
simulinkCLOCK(1) = 0;
for i=2:1:length(Dist)
    simulinkCLOCK(i) = simulinkCLOCK(i-1) + 1;
end
     
%write necessary vectors and clear unnecessary-----------
%save to velocity profile--------------------------------
t_cyc = simulinkCLOCK.';
v_cyc = CDTS_ms;
d_cyc = Dist;

clearvars -except t_cyc v_cyc d_cyc






