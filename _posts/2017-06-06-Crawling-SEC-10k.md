---
layout: post
title: "Crawling the Annual Reports (i.e., 10-K) using R"
categories: misc
---

### Terminal and tmux:
Using a remote server for the parsing process.
```r
ssh <account_ID>@<Server_IP_Address>  ## Connect to a server
tmux attach -t <Session Number>  ## Attach a tmux session
R  ## Access R
```

### R Session:
Loading relevant packages to be used in the process.
```r
library(colorout)
library(data.table)
library(dplyr)
library(stringi)
library(TenK)
library(rvest)
library(rjson)
library(stringr)
library(ggplot2)
library(ggtheme)
library(DescTools)
```

### Collecting the SIC codes
```r
sicLIST <- read_html("https://www.sec.gov/info/edgar/siccodes.htm")
SICs <- sicLIST %>%
  html_nodes("td") %>%
  html_text()
SICs <- SICs[19:length(SICs)]
SICs <- SICs[!SICs %in% c("", " ")]
SICs <- matrix(SICs, ncol = 4, byrow = T)
SICs <- SICs[-nrow(SICs),] ## SIC Table
SICs <- SICs[-1,1] ## Removing all but the SIC codes
```

### Collecting the CIK (i.e., EDGAR company identifier) codes
```r
i = 1
j = 1
cikVEC <- list()
pages <- seq(from = 1, to = 10000000, by = 100)
for(j in 1:length(SICs)){
  for(i in 1:length(pages)){
    sec <- read_html(paste0("https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&SIC=",
    SICs[j], "&owner=include&match=&start=", pages[i], "&count=100&hidefilings=0"))
    cik <- sec %>%
      html_nodes("td") %>%
      html_text() %>%
      strsplit("\n") %>%
      unlist() %>%
      stri_trim_both()
    if(length(cik) != 0){
      #cik <- matrix(cik[-length(cik)], ncol = 3, byrow = T)
      #cik <- cik[-1,1]
      cik <- cik[substr(cik,1,2) == "00"]
      cikVEC[[i]] <- cik
      print(paste0("j = ",j," & i = ",i , " iteration completed."))
    }
    else{
      print(paste0("End of Loop for j = ", j))
      break
    }
  }
} ## Constructing a full CIK (EDGAR company identifier) list
rm(list = ls()[!(ls() %in% c('cikVEC'))])
cikVEC <- do.call("rbind", cikVEC)
```

### Collecting the URL addresses containing 10-K forms
```r
k = 1
tenkVEC <- list()
formList <- c("10-K", "10-K405", "10KSB", "10KSB40")  ## 10-K forms (including 10-K405, 10KSB, and 10KSB40 forms)

time = Sys.time()
for(k in 1:length(cikVec)){
  TenKs <- html_session(paste0("https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=", cikVec[k],"&type=10-k&dateb=&owner=exclude&count=100"))
  tenk <- NULL
  tenkUrl <- NULL
  try(tenkUrl <- TenKs %>%
        html_nodes("tr td a#documentsbutton") %>%
        html_attr("href"))
  
  documentUrl <- NULL
  if(!identical(tenkUrl,character(0))){
    for(u in tenkUrl){
      docUrl <- paste0("https://www.sec.gov",u) %>%
        html_session() %>%
        html_nodes("tr td a") %>%
        html_attr("href")
      documentUrl <- append(documentUrl, docUrl)
    }
    
    type <- NULL
    for(u in tenkUrl){
      typ <- paste0("https://www.sec.gov",u) %>%
        html_session() %>%
        html_nodes("td") %>%
        html_text() %>%
        matrix(ncol = 5, byrow = T)
      type <- rbind(type, typ)
    }
    
    tenk <- data.table(cbind(type, documentUrl))
    # tenk <- tenk[V2 == "Complete submission text file" | V4 %in% formList, documentUrl]
    tenk <- tenk[V4 %in% formList, documentUrl]
    tenkVEC[[k]] <- tenk
  }
  print(paste0(k, " iteration completed."))
}
print("End of Loop.")
difTime <- Sys.time() - time

tenkVEC <- data.table(unlist(tenkVEC))
tenkVEC2 = tenkVEC[, .(url = paste0("https://www.sec.gov",V1))]
```

### Collecting the item 1 sections (i.e., business descriptions) of the annual reports
```r
i = 1
error_list = NULL
tenK_item1 = vector("list")

time = Sys.time()
for(i in 1:length(tenkVEC2[,url])){
  res = NULL
  tryCatch(res <- TenK_process(URL = tenkVEC2[i,url], retrieve = "BD"),
           error = function(e) error_list <<- append(error_list, i))  ## length(error_list) = 2,381 --> XBRL Viewer
  tenK_item1[[i]] <- res
  print(paste0("#", i, " iteration completed."))
}
print("End of Loop")
Sys.time() - time
```

### Saving workspace
```r
save.image("./XXX.RData")
```

End of Code

###### Last updated Oct 1, 2018
