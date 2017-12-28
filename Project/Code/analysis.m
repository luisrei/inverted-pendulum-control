%% System's simulation with the observer
clear;
close all;
load('fp_lin_matrices_fit3.mat');
T = 10;
D = zeros(1,2);

% Initial Conditions
alpha = 0.09;
beta = -0.0945;
x0 = [alpha 0 beta 0 0]';

G = eye(size(A)); 
Qe = eye(size(A))*3500; 
Re = eye(2)*0.0009; 
L = lqe(A, G, C, Qe, Re); 
Rr = 0.08;

[Q1,Q3] = meshgrid(200:10:600,200:10:600);
x1 = zeros(length(Q1),length(Q3));
x3 = zeros(length(Q1),length(Q3));
Um = zeros(length(Q1),length(Q3));

h = waitbar(0,'Please wait...');
steps = length(Q1);
for i = 1:length(Q1)
    for j = 1:length(Q3)
        Qr = diag([Q1(i,j),0,Q3(i,j),0,0]);
        K = lqr(A, B, Qr, Rr); 
        sim('observer_SAT_DEADZONE');
        %sim('observer_SIMPLES');
        x1(i,j) = max(abs(y.Data(2217:end,1)));
        x3(i,j) = max(abs(y.Data(2217:end,2)));
        Um(i,j) = max(abs(u.Data(2217:end)));
    end
    waitbar(i / steps);
end
close(h)

figure;
surf(Q1,Q3,Um);
xlabel('Q1');
ylabel('Q3');
zlabel('Voltage');

figure;
surf(Q1,Q3,x1);
xlabel('Q1');
ylabel('Q3');
zlabel('X1');

figure;
surf(Q1,Q3,x3);
xlabel('Q1');
ylabel('Q3');
zlabel('X3');
