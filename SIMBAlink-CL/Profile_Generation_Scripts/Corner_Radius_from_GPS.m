close all
clear
clc

%% Select GPS Data
% Launch data selection prompt
waitfor(msgbox('Press OK then select the GPS data file in MATLAB format.','Import Data File'));
[file_in.name,file_in.path] = uigetfile('.mat');
load(strcat(file_in.path,file_in.name));

% Plot LLA Data
geoshow(GPS_LLA.lat,GPS_LLA.lon)

%% Convert from LLA to Flat Earth
% Input arguments
fun_in.lla = [GPS_LLA.lat GPS_LLA.lon GPS_LLA.alt]; % m-by-3 array of geodetic coordinates (latitude, longitude, and altitude), in [degrees, degrees, meters]
fun_in.llo = [min(GPS_LLA.lat) min(GPS_LLA.lon)]; % reference location, in degrees, of latitude and longitude, for the origin of the estimation and the origin of the flat Earth coordinate system
fun_in.psio = 0; % angular direction of flat Earth x-axis (degrees clockwise from north)
fun_in.href = 0; % reference height from the surface of the Earth to the flat Earth frame with regard to the flat Earth frame, in meters

flat = lla2flat(fun_in.lla,fun_in.llo,fun_in.psio,fun_in.href);
flat = [flat(:,2) flat(:,1) -flat(:,3)];

% %% Interpolate Flat Earth Data
cumSum = cat(1,0,cumsum(sqrt(sum(diff(flat).^2,2))));
flat_interp = interp1(cumSum,flat,linspace(0,cumSum(end),10000),'pchip');
cumSum_interp = cat(1,0,cumsum(sqrt(sum(diff(flat_interp).^2,2))));

% Plot interpolated flat earth data
figure('color','w')
scatter(flat_interp(:,1),flat_interp(:,2),[],flat_interp(:,3),'fill')
xlabel('X-Pos. [m] (from Lon.)')
ylabel('Y-Pos. [m] (from Lat.)')
cb.handle = colorbar;
cb.titleHandle = get(cb.handle,'Title');
cb.titleString = 'Altitude [m]';
set(cb.titleHandle,'String',cb.titleString);

% Export struct
GPS_Flat_Interp.x = flat_interp(:,1);
GPS_Flat_Interp.y = flat_interp(:,2);
GPS_Flat_Interp.z = flat_interp(:,3);
waitfor(msgbox('Press OK then choose location and name used to save flat eath data file.','Export Data File'));
[file_out.name,file_out.path] = uiputfile('*.mat');
file_out.address = fullfile(file_out.path,file_out.name);
save(file_out.address,'GPS_Flat_Interp')

%% Compute Corner Radius
% Filter inputs
filt.corner_rad_mn = 7; % minimum corner radius [m]
filt.lat_accel_mx = 1.5; % max allowable lateral acceleration [g]
filt.pt_ct_corner = 20; % number of points used in corner radius cicle fit
filt.pt_ct_roll = 5; % size of filtering window
filt.std_dev = 0.8; % number of std dev allowed from rolling ave

% Curve fit constant radius to rolling point group
fit.pt_ct = filt.pt_ct_corner;
n = length(cumSum_interp);
for i = 1:n
    if i < fit.pt_ct + 1
        fit.x = GPS_Flat_Interp.y(1:i);
        fit.y = GPS_Flat_Interp.y(1:i);
    else
        fit.x = GPS_Flat_Interp.x((i - fit.pt_ct):i);
        fit.y = GPS_Flat_Interp.y((i - fit.pt_ct):i);
    end
    fit.A = [fit.x fit.y ones(size(fit.x))]\(-(fit.x.^2 + fit.y.^2));
    fit.R(1,i) = sqrt((fit.A(1)^2 + fit.A(2)^2)/4 - fit.A(3));
end

% Filter corner radii below minimum allowed
k = 1;
for i = 1:n
    if fit.R(i) >= filt.corner_rad_mn
        fit.R_f(1,k) = cumSum_interp(i);
        fit.R_f(2,k) = fit.R(i);
        k = k + 1;
    end
end
fit.R = interp1(fit.R_f(1,:),fit.R_f(2,:),cumSum_interp);

% Filter corner radii outside of 1 standard deviation from rolling average
k = 1;
for i = 1:n
    if i < filt.pt_ct_roll + 1
        fit.R_ave = mean(fit.R(1:i));
        fit.R_std = std(fit.R(1:i));
    else
        fit.R_ave = mean(fit.R((i - filt.pt_ct_roll):i));
        fit.R_std = std(fit.R((i - filt.pt_ct_roll):i));
    end
    if fit.R(i) >= (fit.R_ave - filt.std_dev*fit.R_std) && fit.R(i) <= (fit.R_ave + filt.std_dev*fit.R_std)
        fit.R_ff(1,k) = cumSum_interp(i);
        fit.R_ff(2,k) = fit.R(i);
        k = k + 1;
    end
end

fit.R = interp1(fit.R_ff(1,:),fit.R_ff(2,:),cumSum_interp);

R_n = max(fit.R)./fit.R;
figure('color','w')
plot(GPS_Flat_Interp.x,GPS_Flat_Interp.y)
hold on
plot(GPS_Flat_Interp.x,GPS_Flat_Interp.y+R_n*10)
hold off

% Export corner radius profile
distance = cumSum_interp;
radius = fit.R;

waitfor(msgbox('Press OK then choose location and name used to save the corner radius profile data.','Export Data File'));
[file_out.name,file_out.path] = uiputfile('*.mat');
file_out.address = fullfile(file_out.path,file_out.name);
save(file_out.address,'radius','distance')


