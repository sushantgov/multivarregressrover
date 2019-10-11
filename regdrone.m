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
% figure('Name', 'x Error between drone and platform')
% plot(rc.POS(1:1:156,2), distx)
% figure('Name', 'y Error between drone and platform')
% plot(rc.POS(1:1:156,2), disty)

x1 = distx; %xerror
x2 = disty; % yerror
x3 = reshape(rc.GPS(1:1:156,11),1, 156); % speed of drone
y = [linspace(0, 1.6, 30) ones(1,100)*1.6 linspace(1.6, 0, 26)]; %speed response of rover
y1 = reshape(y, 156,1);
x4 = x1.*x2;
x5 = x1.*x3;
x6 = x2.*x3;
%X = [ones(156,1) reshape(x1,156,1) reshape(x2, 156,1) reshape(x3,156,1) reshape(x4,156,1) reshape(x5,156,1) reshape(x6,156,1)];
X = [ones(156,1) reshape(x1,156,1) reshape(x2, 156,1) reshape(x4,156,1)];
b = regress(y1,X);

scatter3(x1,x2, y,'filled')
hold on
x1fit = min(x1):100:max(x1);
x2fit = min(x2):10:max(x2);
%x3fit =min(x3):10:max(x3);
[X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
%YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X3FIT + b(5)*X1FIT.*X2FIT + b(6)*X1FIT.*X3FIT + b(7)*X2FIT.*X3FIT;
YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X1FIT.*X2FIT;
mesh(X1FIT,X2FIT,YFIT)
xlabel('predictor1')
ylabel('pred2')
zlabel('vel rover')
view(50,10)
hold off
ypred = predict(,X);
