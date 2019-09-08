%% Convert time and velocity to distance
dist(1) = 0;

for i=2:length(data.time)
    dist(i) = dist(i-1)+data.Vehicle_Speed_ms(i)*0.1;
end