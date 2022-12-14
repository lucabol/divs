#!/usr/bin/env -S r -l tidyverse,tidyquant,future

library(tidyverse)
library(tidyquant)
# library(future)

if (is.null(argv)) {
    cat("Need a ticker name \n")
    q(status = -1)
}

# TODO: change to plan(multisession) or plan(multicore) [latter just linux] to load in parallel (slow for one ticker)
# plan(sequential)

get_yield <- function(ticker, from = "1970-01-01", divs_x_year = 4) {
  #pr %<-% tq_get(ticker, get = "stock.prices", from = from) 
  #di %<-% tq_get(ticker, get = "dividends", from = from)
  pr <- tq_get(ticker, get = "stock.prices", from = from) 
  di <- tq_get(ticker, get = "dividends", from = from)
  pd <- inner_join(pr, di, by = "date", keep = FALSE)
  pd$yield <- with(pd, (value / adjusted) * divs_x_year)
  return(pd)
}

df <- get_yield(argv[1])

write.csv(get_yield(argv[1]), stdout(), row.names = TRUE)
