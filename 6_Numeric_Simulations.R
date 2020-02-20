
####################
### PREPARATIONS ###
####################

require('MASS') # for mvrnorm(); random numbers from multivariate normal
source('all_functions.R') # read in all necessary functions
options(show.signif.stars=FALSE) # do not show significance stars

# -----

# Set means, standard deviations, correlations and variances-covariances
mu = c(0, 5, 10, -2)
stddev = c(1.75, 1.5, 1.25, 1)
corMat = matrix(c(1.00, 0.66, 0.62, 0.58,
                  0.66, 1.00, 0.15, 0.10,
                  0.62, 0.15, 1.00, 0.12,
                  0.58, 0.10, 0.12, 1.00),
                  ncol=4, byrow=TRUE)
covMat = stddev %*% t(stddev) * corMat

# Generating the simulated dataset
dat = data.frame(mvrnorm(n=1000, mu=mu, Sigma=covMat))
colnames(dat) = c('y', 'x1', 'x2', 'x3')

################################
### SIMPLE LINEAR REGRESSION ###
################################

summary(lm1 <- lm(y ~ x1 + x2 + x3, data=dat))
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -1.37197 -0.31225 -0.01595  0.32275  1.43254 
# 
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)
# (Intercept) -8.132498   0.128295  -63.39   <2e-16
# x1           0.627044   0.009442   66.41   <2e-16
# x2           0.663215   0.011606   57.15   <2e-16
# x3           0.809393   0.014812   54.65   <2e-16
# 
# Residual standard error: 0.4549 on 996 degrees of freedom
# Multiple R-squared:  0.9314,	Adjusted R-squared:  0.9311 
# F-statistic:  4504 on 3 and 996 DF,  p-value: < 2.2e-16

###################
### SIMULATIONS ###
###################

# Adding the Intercept (i.e., Bias)
# and reordering the variables to put y (outcome) to the end
dat = cbind('Intercept'=rep(1, nrow(dat)), dat[,c(2,3,4,1)])

# Preparing the dataset for training
Trials = as.matrix(dat)
numUniqueOutcomes = 1                              # no targets (teachers)
numLearningTrials = dim(Trials)[1]                 # no training patterns
numUniqueCues = dim(Trials)[2] - numUniqueOutcomes # no of inputs
cueNames = colnames(Trials)[1:numUniqueCues]       # input cue names
outNames = colnames(Trials)[numUniqueCues+1:numUniqueOutcomes] # output target names
W1 = matrix(0, nrow=numUniqueCues, ncol=numUniqueOutcomes) # weight matrix
Lr = 0.0001                                        # learning rate (alpha)

# Learning steps
ordering = 1:numLearningTrials

# -----

# Single run of the Widrow-Hoff update rule
for (trialIdx in ordering) {
	inputVec = matrix(Trials[ordering[trialIdx],1:numUniqueCues], nrow=1)
	outcomeVals = matrix(Trials[ordering[trialIdx],numUniqueCues+1:numUniqueOutcomes], nrow=1)
	W1 = update_WH(inputVec, outcomeVals, W1, Lr)
}
rownames(W1) = cueNames
colnames(W1) =outNames
W1
#                     y
# Intercept -0.01609912
# x1         0.08555121
# x2        -0.02922369
# x3         0.12495683

# -----

# 10K runs of the Widrow-Hoff update rule
W2 = matrix(0, nrow=numUniqueCues, ncol=numUniqueOutcomes) # weight matrix
for (i in 1:10000) {
    for (trialIdx in ordering) {
    	inputVec = matrix(Trials[ordering[trialIdx],1:numUniqueCues], nrow=1)
    	outcomeVals = matrix(Trials[ordering[trialIdx],numUniqueCues+1:numUniqueOutcomes], nrow=1)
    	W2 = update_WH(inputVec, outcomeVals, W2, Lr)
    }
}
rownames(W2) = cueNames
colnames(W2) =outNames
W2
#                    y
# Intercept -8.1231913
# x1         0.6241725
# x2         0.6574797
# x3         0.8108070

# -----

# Running the Widrow-Hoff update rule
# with 10K repeated updates for each y-value
# sorted in ascending order
orderedTrials = Trials[order(Trials[,5]),]
W3 = matrix(0, nrow=numUniqueCues, ncol=numUniqueOutcomes) # weight matrix
for (trialIdx in ordering) {
    for (i in 1:10000) {
    	inputVec = matrix(orderedTrials[ordering[trialIdx],1:numUniqueCues], nrow=1)
    	outcomeVals = matrix(orderedTrials[ordering[trialIdx],numUniqueCues+1:numUniqueOutcomes], nrow=1)
    	W3 = update_WH(inputVec, outcomeVals, W3, Lr)
    }
}
rownames(W3) = cueNames
colnames(W3) =outNames
W3
#                     y
# Intercept -0.01406655
# x1         0.20888258
# x2         0.29536572
# x3         0.06215094


