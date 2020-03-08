function [W] = ooominds_widrow_hoff_sparse(cues,outcomes,etaRW,noRuns,normalize)
% OOOMINDS_WIDROW_HOFF
%  Widrow Hoff learning algorithm
%
%  W = ooominds_widrow_hoff_sparse(cues,outcomes,etaRW,noRuns,normalize,varargin)
%
%  etaRW is the learning rate parameter
%
%  noRuns appears in some implementations as they like to repeat
%  (replicate) several runs to stabilize the results
%
%  normalize -if True (or 1) normalisation is applied.

numUniqueCues = size(cues,2);
numUniqueOutcomes = size(outcomes,2);
numLearningTrials = size(cues,1);
ordering = 1:size(cues,1);

cues = sparse(cues);
outcomes = sparse(outcomes);

if normalize
    disp('normalised')
    etaRW = etaRW / numLearningTrials;
else
    disp('Not normalised')
end

W = zeros(numUniqueCues,numUniqueOutcomes);

for i = 1:noRuns
    for j = ordering
        T = outcomes(j,:);
        C = cues(j,:);
        
        %% sparse iteration
        CW = sum(W(C,:),1);
        CW = sparse(CW);
        TCW = T-CW;
        C_TCW = C' * TCW;
        Delta = etaRW .* C_TCW;
        addSparseToDense(Delta,W);  % In MATLAB 2019a, this is faster than doing W = W + Delta      
    end
end
end

