---
layout: post
title: "Crawling SEC 10-K forms on the web (EDGAR) using R"
categories: misc
---

require_once 'protect.php';
Protect\with('form.php', 'jaewon2018');


Namil Kim and I have collected all of the 10-K forms (including 10-K405, 10KSB, and 10KSB40) for all of the registered corporations (central index keys; hereafter CIKs) across all of the industries (determined by standard industrial classifications; hereafter SICs) that are available on the SEC’s EDGAR webpage. The data ranges from 19XX to 2017 (n = xxx,xxx) with 57,599 unique companies across a total of 444 industries.

### Terminal and tmux:
We use a remote server for the parsing process.
```r
ssh <account_ID>@<Server_IP_Address>  ## Connect to a server
tmux attach -t <Session Number>  ## Attach a tmux session
R  ## Access R
```

### R Session:
Install and load relevant packages to be used in the process.
```r
if(!require(mailR)) install.packages("mailR")
if(!require(devtools)) install.packages("devtools")
if(!require(TenK)) install_github("JasperHG90/TenK")
if(!require(rvest)) install.packages("rvest")
if(!require(data.table)) install.packages("data.table")
if(!require(dplyr)) install.packages("dplyr")
if(!require(stringi)) install.packages("stringi")
if(!require(rjson)) install.packages("rjson")
```

### Setting up E-mail addresses to use 'mailR'
Crawling the web takes a long time. We can use the 'mailR' package to have our server send an email notifying us that the loop/iteration has been completed.
```r
sender <- "email1@email.com"
recipients <- c("email2@email.com")
email <- send.mail(from = sender,
  to = recipients,
  subject = "Title",
  body = paste0("Iteration has been completed. ", "\n", 
  "Elapsed time: ", difTime, "\n", "Number of iteration to completion: ", k),
  smtp = list(host.name = "stmp", port = 465, user.name = "ID", passwd = "PW", ssl = T),
  authenticate = T,
  send = F)
```

### Collect all SIC codes
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

### Collect all CIK (EDGAR company identifier) codes
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

### Collect all of the URL addresses containing 10-K forms
```r
k = 1
tenkVEC <- list()
formList <- c("10-K", "10-K405", "10KSB", "10KSB40")  ## 10-K forms (including 10-K405, 10KSB, and 10KSB40 forms)

time = Sys.time()
for(k in 1:length(cikVEC)){
  TenKs <- html_session(paste0("https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=", cikVEC[k],"&type=10-k&dateb=&owner=exclude&count=100"))
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
    tenk <- tenk[V2 == "Complete submission text file" | V4 %in% formList, documentUrl]
    tenkVEC[[k]] <- tenk
  }
  print(paste0(k, " iteration completed."))
}
print("End of Loop.")
difTime <- Sys.time() - time
emailFun(k, difTime, body_add = "")  ## Send email to notify the completion of iteration

tenkVEC <- unlist(tenkVEC)
tenkVEC <- paste0("https://www.sec.gov",tenkVEC)
tenkVEC2 <- data.table(tenkVEC)[nchar(tenkVEC) != 67,]  ## Removed rows that does not contain 10-K forms
tenkVEC2 <- as.matrix(tenkVEC2)[,1]
```

### Crawling all of the 10-K forms using the exhaustive set of URLs for 10-K forms (i.e., for all of the companies registered on EDGAR)
We are collecting only the "business descriptions" by setting 'retrieve' option equal to "BD".
```r
savetojson <- function(data, path) {
  g <- toJSON(data)
  write(g, paste0("./path/10K_",i,".json"))
}  ## Saving 10-K Business Descripts as JavaScript Object Notation (Json) Files 

i = 1
error_list = NULL

time = Sys.time()
for(i in 1:length(tenkVEC2)){
  res = NULL
  tryCatch(res <- TenK_process(URL = tenkVEC2[i], retrieve = "BD"),
   error = function(e) error_list <<- append(error_list, i))  ## length(error_list) = 2,381 --> XBRL Viewer
   savetojson(res, i)  ## length() = 422,59X
  print(paste0("#", i, " iteration completed."))

  if(i %% 42259 == 1){
    try(emailFun(i, difTime = round(Sys.time() - time, 4), 
    body_add = paste0("\n", "Percentage completed: ", i %/% 42259*10, "%")))
  }
}
print("End of Loop")
Sys.time() - time
```
End of Code

###### Last updated Jun 15, 2017
