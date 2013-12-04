
# Code with all the models considered, there are 6 cells: 
#  Sigma:  Diff  Hier  Same
#  Beta :  Diff  Hier 

#--------------------------------------------------------
# 1) Different beta, different sigma (Separate regresions)

mtext.dd.quad = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i]+quad[i] , eta.e[abbrev[i]]  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
quad[i] <-  beta[3, abbrev[i]]*year[i]^2
}

# Priors.  
for (j in 1:ns) {
for (i in 1:3) { beta[i,j]   ~ dnorm(0, .0001) }
eta.e[j]    <- 1/(sigma.e[j]^2)
sigma.e[j] ~ dunif(0, 100)      
}

# predictives 
# for (i in 1:ns) { 
# y14[i] ~ dnorm(e[i]+s[i]+q[i] , eta.e[abbrev[i]]  )
# e[i]  <-  beta[1, abbrev[i]]
# s[i] <-  beta[2, abbrev[i]]*14
# q[i] <-  beta[3, abbrev[i]]*14^2
# rate[i] <- y14[i]/y13[i] - 1 
# }
}
"
mtext.dd.lin = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i] , eta.e[abbrev[i]]  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
}

# Priors.  
for (j in 1:ns) {
for (i in 1:2) { beta[i,j]   ~ dnorm(0, .0001) }
eta.e[j]    <- 1/(sigma.e[j]^2)
sigma.e[j] ~ dunif(0, 100)      
}
}
"
#--------------------------------------------------------

#--------------------------------------------------------
#2) Different betas, same sigma (one big regression)
mtext.ds.quad = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i]+quad[i] , eta.e )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
quad[i] <-  beta[3, abbrev[i]]*year[i]^2
}

# Priors.  
for (j in 1:ns) {
for (i in 1:3) { beta[i,j]   ~ dnorm(0, .0001) }
}
eta.e   <- 1/(sigma.e^2)
sigma.e ~  dunif(0, 100)      


# predictives 
# for (i in 1:ns) { 
# y14[i] ~ dnorm(e[i]+s[i]+q[i] , eta.e[abbrev[i]]  )
# e[i]  <-  beta[1, abbrev[i]]
# s[i] <-  beta[2, abbrev[i]]*14
# q[i] <-  beta[3, abbrev[i]]*14^2
# rate[i] <- y14[i]/y13[i] - 1 
# }
}
"
mtext.ds.lin = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i] , eta.e  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
}

# Priors.  
for (j in 1:ns) {
for (i in 1:2) { beta[i,j]   ~ dnorm(0, .0001) }
}
eta.e   <- 1/(sigma.e^2)
sigma.e ~ dunif(0, 100)      
}
"
#--------------------------------------------------------

#--------------------------------------------------------
# 3)  DIfferents Betas, Hirerarchical Sigma 
mtext.dh.quad = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i]+quad[i] , eta.e[abbrev[i]]  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
quad[i] <-  beta[3, abbrev[i]]*year[i]^2
}

# Priors.  
for (j in 1:ns) {
for (i in 1:3) { beta[i,j]   ~ dnorm(0, .0001) }
eta.e[j]      ~ dgamma(alpha,lambda)
sigma.e[j] <- 1/sqrt(eta.e[j])      
}

# hyperpriors
alpha  ~ dunif(0,100)
lambda ~ dunif(0,100)

# predictives 
# for (i in 1:ns) { 
# y14[i] ~ dnorm(e[i]+s[i]+q[i] , eta.e[abbrev[i]]  )
# e[i]  <-  beta[1, abbrev[i]]
# s[i] <-  beta[2, abbrev[i]]*14
# q[i] <-  beta[3, abbrev[i]]*14^2
# rate[i] <- y14[i]/y13[i] - 1 
# }
}
"
mtext.dh.lin = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i] , eta.e[abbrev[i]]  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
}

# Priors.  
for (j in 1:ns) {
for (i in 1:2) { beta[i,j]   ~ dnorm(0, .0001) }
eta.e[j]      ~ dgamma(alpha,lambda)
sigma.e[j]    <- 1/sqrt(eta.e[j])      
}

# hyperpriors
alpha  ~ dunif(0,100)
lambda ~ dunif(0,100)
}
"
#--------------------------------------------------------

#--------------------------------------------------------
# 4) Hirerachical Beta, Same sigma (lmer random regression)
mtext.hs.lin = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i] , eta.e )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
}

