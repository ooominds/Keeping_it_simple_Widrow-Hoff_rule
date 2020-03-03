function [time,hardware,precision,W] = speed_demo(filename,hardware,precision,verbose)
% filename: tasa_midi or tasa_mini
% hardware: 'GPU' or 'CPU'
% precision: 'single' or 'double'
% verbose: True or False
format long
load(filename,'cues','outcomes'); % Provides a matrix of cues and outcomes called

numUniqueCues = size(cues,2); % 2403 or 5799
numUniqueOutcomes = size(outcomes,2); % 1114 or 8775
numLearningTrials = size(cues,1); % 500 or 15000
Lr = 0.01;  % Learning rate

if verbose
    fprintf('file = %s\n',filename)
    fprintf('numUniqueCues = %d\n',numUniqueCues)
    fprintf('numUniqueOutcomes = %d\n',numUniqueOutcomes)
    fprintf('numUniqueCues = %d\n',numLearningTrials)
    fprintf('Lr = %.3f\n',Lr)
end

if strcmp(precision,'double') 
    cues = double(cues);
    outcomes = double(outcomes);
    if verbose
        disp('double precision')
    end
elseif strcmp(precision,'single') % convert to single
    if verbose
        disp('single precision')
    end
    cues = single(cues);
    outcomes = single(outcomes);
else
    error('Requested precision not supported')
end

if strcmp(hardware,'CPU') % Nothing to do because all data is available to CPU
    if verbose
        disp('Running on CPU')
    end
    % Single run of the Widrow hoff algorithm
    tic
    W = ooominds_widrow_hoff(cues,outcomes,Lr, 1,0);
    time=toc;
elseif strcmp(hardware,'GPU') % Move data to GPU
    if verbose
        disp('Running on GPU')
    end
    gpudev = gpuDevice()
    cues = gpuArray(cues);
    outcomes = gpuArray(outcomes);
    % Single run of the Widrow hoff algorithm
    tic
    W = ooominds_widrow_hoff(cues,outcomes,Lr, 1,0);
    wait(gpudev);
    time=toc;
else
    error('Requested hardware type not supported')
end



if verbose
    fprintf('time = %.3f\n',time)
    fprintf('W(1) = %.8f\n',W(1))  % Show the first element as a very crude check
end


end












