
####################
### PREPARATIONS ###
####################

require(reshape2) # reshaping the dataframes - wide <-> long
require(gbm)      # Gradient Boosting Machines (GBMs)

# -----

# Load Widrow-Hoff weights
load('data/construction_WH_weights.rda')
whMatrix = construction_WH_weights

# Adding participants IDs
whMatrix$participant = rownames(whMatrix)

# Converting from wide to long data format
dat = melt(whMatrix)

# Splitting up constructions from presentation type
tmpFactor = matrix(
    unlist(strsplit(as.character(dat$variable), split='_')),
    ncol=2, byrow=TRUE
)

# Shaping up the dataframe
dat = data.frame(
    participant = dat[,1],
    construal = tmpFactor[,1],
    type = tmpFactor[,2],
    wh.weight = dat[,3]
)

# Adding pupil size data from experiment
load('data/by_subj_exp_data.rda')

# Merging two dataframes
dat$key = paste(as.character(dat$construal),
    as.character(dat$type), as.character(dat$participant),
    sep='_')
by_subj_exp_data$key = paste(as.character(by_subj_exp_data$construal.type),
    as.character(by_subj_exp_data$participant),
    sep='_')
allDat = merge(dat, by_subj_exp_data[,3:4], by='key')
allDat$key = NULL

# Reorder factor levels
allDat$construal = factor(allDat$construal, levels=c('datv', 'voic', 'prep'))
allDat$type = factor(allDat$type, levels=c('natur', 'typic', 'atypic'))

# Combining two experimentally manipulated factors
allDat$FactorInteraction = interaction(allDat$construal, allDat$type)

# Scale predictors
allDat$wh.weight.z = as.numeric(scale(allDat$wh.weight))
allDat$AvgPupilSize.z = as.numeric(scale(allDat$AvgPupilSize))

############
### GBMs ###
############

gbm1 = gbm(FactorInteraction ~
	AvgPupilSize +
	wh.weight,
	data=allDat[,c(6,4,5)],
    n.trees=5000, shrinkage=0.001,
    interaction.depth=5, cv.folds=5)
print(sum.gbm1 <- summary(gbm1, plotit=FALSE), row.names=FALSE)
 #          var  rel.inf
 #    wh.weight 67.25843
 # AvgPupilSize 32.74157

gbm2 = gbm(construal ~
	AvgPupilSize.z +
	wh.weight.z,
	data=allDat[,c(2,7,8)],
    n.trees=5000, shrinkage=0.001,
    interaction.depth=5, cv.folds=5)
print(sum.gbm2 <- summary(gbm2, plotit=FALSE), row.names=FALSE)
 #            var  rel.inf
 #    wh.weight.z 54.67997
 # AvgPupilSize.z 45.32003

gbm3 = gbm(type ~
	AvgPupilSize.z +
	wh.weight.z,
	data=allDat[,c(3,7,8)],
    n.trees=5000, shrinkage=0.001,
    interaction.depth=5, cv.folds=5)
print(sum.gbm3 <- summary(gbm3, plotit=FALSE), row.names=FALSE)
 #            var  rel.inf
 #    wh.weight.z 64.66395
 # AvgPupilSize.z 35.33605


