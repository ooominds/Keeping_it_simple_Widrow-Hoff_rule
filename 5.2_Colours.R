
source('all_functions.R') # read in all necessary functions

####################
### PREPARATIONS ###
####################

# Generating probabilities under standard normal curve,
# by half sd (12 points)
standardNormal = data.frame(
	std = c('(-3.0,-2.5]', '(-2.5,-2.0]', '(-2.0,-1.5]', '(-1.5,-1.0]',
		'(-1.0,-0.5]', '(-0.5,0.0]',
		'(0.0,0.5]', '(0.5,1.0]', '(1.0,1.5]', '(1.5,2.0]',
		'(2.0,2.5]', '(2.5,3.0]'),
	prob = c(0.006, 0.017, 0.044, 0.092, 0.150, 0.191,
		0.191, 0.150, 0.092, 0.044, 0.017, 0.006)
)
standardNormal

# -----

# Getting ranges of the normalized sensitivity of cone cells
# from Dowling (1987) and Schubert (2006)
# [http://www.ecse.rpi.edu/~schubert/Light-Emitting-Diodes-dot-org/chap16/chap16.htm](http://www.ecse.rpi.edu/~schubert/Light-Emitting-Diodes-dot-org/chap16/chap16.htm]
redLow = c(450, 469, 499, 507, 526, 545, 564,
	583, 602, 621, 640, 659)
redHigh = c(469, 499, 507, 526, 545, 564,
	583, 602, 621, 640, 659, 678)
greenLow = c(428, 445.5, 463, 480.5, 498, 515.5, 533,
	550.5, 568, 585.5, 603, 620.5)
greenHigh = c(445.5, 463, 480.5, 498, 515.5, 533,
	550.5, 568, 585.5, 603, 620.5, 638)
blueLow = c(350, 364.5, 379, 393.5, 408, 422.5, 437,
	451.5, 466, 480.5, 495, 509.5)
blueHigh = c(364.5, 379, 393.5, 408, 422.5, 437,
	451.5, 466, 480.5, 495, 509.5, 524)
cbind(blueLow, blueHigh, greenLow, greenHigh, redLow, redHigh)

# -----

# Generate 100K datapoints from random uniform distribution
# in the range of [350, 750]
waveL = runif(n=100000, min=350, max=750)
rCone = gCone = bCone = vector('numeric')
red = green = blue = vector('integer')
for ( i in 1:length(waveL) ) {
	rIn = in_interval(waveL[i], redLow, redHigh)
	rCone[i] = ifelse(!is.null(rIn), standardNormal$prob[rIn], 0)
	gIn = in_interval(waveL[i], greenLow, greenHigh)
	gCone[i] = ifelse(!is.null(gIn), standardNormal$prob[gIn], 0)
	bIn = in_interval(waveL[i], blueLow, blueHigh)
	bCone[i] = ifelse(!is.null(bIn), standardNormal$prob[bIn], 0)
	red[i] = as.integer(findInterval(waveL[i], c(630,690)) == 1)
	green[i] = as.integer(findInterval(waveL[i], c(520,570)) == 1)
	blue[i] = as.integer(findInterval(waveL[i], c(460,490)) == 1)
}
dat = data.frame(
	context = rep(0, length(waveL)),
	rCone = rCone,
	gCone = gCone,
	bCone = bCone,
	red = red,
	green = green,
	blue = blue
)
head(dat)

###################
### SIMULATIONS ###
###################

# Preparing the dataset for training
Trials = as.matrix(dat)
numUniqueOutcomes = 3                              # no targets (teachers)
numLearningTrials = dim(Trials)[1]                 # no training patterns
numUniqueCues = dim(Trials)[2] - numUniqueOutcomes # no of inputs
cueNames = colnames(Trials)[1:numUniqueCues]       # input cue names
outNames = colnames(Trials)[numUniqueCues+1:numUniqueOutcomes] # output target names
W = matrix(0, nrow=numUniqueCues, ncol=numUniqueOutcomes) # weight matrix
res = list()                                       # learning steps (weights updates)
Lr = 0.1                                           # learning rate (alpha)

# Learning steps
ordering = 1:numLearningTrials

# Single run of the Widrow-Hoff update rule
for (trialIdx in ordering) {
	inputVec = matrix(Trials[ordering[trialIdx],1:numUniqueCues], nrow=1)
	outcomeVals = matrix(Trials[ordering[trialIdx],numUniqueCues+1:numUniqueOutcomes], nrow=1)
	W = update_WH(inputVec, outcomeVals, W, Lr)
	res[[trialIdx]] = W
}
rownames(W) = cueNames
colnames(W) =outNames

# Results
# W
# head(res)

