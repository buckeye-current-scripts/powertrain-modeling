function [GPS_LLA] = removeGPSPoints(GPS_LLA)

% Open figure
h = figure();
geoshow(GPS_LLA.lat,GPS_LLA.lon)

% Update data cursor to show indices
dcm = datacursormode(h);
dcm.UpdateFcn = @updateDataCursor;

% Specify which points to remove
i = input('First index: ');
j = input('Last index: ');
GPS_LLA.lat(i:j) = [];
GPS_LLA.lon(i:j) = [];
GPS_LLA.alt(i:j) = [];

% Close figure
close(h)

end