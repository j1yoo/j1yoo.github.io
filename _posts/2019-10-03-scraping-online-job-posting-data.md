---
layout: post
title: "Scraping the Online Job Posting Data: 'Indeed.com'"
categories: Research
tag: Research
---

_p.s., This is still a work-in-progress._

I am scraping the search results for job postings that require skills related to artificial intelligence (e.g., experience and knowledge on machine learning, linear algibra, data analytics etc.) There are 11,807 pages in each of which there are ten job postings amounting to approximately 118,070 job openings for A.I. as of October 2, 2019.

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
    
    company_rating <- page2 %>%  # [4] Rating
      html_nodes("a") %>%
      html_nodes(xpath = '//*[@class="icl-Ratings-starsCountWrapper icl-Ratings-link"]') %>%
      html_attr("aria-label") %>%
      paste0(., "")
    
    company_review <- page2 %>%  # [5] Number of Reviews
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

### What the Data Looks Like:

| date_crawled  | job_title                                          | company_name                 | job_location                                             | job_rating   | job_review     | href_links                                                                 |
|---------------|----------------------------------------------------|------------------------------|----------------------------------------------------------|--------------|----------------|----------------------------------------------------------------------------|
| 10/2/19 13:05 | VP of Artificial Intelligence                      | Samsung SDS America          | Samsung SDS America6,867 reviews-San Jose, CA 95134      | 4 out of 5   | 6,867 reviews  | https://indeed.com/rc/clk?jk=29e6b0cfd4f1ad6e&fccid=da3c7fed78dd1607&vjs=3 |
| 10/2/19 13:05 | Artificial Intelligence Solution Architect         | Avanade                      | Avanade243 reviews-Baltimore, MD                         | 3.7 out of 5 | 243 reviews    | https://indeed.com/rc/clk?jk=c8b32b06ac7c5f37&fccid=5386281035076fdf&vjs=3 |
| 10/2/19 13:05 | Artificial Intelligence Intern                     | Tractor Supply Company       | Tractor Supply Company3,297 reviews-Brentwood, TN 37027  | 3.5 out of 5 | 3,297 reviews  | https://indeed.com/rc/clk?jk=4f9e3676b2e5e4c8&fccid=11196309d222f1c1&vjs=3 |
| 10/2/19 13:05 | Associate - Artificial Intelligence & Semantics    | Morgan Stanley               | Morgan Stanley3,506 reviews-Maryland                     | 3.9 out of 5 | 3,506 reviews  | https://indeed.com/rc/clk?jk=63e1414a8823a284&fccid=0c39fb2c91742dcf&vjs=3 |
| 10/2/19 13:06 | Backend Software Engineer, Artificial Intelligence | IBM                          | IBM27,074 reviews-Cambridge, MA 02139                    | 3.9 out of 5 | 27,074 reviews | https://indeed.com/rc/clk?jk=c6bd906a6276d2d3&fccid=de71a49b535e21cb&vjs=3 |
| 10/2/19 13:06 | Conversational Artificial Intelligence Designer    | PennyMac Loan Services, LLC  | PennyMac Loan Services, LLC267 reviews-Plano, TX         | 3.1 out of 5 | 267 reviews    | https://indeed.com/rc/clk?jk=371dc494bc960265&fccid=24c6c21cc329dea7&vjs=3 |
| 10/2/19 13:06 | Artificial Intelligence                            | Bank of America              | Bank of America28,108 reviews-Charlotte, NC 28255        | 3.8 out of 5 | 28,108 reviews | https://indeed.com/rc/clk?jk=8b653788c51d5ef9&fccid=5bd99dfa21c8a490&vjs=3 |
| 10/2/19 13:06 | Intern - Artificial Intelligence (AI)              | Alion Science and Technology | Alion Science and Technology227 reviews-College Park, MD | 3.5 out of 5 | 227 reviews    | https://indeed.com/rc/clk?jk=2638fb51ee02f970&fccid=1f295927bec6a974&vjs=3 |

### End of Code
