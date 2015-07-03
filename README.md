# quickBy
The "by" function in R is a wrapper function of the "tapply" function. It is very useful because it applies a user defined function to each subset of the data grouped by some IDs. However, since the function is user defined, ordinary subsetting and for loops are implemented. This is unnecessarily slow when the user only wants to calculate some basic statistics.

I implemented these C routines in R while I was doing a project when I just want to calculate the mean, sum, count, min, max for a variable of each subset grouped by some IDs. Because I have many unique IDs, my running time gets reduced from 3000 seconds to 5 seconds.

```
### The code is simple to use
### Download the quickBy folder
### Run R, set the working directory to the downloaded folder

source("wrapper.R") # you need to have C complier

### Now the function is ready. Set the working directory to your project
### quickBy function needs 4 inputs
### quickBy(keys, values, method, expand)
### "keys" is the ID/factor variable of each subset. 
### "values" is the numerical vairable that you want to calculate on
### "method" needs to be set to one of the following:
###									 "min", "max", "sum", "count", "mean"
### "expand" deals with situations with NAs. The default values is TRUE.
### The function returns a vector that has the same length with keys and values

### EXAMPLE
keys =    c(NA, 1,  1,  1,  3,  3, 3, 3)
values =  c(2,  10, 10, 10, NA, 7, 7, 7)

quickBy(keys, values, method="sum", expand=TRUE)
[1] NA 30 30 30 NA 21 21 21
```

-
# The MIT License (MIT)

Copyright (c) 2015 Qiwei Li

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
