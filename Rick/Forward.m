function [ x_output,net_forwarded ] = Forward( N,constants,params,net)
% Authored by Rick~
%FORWARD 前向传播函数
%input:
%   N
%   constants
%   params
%   net
%output:
%   x_output
%   net_forwarded

% Constants
F = constants.F;
P = constants.P;
y = constants.y;
% parameters
H = params.H;
D = params.D;
rho = params.rho;
eta = params.eta;
q = params.q;

for i = 1:N-1
    % ReconstructionLayer
    fprintf('ReconstructionLayer %d\n',i);
    tic;
    %x_1 = ReconstructionLayer(F,P,H_1,beta_0,y,rho_1,z_0);
    net.x(i+1,1) = {ReconstructionLayer(F,P,H(i+1,1),net.beta(i,1)...
            ,y,rho(i+1,1),net.z(i,1))};
    toc;
    
    % ConvolutionLayer
    fprintf('ConvolutionLayer %d\n',i);
    tic;
    %c_1 = ConvolutionLayer(x_1,D_1);
    net.c(i+1,1) = ConvolutionLayer(net.x(i+1,1),D(i+1,1));
    toc;
    
    % NonlinearTransformLayer
    fprintf('NonlinearTransformLayer %d\n',i);
    tic;
    %z_1 = NonlinearTransformLayer(c_1,beta_0,q_1);
    net.z(i+1,1) = NonlinearTransformLayer(net.c(i+1,1),net.beta(i,1),q(i+1,1));
    toc;
    
    % MultiplierUpdateLayer
    fprintf('MultiplierUpdateLayer %d\n',i);
    tic;
    %beta_1 = MultiplierUpdateLayer(beta_0,eta_1,c_1,z_1);
    net.beta(i+1,1) = MultiplierUpdateLayer(net.beta(i,1),eta(i+1,1),...
        net.c(i+1,1),net.z(i+1,1));
    toc;
end
net_forwarded = net;
x_output = net.x(N,1);
end

