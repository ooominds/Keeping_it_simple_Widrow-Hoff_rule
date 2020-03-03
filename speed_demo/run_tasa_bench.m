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