source('./../all_functions.R') # read in all necessary functions
library(tictoc)
load('tasa_sample_medium.rda') # Provides a matrix of cues called C and outcomes called T
numUniqueCues = ncol(C) # 5799
numUniqueOutcomes = ncol(T) # 8775 
numLearningTrials = dim(C)[1] # 1500

C=data.matrix(C)
T=data.matrix(T)

W = matrix(0, nrow=numUniqueCues, ncol=numUniqueOutcomes) 
Lr=0.01

tic()
# Single run of the Widrow-Hoff update rule
for (trialIdx in 1:numLearningTrials) {
  inputVec = C[trialIdx,,drop=FALSE]
  outcomeVals = T[trialIdx,,drop=FALSE]
  W = update_WH(inputVec, outcomeVals, W, Lr)
}
toc()