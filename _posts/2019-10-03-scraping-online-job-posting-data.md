---
layout: post
title: "Scraping the Online Job Posting Data: 'Indeed.com'"
categories: Research
tag: Research
---

p.s., This is still a work-in-progress.

###-###-###-###-###-###-###-###-###-###-###-###-###-####
# Web Scraping Online Job Posting Data from Indeed.com #
###-###-###-###-###-###-###-###-###-###-###-###-###-####

### Terminal and tmux:
Using a remote server for the parsing process.
```r
ssh <account_ID>@<Server_IP_Address>  ## Connect to a server
tmux attach -t <Session Number>  ## Attach a tmux session
R  ## Access R
```

### Loading libraries in R:
```r
library(data.table)
library(tidyverse)
library(rvest)
library(xml2)
library(stringi)
```

### Checking the total Number of Pages:

```r
num_pages <- 11807 # last page of results
full_data <- vector("list")

get_job_postings <- function(url){
  url <- paste0("https://www.indeed.com/jobs?q=artificial%20intelligence", 
                "&start=", i)  ## Can be adjusted depending on which search results are to be scraped.
  page <- xml2::read_html(url)
  href_links <- page %>% 
    html_nodes("div") %>%
    html_nodes(xpath = '//*[@data-tn-element="jobTitle"]') %>%
    html_attr("href") %>% paste0("https://indeed.com",.)  
  
}
```

```r
for(i in 1:num_pages){
  url <- paste0("https://www.indeed.com/jobs?q=artificial%20intelligence", 
                "&start=", i)
  page <- xml2::read_html(url)
  
  href_links <- page %>% 
    html_nodes("div") %>%
    html_nodes(xpath = '//*[@data-tn-element="jobTitle"]') %>%
    html_attr("href") %>% paste0("https://indeed.com",.)
  
  subdata <- data.table()
  for(j in seq_along(href_links)) {
    page2 <- xml2::read_html(href_links[j])
  
    Sys.sleep(2.5) # To prevent the platform from blocking us.
    
    job_title <- page2 %>%  # [1] Job Title
      html_nodes(xpath = '//*[@class="icl-u-xs-mb--xs icl-u-xs-mt--none  jobsearch-JobInfoHeader-title"]') %>%
      html_text() %>%
      stri_trim_both()
    
    company_name <- page2 %>%  # [2] Company Name
      html_nodes(xpath = '//*[@class="jobsearch-CompanyAvatar-companyLink"]') %>%
      html_text() %>%
      paste0(., "")
    
    job_location <- page2 %>%  # [3] Job Location
      html_nodes(xpath = '//*[@class=" jobsearch-CompanyInfoWithoutHeaderImage jobsearch-CompanyInfoWithReview"]') %>%
      html_text() %>%
      paste0(., "")
    
    job_rating <- page2 %>%  # [4] Rating
      html_nodes("a") %>%
      html_nodes(xpath = '//*[@class="icl-Ratings-starsCountWrapper icl-Ratings-link"]') %>%
      html_attr("aria-label") %>%
      paste0(., "")
    
    job_review <- page2 %>%  # [5] Number of Reviews
      html_nodes(xpath = '/html/body/div[1]/div[2]/div[3]/div/div/div[1]/div[1]/div[1]/div[1]/div/div/div[2]/div/a/div[2]') %>%
      html_text() %>%
      paste0(., "")
    
    job_description <- page2 %>%
      html_nodes(xpath = '//*[@id="jobDescriptionText"]') %>% 
      html_text() %>%
      stri_trim_both()
    
    subdata <- rbind(subdata, safely(data.table(date_crawled = Sys.time(),
                                                job_title,
                                                company_name,
                                                job_location,
                                                job_rating,
                                                job_review,
                                                href_links = href_links[j])))
    
    # print(paste0("For-loop in for-loop #", j,"."))
  }
  full_data[[i]] <- subdata
  print(paste0("Iteration ", i," completed."))
}
print("Iteration completed.")
```

```r
full_data = rbindlist(full_data)
write.csv(x = full_data, file = "/mnt/admin_jaewon_02/AI_job_posting_data/AI_job_posting_data.csv")
```

### End of Code
