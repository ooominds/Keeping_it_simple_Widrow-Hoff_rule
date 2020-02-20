
source('all_functions.R') # read in all necessary functions

###################
### SIMULATIONS ###
###################

# Load experimental data
# (in wide format, convenient for Widrow-Hoff training)
load('data/constructions_pupil_size.rda')
dat = constructions_pupil_size

# Preparing the dataset for training
Trials = as.matrix(dat)
numUniqueOutcomes = 9                              # no targets (teachers)
numLearningTrials = dim(Trials)[1]                 # no training patterns
numUniqueCues = dim(Trials)[2] - numUniqueOutcomes # no of inputs
cueNames = colnames(Trials)[1:numUniqueCues]       # input cue names
outNames = colnames(Trials)[numUniqueCues+1:numUniqueOutcomes] # output target names
W = matrix(0, nrow=numUniqueCues, ncol=numUniqueOutcomes) # weight matrix
Lr = 0.1                                           # learning rate (alpha)

# Scaling the numerical values of cues
Trials[,1:60] = as.numeric(scale(Trials[,1:60]))

# Learning steps
ordering = 1:numLearningTrials

# Single run of the Widrow-Hoff update rule
for (trialIdx in ordering) {
	inputVec = matrix(Trials[ordering[trialIdx],1:numUniqueCues], nrow=1)
	outcomeVals = matrix(Trials[ordering[trialIdx],numUniqueCues+1:numUniqueOutcomes], nrow=1)
	W = update_WH(inputVec, outcomeVals, W, Lr)
}
rownames(W) = cueNames
colnames(W) =outNames

construction_WH_weights = as.data.frame(W)
save(construction_WH_weights, file='data/construction_WH_weights.rda')


