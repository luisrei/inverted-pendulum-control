load('fp_lin_matrices_fit3.mat'); %Load Matrices A, B, C, D

MOTOR_SAT = 5;
TH1_BOUND = 120*pi/180;
TH2_BOUND = 30*pi/180;
TIME_DELAY = 6;

Qr = diag([800,0.01,30,0,0.7]); % Weight Matrix for x in the integra
%Qr = diag([500,0.2,20,0,0]);
%Qr = diag([20,0.01,5,0,0]);
%Qr = diag([400,20,1350,1.5,0]);

%Rr = 0.01;   % Weight for the input variable
Rr = 0.08;

Ga = 4; %gain associated with the alpha compensation 
        %(negative in the simulink)
K = lqr(A, B, Qr, Rr);   % Compute the feedback gain

G = eye(size(A));         % Weight of the process noise
Qe = eye(size(A))*3500;    % Variance of process errors
%Qe = eye(size(A))*1300;
Re = eye(2)*0.0009;  % Variance of measurement errors
%Re = eye(2)*0.001;

L = lqe(A, G, C, Qe, Re); % Compute the estimator gains
