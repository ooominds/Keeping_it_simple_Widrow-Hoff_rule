function [W] = ooominds_widrow_hoff(cues,outcomes,etaRW,noRuns,normalize,varargin)
% OOOMINDS_WIDROW_HOFF
%  Widrow Hoff learning algorithm
%
%  W = ooominds_widrow_hoff(cues,outcomes,etaRW,noRuns,normalize,varargin)
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
    
    
    if normalize
        etaRW = etaRW / numLearningTrials;
    end
    
    W = zeros(numUniqueCues,numUniqueOutcomes,'like',cues);
    
    for i = 1:noRuns
        for j = ordering
            T = outcomes(j,:);
            C = cues(j,:);
            Delta = etaRW .* C' * (T - C * W);
            W = W + Delta;
        end
    end
end