# Priors.  
for (j in 1:ns) {
beta[1:2,j]  ~ dmnorm(mu,prec.be )
}
sigma.e   ~ dunif(0,100)       
eta.e     <- 1/(sigma.e)^2

# hyperpriors
prec.be   ~ dwish(R, df)
sigma.be  <- inverse(prec.be)
for (i in 1:2) { mu[i] ~ dnorm(0,0.001) }
df     <- 3  
}
"

mtext.hs.quad = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i]+quad[i] , eta.e)
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
quad[i] <-  beta[3, abbrev[i]]*year[i]^2
}

# Priors.  
for (j in 1:ns) {
beta[1:3,j]  ~ dmnorm(mu,prec.be )
}
sigma.e   ~ dunif(0,100)       
eta.e     <- 1/(sigma.e)^2

# hyperpriors
prec.be   ~ dwish(R, df)
sigma.be  <- inverse(prec.be)
for (i in 1:3) { mu[i] ~ dnorm(0,0.001) }
df     <- 4  
}
"



#--------------------------------------------------------


#--------------------------------------------------------
#5) Hirerachical Betas, Differents Sigma
mtext.hd.lin = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i] , eta.e[abbrev[i]]  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
}

# Priors.  
for (j in 1:ns) {
beta[1:2,j]  ~ dmnorm(mu,prec.be )
sigma.e[j]   ~ dunif(0,100)       
eta.e[j]     <- 1/sqrt(sigma.e[j])
}

# hyperpriors
prec.be   ~ dwish(R, df)
sigma.be  <- inverse(prec.be)
for (i in 1:2) { mu[i] ~ dnorm(0,0.001) }

df     <- 3  
}
"

mtext.hd.quad = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i]+quad[i] , eta.e[abbrev[i]]  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
quad[i] <-  beta[3, abbrev[i]]*year[i]^2
}

# Priors.  
for (j in 1:ns) {
beta[1:3,j]  ~ dmnorm(mu,prec.be )
sigma.e[j]   ~ dunif(0,100)       
eta.e[j]     <- 1/sqrt(sigma.e[j])
}

# hyperpriors
prec.be   ~ dwish(R, df)
sigma.be  <- inverse(prec.be)
for (i in 1:3) { mu[i] ~ dnorm(0,0.001) }

df     <- 4  
}
"
#--------------------------------------------------------


#--------------------------------------------------------
# 6) Hirerarchical Sigma, Hirerarchical Beta
mtext.hh.quad = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i]+quad[i] , eta.e[abbrev[i]]  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
quad[i] <-  beta[3, abbrev[i]]*year[i]^2
}

# Priors.  
for (j in 1:ns) {
beta[1:3,j]   ~ dmnorm(mu,prec.be )
eta.e[j]      ~ dgamma(alpha,lambda)
sigma.e[j] <- 1/sqrt(eta.e[j])      
}

# hyperpriors
prec.be   ~ dwish(R, df)
sigma.be  <- inverse(prec.be)
for (i in 1:3) { mu[i] ~ dnorm(0,0.001) }

df     <- 4  
alpha  ~ dunif(0, 100)
lambda ~ dunif(0, 100)

