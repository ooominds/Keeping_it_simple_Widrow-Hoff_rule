%filename = 'tasa_sample_medium.mat'; 
filename = 'tasa_sample_small.mat';   % Useful for testing

% CPU in single precision
[time, hardware,precision] =  speed_demo(filename,'CPU','single',1);

% CPU in double precision
[time, hardware,precision] =  speed_demo(filename,'CPU','double',1);

%% GPU functions will need the parallel computing toolbox
% GPU in double precision
[time, hardware,precision] =  speed_demo(filename','GPU','double',1);

% GPU in single precision
[time, hardware,precision] =  speed_demo(filename','GPU','single',1);

%% Sparse - not currently supported in speed_demo so do it manually here
%% This will become part of speed_demo in a future version
% The sparse version of ooominds_widrow_hoff uses a mex file.  Compile it here
mex addSparseToDense.c


load(filename,'cues','outcomes'); 

numUniqueCues = size(cues,2); 
numUniqueOutcomes = size(outcomes,2); 
numLearningTrials = size(cues,1);
Lr = 0.01;
tic
W = ooominds_widrow_hoff_sparse(cues,outcomes,Lr, 1,0);
toc