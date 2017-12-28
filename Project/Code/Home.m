
%% Part 1 - Eigenvalues
clear;
load fp_lin_matrices_fit3.mat;
eig = eig(A)

%% Part 2 - Controlability
clear;
load fp_lin_matrices_fit3.mat;
Ctr = ctrb(A,B);
Dim = rank(Ctr)

%% Part 3 - Observability
clear;
load fp_lin_matrices_fit3.mat;

% Situation 1
Obs1 = obsv(A,C(2,:));
Dim1 = rank(Obs1)

% Situation 2
Obs2 = obsv(A,C);
Dim2 = rank(Obs2)

%% Part 4 - Bode diagram
clear;
close all;
load fp_lin_matrices_fit3.mat;
[b,a] = ss2tf(A,B,C,D);
figure;
bode(b,a);

figure;
rlocus(b(1,:),a);
title('Root Locus X1');

figure;
rlocus(b(2,:),a);
title('Root Locus X3');
%% Part 5 - Vector of Gains K
clear;
close all;
load fp_lin_matrices_fit3.mat;

Rr = 10:10:100;
Kr = zeros(5,10);
eigen = zeros(5,10);
figure;
hold all;
for j = 1:10
    a = rand(5,5);
    Qr = a'*a;
    [K,S,e] = lqr(A,B,Qr,Rr(j));
    Kr(:,j) = K;
    eigen(:,j) = eig(A-B*K);
    plot(real(eigen(:,j)),imag(eigen(:,j)),'x');
end

%% Part 6 - System's simulation
% Furuta pendulum - State feedback test
clear;
close all;

Qr = diag([10,0,1,0,0]); %Weight Matrix for x in the integral
Rr = 1; %Weight for the input variable
K = lqr(A, B, Qr, Rr); %Calculate feedback gain

% Simulate controller
x0 = [0 0 -0.1745 0 0]';
D = [0 0 0 0 0]';
C = eye(5,5);
T = 2; % Time duration of the simulation
sim('statefdbk',T);

gg = plot(x.Time,x.Data(:,1),x.Time,x.Data(:,3));
grid on;
set(gg,'LineWidth',1.5);
gg = xlabel('Time (s)');
set(gg,'Fontsize',14);
gg = ylabel('\beta (rad)');
set(gg,'Fontsize',14);
legend('x1','x2');


%% Part 7 - Vector of gains of the observer
clear;
close all;
load('fp_lin_matrices_fit3.mat');

G = eye(size(A)); %Gain of the process noise
Qe = eye(size(A))*10; %Variance of process errors
Re = eye(2); %Variance of measurement errors
L = lqe(A, G, C, Qe, Re); %Calculate estimator gains

%% Part 8 - System's simulation with the observer
clear;
close all;
load('fp_lin_matrices_fit3.mat');
T = 3;
D = zeros(1,2);

% Initial Conditions
alpha = 0.09;
beta = -0.0945;
x0 = [alpha 0 beta 0 0]';

G = eye(size(A)); %Gain of the process noise
Qe = eye(size(A))*10; %Variance of process errors
Re = eye(2); %Variance of measurement errors
%G = eye(size(A)); 
%Qe = eye(size(A))*3500; 
%Re = eye(2)*0.0009; 

L = lqe(A, G, C, Qe, Re); 

Rr = 1;
Qr = diag([10,0,1,0,0]);
K = lqr(A, B, Qr, Rr); 
sim('observer_SIMPLES');
%sim('observer_SAT_DEADZONE');

figure;
plot(t.Time,y.Data); %2217 estável
ylabel('Angle(rad)');
xlabel('time(s)');
grid on;
legend('x1-alpha','x3-beta');

figure;
plot(t.Time,u.Data);
ylabel('Voltage(V)');
xlabel('time(s)');
grid on;
legend('u-Voltage');
