% This is the main driver of the optimal solution.
% It can thus be used as a script or embedded in a function.
%
% Requirements:
% - the bridge object (R1,R2,H,theta1,theta2,V,sigma)
% - the initial state (rp,xp)

%% setup the optimizer

% energy function
minfun = @(rpxp) AxisymEvolverEnergy(bridge, np,rpxp(1:np),rpxp(np+1:end));

% inequality constraints
A = [];
b = [];

% equality constraints
Aeq = [];
beq = [];
if (1)
	% constraint for nodes equally distributed between two endpoints.
	Aeq = zeros(np-2,np);
	beq = zeros(np-2,1);
	for i = 2:np-1
		frac = (i-1) / (np-1);
		Aeq(i-1,1) = -(1-frac);
		Aeq(i-1,i) = 1;
		Aeq(i-1,np) = -frac;
	end
	Aeq = [zeros(np-2,np), Aeq];
end

% bounds
lb = [];
ub = [];
if (1)
    % 
	lb = [repmat(0,np,1); repmat(bridge.X1,np,1)];
	ub = [repmat(R1*2,np,1); repmat(bridge.X2,np,1)];
end

% nonlinear constraint
nonlcon = @(rpxp) AxisymEvolverConstraint(bridge, np,rpxp(1:np),rpxp(np+1:end));

%% run optimization

% This is based on Matlab 2012 version
% Some options may have names changed in recent versions.
options = optimoptions('fmincon', ...
'Algorithm','sqp', 'Display','iter', ...
'MaxIter',100000, 'MaxFunEvals',200000, ...
'TolCon',1.0e-9, 'TolFun',1.0e-8, 'TolX',1.0e-8);

% call FMINCON
[sol,fval,exitflag,output,lambda] = fmincon(minfun, [rp;xp], A,b,Aeq,beq,lb,ub,nonlcon,options);

%% retrieve results

% node position
rp = sol(1:np);
xp = sol(np+1:end);
% pressure 
pres = AxisymEvolverGetPres(bridge, np,rp,xp, lambda);
% energy
sene = fval;