# predictives 
# for (i in 1:ns) { 
# y14[i] ~ dnorm(e[i]+s[i]+q[i] , eta.e[abbrev[i]]  )
# e[i]  <-  beta[1, abbrev[i]]
# s[i] <-  beta[2, abbrev[i]]*14
# q[i] <-  beta[3, abbrev[i]]*14^2
# rate[i] <- y14[i]/y13[i] - 1 
# }

}
"
mtext.hh.lin = "
model {
for (i in 1:n) { 
y[i] ~ dnorm(eff[i]+slop[i] , eta.e[abbrev[i]]  )
eff[i]  <-  beta[1, abbrev[i]]
slop[i] <-  beta[2, abbrev[i]]*year[i]
}

# Priors.  
for (j in 1:ns) {
beta[1:2,j]   ~ dmnorm(mu,prec.be )
eta.e[j]      ~ dgamma(alpha,lambda)
sigma.e[j] <- 1/sqrt(eta.e[j])      
}

# hyperpriors
prec.be   ~ dwish(R, df)
sigma.be  <- inverse(prec.be)
for (i in 1:2) { mu[i] ~ dnorm(0,0.001) }

df     <- 4  
alpha  ~ dunif(0,100)
lambda ~ dunif(0,100)
}
"
#---------------------------------------------------------------
##############################################################################################
##############################################################################################
##############################################################################################
# 1) Different beta, different sigma (Separate regresions)
# m_f = function(x) {
#   m <- list(4)
#   m[[1]] = lm(ave.add ~ I(yearc) + I((yearc)^2), x) # quad 
#   m[[2]] = lm(log(ave.add) ~ I(yearc) + I((yearc)^2), x) # lquad
#   m[[3]] = lm(ave.add ~ I(yearc), x) # lin
#   m[[4]] = lm(log(ave.add) ~ I(yearc), x) # llin
#   names(m)  <- c('quad', 'lquad', 'lin', 'llin')
#   
#   ldply(m, function(ms) {
#     data.frame(parameter=c(attributes(coef(ms))$names,"sigma"),
#                estimate=c(coef(ms), summary(ms)$sigma),
#                ci.sig = c( apply(confint(ms),1,prod) > 0 ,NA),
#                aic=AIC(ms), var=c(diag(vcov(ms)),NA))
#   }
#   )
# }
# mod.dd = ddply(bird.yeartotal, .(forestN,abbrev), m_f)
# colnames(mod.dd)[3] <- 'model'
# levels(mod.dd$parameter) <- c('b0', 'b2', 'b1', 'sigma')
#--------------------------------------------------------
#--------------------------------------------------------
#2) Different betas, same sigma (one big regression)
# m_f2 = function(x) {
#   m <- list(4)
#   m[[1]] = lm(ave.add ~ I(yearc)*abbrev + I((yearc)^2)*abbrev, x) # quad 
#   m[[2]] = lm(log(ave.add) ~ I(yearc)*abbrev + I((yearc)^2)*abbrev, x) # lquad
#   m[[3]] = lm(ave.add ~ I(yearc)*abbrev, x) # lin
#   m[[4]] = lm(log(ave.add) ~ I(yearc)*abbrev, x) # llin
#   names(m)  <- c('quad', 'lquad', 'lin', 'llin')  
#   ldply(m, function(ms) {
#     data.frame(parameter=c(attributes(coef(ms))$names,"sigma"),
#                estimate=c(coef(ms), summary(ms)$sigma),
#                var=c(diag(vcov(ms)),NA))
#   }
#   )
# }
# mod.ds = ddply(bird.yeartotal, .(forestN), m_f2)
# colnames(mod.dd)[2] <- 'model'
#--------------------------------------------------------
#--------------------------------------------------------
# 3) Hirerachical Beta, Same sigma (lmer random regression)
# model using lmer, adding random effects. 
# mrnd_f <- function(x) {
#   x$lave <- log(x$ave.add) 
#   m <- list(2)
#   m[[1]] <-lmer(lave ~ yearc +(yearc|abbrev),data=x)
#   m[[2]] <-lmer(lave ~ yearc+I(yearc^2)+(yearc+I(yearc^2)|abbrev),data=x)  
#   names(m)  <- c('lin', 'quad')
#   ldply(m, function(ms) {
#     aux1 <- triu( attributes(VarCorr(ms)$abbrev)$correlation,1 ) 
#     cor.val <- as.numeric(aux1[aux1!=0])  
#     cor.name <- c('rho_01','rho_02','rho_12')[1:length(cor.val)]
#     
#     rn <- ranef(ms, postVar=T)$abbrev   
#     colnames(rn) <- c('b0', 'b1', 'b2')[1:ncol(rn)]
#     rn1 <- melt(data.frame(rn, abbrev=rownames(rn)), id.vars='abbrev')
#     rn1$nam <- apply(rn1[,1:2],1, paste, collapse='.') 
#     v <- melt(t(apply(attributes(rn)$postVar, 3, diag)))
#     
#     data.frame(parameter=c(names(fixef(ms)),"residual",cor.name,rn1$nam),
#                mean=c(fixef(ms),0, cor.val, rn1$value),
#                variance=c(attributes(VarCorr(ms)$abbrev)$stddev,
#                           attributes(VarCorr(ms))$sc,rep(0,length(cor.val)),
#                           v$value) )
#   }
#   )
# }
# mod.hs <- ddply(bird.yeartotal, .(forestN), mrnd_f)
#--------------------------------------------------------