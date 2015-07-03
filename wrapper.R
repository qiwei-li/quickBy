system("R CMD SHLIB calcSum.c")
system("R CMD SHLIB calcCount.c")
system("R CMD SHLIB calcMin.c")
system("R CMD SHLIB calcMax.c")

dyn.load("calcSum.so")
dyn.load("calcCount.so")
dyn.load("calcMin.so")
dyn.load("calcMax.so")

quickBy = function(keys, values, method, expand){
	if(length(keys)!=length(values))
		stop("lengths do not match between keys and values.")

	if(class(keys)!="integer" | class(keys)!="numeric"){
		keys = as.numeric(keys)
	}

	if(class(values)!="numeric"){
		values = as.numeric(values)
	}

	allcount = length(values)
	keep = !is.na(keys) & !is.na(values)

	keys = keys[keep]
	values = values[keep]

	
	keys = as.integer(as.factor(keys))
	
	numKeys = length(unique(keys))
	numValues = length(values)

	#return(list(keys, values, numKeys, numValues))

	if(method == "min"){
		final = as.numeric(rep(NA, allcount))
		ans = as.numeric(rep(999999999999, numKeys))
		tmp = .C("calcMin", 
   		as.integer(keys), 
   		as.numeric(values), 
   		as.integer(numKeys), 
   		as.integer(numValues), 
   		as.numeric(ans))[[5]]
   		final[keep] = tmp[keys]
	}

		if(method == "max"){
		final = as.numeric(rep(-999999999999, allcount))
		ans = as.numeric(rep(0, numKeys))
		tmp = .C("calcMax", 
   		as.integer(keys), 
   		as.numeric(values), 
   		as.integer(numKeys), 
   		as.integer(numValues), 
   		as.numeric(ans))[[5]]
   		final[keep] = tmp[keys]
	}

	if(method == "sum"){
		final = as.numeric(rep(NA, allcount))
		ans = as.numeric(rep(0, numKeys))
		tmp = .C("calcSum", 
   		as.integer(keys), 
   		as.numeric(values), 
   		as.integer(numKeys), 
   		as.integer(numValues), 
   		as.numeric(ans))[[5]]
   		final[keep] = tmp[keys]
	}

	if(method == "count"){
		final = as.integer(rep(NA, allcount))
		ans = as.integer(rep(0, numKeys))
		tmp = .C("calcCount", 
   		as.integer(keys), 
   		as.numeric(values), 
   		as.integer(numKeys), 
   		as.integer(numValues), 
   		as.integer(ans))[[5]]
   		final[keep] = tmp[keys]
	}


	if(method == "mean"){
		final1 = as.numeric(rep(NA, allcount))
		ans1 = as.numeric(rep(0, numKeys))
		tmp1 = .C("calcSum", 
   		as.integer(keys), 
   		as.numeric(values), 
   		as.integer(numKeys), 
   		as.integer(numValues), 
   		as.numeric(ans1))[[5]]
   		final1[keep] = tmp1[keys]

   		final2 = as.integer(rep(NA, allcount))
		ans2 = as.integer(rep(0, numKeys))
		tmp2 = .C("calcCount", 
   		as.integer(keys), 
   		as.numeric(values), 
   		as.integer(numKeys), 
   		as.integer(numValues), 
   		as.integer(ans2))[[5]]
   		final2[keep] = tmp2[keys]

   		tmp = tmp1/tmp2
   		final = final1/final2
	}

	if(expand){
		return(final)
	} 
	else {
		return(tmp)
	}
}