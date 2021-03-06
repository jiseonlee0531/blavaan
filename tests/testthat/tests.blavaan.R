test_that("blavaan arguments", {
  x1 <- rnorm(100)
  x2 <- rnorm(100)
  y1 <- 0.5 + 2*x1 + rnorm(100)
  Data <- data.frame(y1 = y1, x1 = x1, x2 = x2)

  model <- ' y1 ~ x1 '

  ## auto convergence in stan
  expect_error(bsem(model, data=Data, fixed.x=TRUE, target="stan", convergence="auto"))

  ## seed length != # chains for jags
  expect_error(bsem(model, data=Data, fixed.x=TRUE, seed=1, target="jags"))

  ## supply ordinals
  expect_error(bsem(model, data=Data, fixed.x=TRUE, ordered=c("y1", "x1"), adapt=2, burnin=2, sample=2))

  ## unknown cp
  expect_error(bsem(model, data=Data, ov.cp="blah", fixed.x=TRUE))

  ## cp/std.lv clash
  expect_error(bsem(model, data=Data, fixed.x=TRUE, std.lv=TRUE, cp="fa"))

  model2 <- ' y1 ~ b1*x1 + b2*x2
              b1 + b2 == 0 '

  ## equality constraint with multiple variables on lhs
  expect_error(bsem(model2, data=Data, fixed.x=TRUE))

  ## do.fit=FALSE
  fit <- bsem(model, data=Data, fixed.x=TRUE, adapt=2,
              burnin=2, sample=2, do.fit=FALSE)
  expect_s4_class(fit, "blavaan")

  fit <- bsem(model, data=Data, save.lvs=TRUE, do.fit=FALSE)
  expect_s4_class(fit, "blavaan")
  
  ## named variable that clashes
  names(Data)[1] <- "lambda"
  model2 <- ' lambda ~ b1*x1 + b2*x2 '
  expect_error(bsem(model2, data=Data))

  ## one prior on variance, one on sd (problem for target="stan" only)
  ## and check that defined parameters translate
  names(Data)[1] <- "y1"
  model3 <- ' y1 ~ a*x1
              x2 ~ b*x1
              y1 ~~ prior("gamma(1,.5)[sd]")*y1
              x2 ~~ prior("gamma(1,.5)[var]")*x2
              pprod := a/b '
  expect_error(bsem(model3, data=Data, target="stan"))

  ## priors are wrong form but will not throw error until estimation
  fit <- bsem(model3, data=Data, target="jags", do.fit=FALSE)
  expect_s4_class(fit, "blavaan")

  fit <- bsem(model3, data=Data, target="stanclassic", do.fit=FALSE)
  expect_s4_class(fit, "blavaan")
  
  ## unknown prior
  expect_error(bsem(model, data=Data, dp=dpriors(psi="mydist(1,.5)")))

  ## wiggle argument
  expect_error(bsem(model3, data=Data, wiggle='a', wiggle.sd=0))  ## sd=0 not allowed
  expect_error(bsem(model3, data=Data, wiggle='sponge'))          ## sd is string
  expect_error(bsem(model3, data=Data, wiggle='b', wiggle.sd=c(1,2))) ## 2 sds, but 1 wiggle
  expect_error(bsem(model3, data=Data, wiggle=c('a','b'), wiggle.sd=c(.2,.3), target='jags'))
  expect_error(bsem(model3, data=Data, wiggle=c('a','b'), wiggle.sd=c(.2,.3), target='stanclassic')) ## wiggle.sd of length > 1 not allowed for these targets
  
  HS.model <- ' visual  =~ x1 + x2 + x3 '

  expect_s4_class(bcfa(HS.model, data=HolzingerSwineford1939, target="stan", do.fit=FALSE, group="school", group.equal=c("intercepts","loadings"), wiggle=c("intercepts"), wiggle.sd=.1), "blavaan")
  expect_s4_class(bcfa(HS.model, data=HolzingerSwineford1939, target="stanclassic", do.fit=FALSE, group="school", group.equal=c("intercepts","loadings"), wiggle=c("intercepts"), wiggle.sd=.1), "blavaan")
  expect_s4_class(bcfa(HS.model, data=HolzingerSwineford1939, target="jags", do.fit=FALSE, group="school", group.equal=c("intercepts","loadings"), wiggle=c("intercepts"), wiggle.sd=.1), "blavaan")
                  
})
