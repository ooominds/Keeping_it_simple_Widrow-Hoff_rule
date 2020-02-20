
#################
### FUNCTIONS ###
#################

# Function that tests whether a value (x) is in the interval
# of [low, high]
in_interval <- function(x, low, high) {
	for (i in 1:length(low)) {
		if (findInterval(x, c(low[i], high[i])) == 1) {
			return(i); break
		}
	}
}


# Widrow-Hoff update function
update_WH = function(cues, outcomes, wOld, learningRate) {
	wNew = wOld + learningRate * t(cues) %*% (outcomes - cues %*% wOld)
	return(wNew)
}


