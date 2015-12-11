\name{bsem}
\alias{bsem}
\title{Fit Structural Equation Models}
\description{
Fit a Structural Equation Model (SEM).}
\usage{
bsem(..., ov.cp = "srs", lv.cp = "srs",
     dp = dpriors(), n.chains = 3, burnin, sample,
     adapt, jagfile = FALSE, jagextra = list(), inits = "prior",
     jagcontrol = list())
}
\arguments{
\item{...}{Default lavaan arguments.  See \code{\link{lavaan}}.}
\item{ov.cp}{Handling of prior distributions on covariance parameters
    associated with observed variables: possible values are \code{"srs"} or
    \code{"fa"}.  Option \code{"srs"} is more flexible and better from a
    theoretical standpoint, but it is also slower.}
\item{lv.cp}{Handling of prior distributions on covariance parameters
    associated with latent variables; see the \code{ov.cp} argument.}
\item{dp}{Default prior distributions on different types of
    parameters, typically the result of a call to \code{dpriors()}.
    See the \code{dpriors()} help file for more information.}
\item{n.chains}{Number of desired MCMC chains.}
\item{burnin}{Number of burnin iterations, NOT including the adaptive
  iterations.}
\item{sample}{The total number of samples to take after burnin.}
\item{adapt}{The number of adaptive iterations to use at the start of
  the simulation.}
\item{jagfile}{If \code{TRUE}, the JAGS model will be written to file
  (in the lavExport directory). Can also supply a character
  string, which serves as the name of the directory to which files will be written.}
\item{jagextra}{A list with potential names \code{syntax} and
  \code{monitor}. The \code{syntax} object is a text string containing extra
  code to insert in the JAGS model syntax, and the \code{monitor} object
  is a character vector containing extra JAGS parameters to sample.}
\item{inits}{If it is a character string, the options are currently
    \code{"simple"}, \code{"Mplus"}, \code{"prior"} (default), and
    \code{"jags"}.  In the first two 
    cases, parameter values are set as though they will be estimated via
    ML (see \code{\link{lavaan}}).  The starting parameter value for
    each chain is then perturbed from the original values through the
    addition of uniform noise.  If \code{"prior"} is used, the starting
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
\item{jagcontrol}{A list containing additional parameters passed to
    \code{"run.jags"}.  See the manpage of \code{\link{run.jags}} for an
    overview of the additional parameters that can be set.  No other
    model estimation functions are currently available.}
}
\details{
    The \code{bsem} function is a wrapper for the more general
    \code{\link{blavaan}} function, using the following default
    \code{\link{lavaan}} arguments:
    \code{int.ov.free = TRUE}, \code{int.lv.free = FALSE},
    \code{auto.fix.first = TRUE} (unless \code{std.lv = TRUE}),
    \code{auto.fix.single = TRUE}, \code{auto.var = TRUE},
    \code{auto.cov.lv.x = TRUE}, 
    \code{auto.th = TRUE}, \code{auto.delta = TRUE},
    and \code{auto.cov.y = TRUE}.
  }
\value{
  An object of class \code{\linkS4class{lavaan}}, for which several methods
  are available, including a \code{summary} method.
}
\references{
Yves Rosseel (2012). lavaan: An R Package for Structural Equation
Modeling. Journal of Statistical Software, 48(2), 1-36. URL
http://www.jstatsoft.org/v48/i02/.

Edgar C. Merkle & Yves Rosseel (2015). blavaan: Bayesian Structural
Equation Models via Parameter Expansion.
}
\seealso{
\code{\link{blavaan}}
}
\examples{
\dontrun{
## The industrialization and Political Democracy Example 
## Bollen (1989), page 332
model <- ' 
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + a*y2 + b*y3 + c*y4
     dem65 =~ y5 + a*y6 + b*y7 + c*y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'

## unique priors for mv intercepts; parallel chains
fit <- bsem(model, data=PoliticalDemocracy,
            dp=dpriors(nu="dnorm(5,1e-2)"),
            jagcontrol=list(method="rjparallel"))
summary(fit)
}
}