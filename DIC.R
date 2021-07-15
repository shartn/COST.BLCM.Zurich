######################################################################################
## Estimate DIC goodness of fit - note: an example only, DIC may not be very sensible here!
##
## D = deviance which is recorded in JAGS
## D.bar = mean of D
## D.theta = value of D at the posterior means of the model parameters
## pD = effective number of parameters = D.bar - D.theta
## DIC = D.theta + 2*pD
## 
## part1. we need D.bar = mean posterior deviance look in JAGS output

## part 2. get D.theta
## we need first the means of the model parameters from JAGS output:
## now we need to calculate the deviance, D, at these parameters 
## easiest way is simply to re-run JAGS but replace the parameters with their FIXED means

## 

pD<- D.bar - D.theta; print(pD);

DIC<- D.theta + 2*pD; print(DIC);
