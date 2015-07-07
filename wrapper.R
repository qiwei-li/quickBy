system("R CMD SHLIB calcSum.c")
system("R CMD SHLIB calcCount.c")
system("R CMD SHLIB calcMin.c")
system("R CMD SHLIB calcMax.c")
system("R CMD SHLIB merge.c")

dyn.load("calcSum.so")
dyn.load("calcCount.so")
dyn.load("calcMin.so")
dyn.load("calcMax.so")
dyn.load("merge.so")

quickBy = function(keys, values, method){
  options(error = NULL)
  options(warn = 10)

	if(length(keys)!=length(values))
		stop("ERROR: lengths do not match between keys and values.")

	if(class(keys)!="integer" & class(keys)!="numeric")
		stop("keys should be numeric or integer.")

	if(class(values)!="numeric")
		stop("values should be numeric or integer.")

  oldKeys = keys
  oldValues = values
	oldcount = length(oldKeys)
	keysKeep = !is.na(oldKeys)

  keys = as.numeric(as.factor(oldKeys[keysKeep]))
  values = oldValues[keysKeep]
  valuesKeep = !is.na(values)

  readyKeys = keys[valuesKeep]
  readyValues = values[valuesKeep]
  
  if(method == "sum"){
    numKeys = max(readyKeys)

    hash = .C("calcSum", 
             as.integer(readyKeys), 
             as.numeric(readyValues), 
             as.integer(numKeys), 
             as.integer(length(readyKeys)), 
             as.numeric(rep(0, numKeys)))[[5]]
    
    numKeys = length(keys)
    tmp = .C("merge",
            as.integer(keys),
            as.numeric(hash),
            as.integer(numKeys),
            numeric(numKeys))[[4]]
    final = rep(NA, oldcount)
    final[keysKeep] = tmp
    return(final)
  }

  if(method == "count"){
    numKeys = max(readyKeys)
    hash = .C("calcCount", 
             as.integer(readyKeys), 
             as.numeric(readyValues), 
             as.integer(numKeys), 
             as.integer(length(readyKeys)), 
             as.integer(rep(0, numKeys)))[[5]]
    
    numKeys = length(keys)
    tmp = .C("merge",
            as.integer(keys),
            as.numeric(hash),
            as.integer(numKeys),
            numeric(numKeys))[[4]]
    final = rep(NA, oldcount)
    final[keysKeep] = tmp
    final[which(final==0)]=NA
    return(final)
  }
  
  if(method == "mean"){
    return(quickBy(oldKeys, oldValues, method = "sum")/quickBy(oldKeys, oldValues, method = "count"))
  }

  if(method == "min"){
    numKeys = max(readyKeys)

    hash = .C("calcMin", 
             as.integer(readyKeys), 
             as.numeric(readyValues), 
             as.integer(numKeys), 
             as.integer(length(readyKeys)), 
             as.numeric(rep(999999999, numKeys)))[[5]]
    
    numKeys = length(keys)
    tmp = .C("merge",
            as.integer(keys),
            as.numeric(hash),
            as.integer(numKeys),
            numeric(numKeys))[[4]]
    final = rep(NA, oldcount)
    final[keysKeep] = tmp
    return(final)
  }

  if(method == "max"){
    numKeys = max(readyKeys)

    hash = .C("calcMax", 
             as.integer(readyKeys), 
             as.numeric(readyValues), 
             as.integer(numKeys), 
             as.integer(length(readyKeys)), 
             as.numeric(rep(-999999999, numKeys)))[[5]]
    
    numKeys = length(keys)
    tmp = .C("merge",
            as.integer(keys),
            as.numeric(hash),
            as.integer(numKeys),
            numeric(numKeys))[[4]]
    final = rep(NA, oldcount)
    final[keysKeep] = tmp
    return(final)
  }

}