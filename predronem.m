%vel of drone, x,y,z position errors rover to drone - predictors
%output is posn. of rover - response 
%response is 0 to 1.6 m/s increase and 1.6 to 0 decrease during time
%period

%-----pre processing------
clc;
clear all;
close all;
rc = load("landing.mat",'GPS','POS');
%GPS laty -8 , longx -9 , spd - 11 , vel and posn of drone
%posn errors of rover ???
x = [ones(1,20)*77.56341 linspace(77.56341,77.56358,136)];
y = [ones(1,15)*13.027220 linspace(13.027220,13.027262,141)];
xdat = reshape(rc.POS(1:1:156,4), 1, 156); %rc.POS(:,4) is x of drone
ydat = reshape(rc.POS(1:1:156,3), 1, 156); %rc.POS(:,3) is y of drone
%dist = [sqrt(((xdat - x).^2) + ((ydat - y).^2))];
distx = [sqrt((xdat - x).^2)];
disty = [sqrt((ydat - y).^2)];
x1 = reshape(distx,156,1); %xerror
x2 = reshape(disty,156,1); % yerror
x3 = rc.GPS(1:1:156,11); % speed of drone
y = [linspace(0, 1.6, 30) ones(1,100)*1.6 linspace(1.6, 0, 26)]; %speed response of rover
y1 = reshape(y, 156,1);

X = [x1,x2,x3];
mdl = fitlm(X,y1)
YHat = predict(mdl,X) 
plot(rc.POS(1:1:156,2),YHat)