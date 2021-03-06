
clear;

sigma = 1.0;

R1 = 1.0;
R2 = 1.0;
% R2 = 2.0;
% R2 = 5.0;

% theta1 = deg2rad(0);
% theta1 = deg2rad(20);
theta1 = deg2rad(30);
% theta1 = deg2rad(50);
% theta1 = deg2rad(80);
% theta2 = deg2rad(0);
% theta2 = deg2rad(20);
theta2 = deg2rad(30);
% theta2 = deg2rad(50);

% V = 0.1;
V = 0.05;
% V = 0.01;
% V = 0.001;

% H = 0.1;
% H = 0.05;
% H = 0.02;
% H = 0.3;
% H = 0.4;
H = 0.5;

bridge = MakeBridge(R1,R2,H,theta1,theta2,V,sigma);

alpha1_lo = nan;
alpha1_hi = nan;

% 
[~,guess] = BridgeForceHR2(R1,R2,H,theta1,theta2,V,sigma);
alpha1 = guess.alpha1;
pguess = guess.pres;

max_step = 50;

for step = 1:max_step
    
    %
    [xs,zs, res] = YLSolvePres2(bridge, alpha1, pguess);
    alpha2 = res.alpha2;
    
    % calc volume
    rs = zs(:,1);
    np = numel(xs);
    
    rm = 0.5 * (rs(1:end-1) + rs(2:end));
    xl = xs(2:end) - xs(1:end-1);
    vol = sum(pi .* rm.^2 .* xl);
    vol1 = SphereCapVolume(R1*sin(alpha1),R1*(1-cos(alpha1)));
    vol2 = SphereCapVolume(R2*sin(alpha2),R2*(1-cos(alpha2)));
    vol = vol - vol1 - vol2;
    
    volerr = vol - V;
    
    disp(['step=',int2str(step),';|vol|=',num2str(volerr)]);
    
    if abs(volerr)/V < 1.0e-6
        disp('volume converged');
        break;
    else
        if vol > V
            alpha1_hi = alpha1;
        else
            alpha1_lo = alpha1;
        end
        
        if isnan(alpha1_lo)
            alpha1 = alpha1 * 0.99;
        elseif isnan(alpha1_hi)
            alpha1 = alpha1 * 1.01;
        else
            alpha1 = 0.5 * (alpha1_hi + alpha1_lo);
        end
    end
end

[ropt,xopt] = AxisymEvolver(bridge, 51,[],[]);
% ropt = [];
% xopt = [];

figure;
hold on;
% PlotCircle([0,0],R1);
% PlotCircle([R1+H+R2,0],R2);
tt = linspace(0,pi/2,361); plot(R1.*cos(tt),R1.*sin(tt), 'k-');
tt = linspace(pi/2,pi,361); plot(R1+H+R2+R2.*cos(tt),R2.*sin(tt), 'k-');
plot(xs,rs,'b.-', xopt,ropt,'r-');
hold off;
axis equal;
axis([R1/2,R1+H+R2/2,0,R1]);


