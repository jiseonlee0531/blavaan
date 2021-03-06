\name{blavaan}
\alias{blavaan}
\alias{blavaan-class}
\title{Fit a Bayesian Latent Variable Model}
\description{
Fit a Bayesian latent variable model.}
\usage{
blavaan(..., cp = "srs",
    dp = NULL, n.chains = 3, burnin, sample,
    adapt, mcmcfile = FALSE, mcmcextra = list(), inits = "prior",
    convergence = "manual", target = "stan", save.lvs = FALSE,
    wiggle = NULL, wiggle.sd = 0.1, jags.ic = FALSE, seed = NULL, bcontrol = list())
}
\arguments{
\item{...}{Default lavaan arguments.  See \code{\link{lavaan}}.}
\item{cp}{Handling of prior distributions on covariance parameters:
  possible values are \code{"srs"} (default) or \code{"fa"}.  Option
  \code{"fa"} is only available for \code{target="jags"}.}
\item{dp}{Default prior distributions on different types of
    parameters, typically the result of a call to \code{dpriors()}.
    See the \code{dpriors()} help file for more information.}
\item{n.chains}{Number of desired MCMC chains.}
\item{burnin}{Number of burnin iterations, NOT including the adaptive
  iterations.}
\item{sample}{The total number of samples to take after burnin.}
\item{adapt}{The number of adaptive iterations to use at the start of
  the simulation.}
\item{mcmcfile}{If \code{TRUE}, the JAGS/Stan model and data will be written
  to files (in the lavExport directory). Can also supply a character
  string, which serves as the name of the directory to which files will be written.}
\item{mcmcextra}{A list with potential names \code{syntax} and
  \code{monitor}. The \code{syntax} object is a text string containing extra
  code to insert in the JAGS/Stan model syntax, and the \code{monitor} object
  is a character vector containing extra JAGS/Stan parameters to sample.}
\item{inits}{If it is a character string, the options are currently
    \code{"simple"}, \code{"Mplus"}, \code{"prior"} (default), or \code{"jags"}.  In the first two
    cases, parameter values are set as though they will be estimated via
    ML (see \code{\link{lavaan}}).  The starting parameter value for
    each chain is then perturbed from the original values through the
    addition of random uniform noise.  If \code{"prior"} is used, the starting
    parameter values are obtained based on the prior distributions
    (while also trying to ensure that the starting values will not crash
    the model estimation).  If \code{"jags"}, no starting values are
    specified and JAGS will choose values on its own.
    If \code{start} is a fitted
    object of class \code{\linkS4class{lavaan}}, the estimated values of
    the corresponding parameters will be extracted, then perturbed in
    the manner described above. If it is a model list,
    for example the output of the \code{paramaterEstimates()} function,
    the values of the \code{est} or \code{start} or \code{ustart} column
    (whichever is found first) will be extracted.}
\item{convergence}{Useful only for \code{target="jags"}. If \code{"auto"}, parameters are
  sampled until convergence is achieved (via \code{autorun.jags()}). In
  this case, the arguments \code{burnin} and \code{sample} are passed to
  \code{autorun.jags()} as \code{startburnin} and \code{startsample},
  respectively. Otherwise, parameters
  are sampled as specified by the user (or by the \code{run.jags}
  defaults).}
\item{target}{Desired MCMC sampling, with \code{"stan"} (pre-compiled
  marginal approach) as
  default. Other options include \code{"jags"}, \code{"stancond"}, and
  \code{"stanclassic"}, which sample latent variables and provide some
  greater functionality (because syntax is written "on the fly"). But
  they are slower and less efficient.}
\item{save.lvs}{Should sampled latent variables (factor scores) be
  saved? Logical; defaults to FALSE}
\item{wiggle}{Labels of equality-constrained parameters that should be
  "approximately" equal. Can also be "intercepts", "loadings",
  "regressions", "means".}
\item{wiggle.sd}{The prior sd (of normal distribution) to be used in approximate equality
  constraints. Can be one value, or (for target="stan") a numeric vector
  of values that is the same length as wiggle.}
\item{jags.ic}{Should DIC be computed the JAGS way, in addition to the BUGS way? Logical; defaults to FALSE}
\item{seed}{A vector of length \code{n.chains} (for target
  \code{"jags"}) or an integer (for target \code{"stan"}) containing random
  seeds for the MCMC run. If \code{NULL}, seeds will be chosen randomly.}
\item{bcontrol}{A list containing additional parameters passed to
    \code{run.jags} (or \code{autorun.jags}) or \code{stan}.  See the manpage of those functions for an
    overview of the additional parameters that can be set.}
}
\value{
  An object that inherits from class \code{\linkS4class{lavaan}}, for which several methods
  are available, including a \code{summary} method.
}
\references{
Yves Rosseel (2012). lavaan: An R Package for Structural Equation
Modeling. Journal of Statistical Software, 48(2), 1-36. URL
http://www.jstatsoft.org/v48/i02/.

Edgar C. Merkle & Yves Rosseel (2018). blavaan: Bayesian Structural
Equation Models via Parameter Expansion. Journal of Statistical
Software, 85(4), 1-30. URL http://www.jstatsoft.org/v85/i04/.
}
\seealso{
\code{\link{bcfa}}, \code{\link{bsem}}, \code{\link{bgrowth}}
}
\examples{
\dontrun{
# The Holzinger and Swineford (1939) example
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- blavaan(HS.model, data=HolzingerSwineford1939,
               auto.var=TRUE, auto.fix.first=TRUE,
               auto.cov.lv.x=TRUE)
summary(fit)
coef(fit)
}
}
