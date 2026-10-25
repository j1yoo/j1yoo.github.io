---
layout: course-guide
permalink: /teaching/pba-data/
title: "Finding Data for Your Project"
description: "For the PBA team project: where to look for real data, how to judge a dataset, and what to check before Milestone 2 (data and proposal), due Sun Oct 25."
course_label: "PBA"
semester: "Fall 2026"
accent: "#2698ba"
favicon_base: /assets/courses/pba/pba_favicon
course_links:
  - text: "Undergraduate course page"
    url: "/teaching/pba/"
  - text: "Graduate course page"
    url: "/teaching/pba-grad/"
posted: 2026-10-05
updated: 2026-10-26
nav: false
---

Finding data is the biggest single step of the team project. Use **real data**: records that someone collected for a real purpose, or data your team collects itself. Synthetic data made to test machine-learning models, which is common on Kaggle, cannot tell you anything about the world. There are two ways in, and both are fine: start from a question and look for data that can answer it, or start from an interesting dataset and ask what it can answer. **Milestone 2 (data and proposal) is due Sunday, October 25.**

### 1. Know what kind of question you are asking

Your question is one of three kinds, and the kind decides what counts as a good answer.

- **Describe.** What does the world look like? *How do Airbnb prices in Taipei vary across districts?* A description makes a good project when the data show something new and interesting, for example data your team collects itself.
- **Predict.** Can we forecast something we have not seen yet? *Which new listings will get their first booking within a month?* What counts is how well the prediction does on data the model has not seen.
- **Explain a cause.** Does T change Y? *Did a city's short-term rental rule lower rents?* Here you need a reason why your comparison is fair: a policy that starts at different times in different places (difference-in-differences), a group you can compare before and after, or variables you can control for, as in the causality lectures. If you can find such a comparison, a causal question is often the most direct way to a good paper, for undergraduate and graduate teams alike. Graduate projects must include this kind of identification argument.

### 2. Finding a question

- **Start from what you care about.** You will spend weeks on this. Pick something you have read about, argued about, or wondered about.
- **Ask "compared to what?"** Every claim hides a comparison: compared to last year, to another city, to people who did not use the service. Naming the comparison tells you what data you need.
- **Narrow it down to one sentence.** "Online shopping" is a topic. "Did same-day delivery raise order frequency in cities where it launched first?" is a question.
- **Starting from the data is fine.** Browse the lists below, open a dataset, and ask what it could tell you.

### 3. Where to look

Many sources below do not allow you to share their files. When a line says so, keep the raw files out of your public repository and commit only your code, as the checklist in section 5 explains.

#### Search engines and archives

- [Google Dataset Search](https://datasetsearch.research.google.com/): a search engine for datasets across the web. A good first stop, but many results are commercial data sites, so follow each result to the original publisher and check its terms.
- [Harvard Dataverse](https://dataverse.harvard.edu/): data behind published research, searchable by topic. Public files download without an account; documentation and licenses vary by dataset.
- [ICPSR](https://www.icpsr.umich.edu/): a large social science data archive. Downloads need a free ICPSR account, and some files are only for users at member institutions; NTHU is not on the member list. Sharing the files is not allowed.
- [Data.gov](https://catalog.data.gov/dataset): over 400,000 datasets, mostly from the U.S. federal government and some from states and cities.
- [Kaggle Datasets](https://www.kaggle.com/datasets): use with care. Many Kaggle datasets have no codebook and no stated origin. A Kaggle dataset is acceptable only if you can find and document where the data originally came from.
- <span class="badge-new" title="Added in October 2026">New</span> [OpenAlex](https://openalex.org/): free data on scholarly papers, with their authors, institutions, journals, and citations (CC0 license). Take a small sample through its API.

#### People and households: surveys and census data

- [IPUMS](https://www.ipums.org/): U.S. census and survey microdata (ACS, CPS) and census samples from many countries, harmonized across years. Free, with registration; IPUMS International also asks for a short project description. Sharing the files is not allowed, so share your extract settings or code instead.
- [General Social Survey](https://gss.norc.org/): attitudes and behavior of U.S. adults, repeated since 1972 (latest 2024). Free with no login, in Stata, SPSS, or SAS format; the `haven` package reads them in R.
- [Cooperative Election Study (CES)](https://tischcollege.tufts.edu/research-faculty/research-centers/cooperative-election-study): the largest academic survey of U.S. elections, run since 2006 (formerly the Cooperative Congressional Election Study, CCES). Vote choices, political views, and background of U.S. adults; 61,000 respondents in 2020. Free on [Harvard Dataverse](https://dataverse.harvard.edu/dataverse/cces).
- [Pew Research Center datasets](https://www.pewresearch.org/datasets/): surveys on technology, media, politics, and society. Free account required. Most files are SPSS files, which `haven::read_sav()` reads.
- [World Values Survey](https://www.worldvaluessurvey.org/): values and beliefs in 66 countries in the latest wave, including Taiwan (surveyed in 2019). Free for non-commercial use after you enter your name, email, and institution; sharing the files is not allowed. For Europe, the [European Social Survey](https://www.europeansocialsurvey.org/) is similar (free account, not-for-profit use).
- <span class="badge-new" title="Added in October 2026">New</span> [Global Flourishing Study](https://globalflourishingstudy.com/overview): a survey that follows more than 200,000 people in 22 countries, on well-being, health, relationships, and finances. Waves 1 and 2 are free on OSF (CC BY 4.0, no login). The full file is 123 MB, so keep a subset.
- <span class="badge-new" title="Added in October 2026">New</span> [American Time Use Survey](https://www.bls.gov/tus/): how Americans spend a day, activity by activity, every year since 2003, in small files with data dictionaries.
- <span class="badge-new" title="Added in October 2026">New</span> [National Longitudinal Surveys of Youth](https://www.bls.gov/nls/cohorts.htm) (NLSY97 and NLSY79): U.S. surveys that follow the same people for decades. You choose variables and download them in NLS Investigator. Better suited to the graduate section.
- <span class="badge-new" title="Added in October 2026">New</span> [SSA baby names](https://www.ssa.gov/oact/babynames/limits.html): how many U.S. babies got each first name, by year since 1880 and by state, in small text files. Names given to fewer than 5 babies are left out.
- <span class="badge-new" title="Added in October 2026">New</span> [Social Connectedness Index](https://data.humdata.org/dataset/social-connectedness-index): how likely people in two places are to be Facebook friends, for pairs of countries and of U.S. counties. The country file is under 1 MB.

#### Health

- <span class="badge-new" title="Added in October 2026">New</span> [WHO Global Health Observatory](https://www.who.int/data/gho): more than 3,000 health indicators for WHO member states, such as life expectancy and causes of death, free to download and also through an API with no key. WHO's [Global Health Estimates](https://www.who.int/data/global-health-estimates) add deaths and disease burden by cause, as Excel tables. Neither includes Taiwan.
- <span class="badge-new" title="Added in October 2026">New</span> [OECD Health Statistics](https://www.oecd.org/en/data/datasets/oecd-health-statistics.html): health spending, health care resources, and health outcomes for OECD and partner countries, free as CSV in the OECD Data Explorer. Taiwan is not included. For health spending and equity in lower-income countries, the World Bank's [HEFPI indicators](https://databank.worldbank.org/source/health-equity-and-financial-protection-indicators-(hefpi)) are a further source (DataBank data end in 2018).
- <span class="badge-new" title="Added in October 2026">New</span> [Global Burden of Disease](https://vizhub.healthdata.org/gbd-results/) (IHME): deaths, disease burden, and risk factors for 204 countries and territories, including Taiwan, 1990 to 2023. Downloads need a free account. Non-commercial use only, and posting the downloaded files is not allowed.
- <span class="badge-new" title="Added in October 2026">New</span> [WHO Mortality Database](https://www.who.int/data/data-collection-tools/who-mortality-database): registered deaths by cause, age, sex, and year from national death records; R reads the files directly. Non-commercial use. Better suited to the graduate section.
- <span class="badge-new" title="Added in October 2026">New</span> [IPUMS Global Health](https://globalhealth.ipums.org/): harmonized health surveys from many low- and middle-income countries (DHS, MICS, PMA). Free, but each team member registers and describes the project, and The DHS Program approves DHS requests. Sharing the files is not allowed.
- <span class="badge-new" title="Added in October 2026">New</span> [NHANES](https://www.cdc.gov/nchs/nhanes/index.html): U.S. health survey with interviews, physical exams, and lab tests. Free files, one per topic, that `haven::read_xpt()` reads; join them by the respondent id `SEQN`, and use the survey weights for national estimates.
- <span class="badge-new" title="Added in October 2026">New</span> [BRFSS](https://www.cdc.gov/brfss/index.html): yearly U.S. phone survey of about 350,000 adults on health behaviors and chronic conditions, by state. The yearly file is large, so keep only the columns you need.
- <span class="badge-new" title="Added in October 2026">New</span> [CDC WONDER mortality](https://wonder.cdc.gov/deaths-by-underlying-cause.html): U.S. deaths by county, year, age, sex, and cause, from 1968. You agree to its data use rules before each query, and you may not publish counts of 9 or fewer.
- <span class="badge-new" title="Added in October 2026">New</span> [NEISS](https://www.cpsc.gov/Research--Statistics/NEISS-Injury-Data): one row per emergency room visit for an injury involving a consumer product, from a sample of U.S. hospitals, with a short description of each case. Use the weight variable for national estimates.

#### Economy, jobs, and business

- [FRED](https://fred.stlouisfed.org/): hundreds of thousands of economic time series (prices, employment, interest rates), easy to download as CSV. Some series are copyrighted by their source; the series page says so.
- [World Bank Open Data](https://data.worldbank.org/) and [OECD Data Explorer](https://data-explorer.oecd.org/): country-level indicators over many years, free to download. World Bank data do not include Taiwan; some OECD tables include it as "Chinese Taipei".
- [Our World in Data](https://ourworldindata.org/): cleaned country-level data on many topics, with sources listed for every chart. [Gapminder](https://www.gapminder.org/data/) has longer versions of the `gapminder` data used in class, including its own estimates where sources have gaps.
- [U.S. Bureau of Labor Statistics](https://www.bls.gov/data/): employment, wages, prices, and productivity. If R cannot download a file, save it from your browser. Its [Quarterly Census of Employment and Wages](https://www.bls.gov/cew/downloadable-data-files.htm) gives jobs and wages by county and industry.
- [O\*NET](https://www.onetcenter.org/database.html): skills, abilities, and work activities for each U.S. occupation. The sample project on the undergraduate course page combined O\*NET with BLS wage data.
- <span class="badge-new" title="Added in October 2026">New</span> [County Business Patterns](https://www.census.gov/programs-surveys/cbp/data.html) and [Business Dynamics Statistics](https://www.census.gov/programs-surveys/bds.html): U.S. counts of businesses, jobs, and payroll by county and industry, and business startups and closures since 1978. Free CSV files; the latest year is 2023.
- <span class="badge-new" title="Added in October 2026">New</span> [Business Trends and Outlook Survey](https://www.census.gov/data/experimental-data-products/business-trends-and-outlook-survey.html): every two weeks, the share of U.S. businesses that report changes in revenue, jobs, and prices, and that use AI, by sector and state. Excel files.
- <span class="badge-new" title="Added in October 2026">New</span> [Survey of Consumer Finances](https://www.federalreserve.gov/econres/scfindex.htm): U.S. household income, assets, and debts, every three years (latest 2025). Each household appears five times in the file, so read the Federal Reserve's notes before you compute averages. Better suited to the graduate section.

#### Consumers, platforms, and reviews

- [Inside Airbnb](https://insideairbnb.com/get-the-data/): listings, prices, availability calendars, and reviews for cities around the world, including Taipei, updated quarterly. Only the last 12 months are free. Licensed CC BY 4.0, but the project asks users not to republish the data, so keep the raw files out of your public repository.
- [Yelp Open Dataset](https://business.yelp.com/data/resources/open-dataset/): businesses, reviews, and check-ins in 11 metropolitan areas, released for academic use. The download is 4.35 GB, so keep only the part you need. The terms do not allow sharing the files and ask you to send your findings to Yelp before any public presentation.
- [Amazon Reviews 2023](https://amazon-reviews-2023.github.io/): reviews and product information, split by product category. Start with one small category, such as Subscription Boxes (3 MB). No license is stated, so keep the raw files out of your public repository.
- <span class="badge-new" title="Added in October 2026">New</span> [Open e-commerce 1.0](https://doi.org/10.7910/DVN/YGLYDY): 1.85 million Amazon purchases by 5,027 U.S. users from 2018 to 2022, linked to their survey answers about age, income, and more. Free on Harvard Dataverse (CC0). The purchases file is 313 MB, so keep a subset.
- [MovieLens](https://grouplens.org/datasets/movielens/): movie ratings. The small version has about 100,000 ratings in a 1 MB download. The terms differ by version, so read the README of the version you use and commit only your code.
- [UCSD recommender-system datasets](https://cseweb.ucsd.edu/~jmcauley/datasets.html): reviews and behavior from Steam, Goodreads, and other platforms. Some files are not standard JSON and need conversion before R can read them.
- [Google Trends](https://trends.google.com/trends/) and [Wikipedia pageviews](https://pageviews.wmcloud.org/): attention to a topic over time. Google Trends values are an index from 0 to 100 based on a sample of searches, not counts.

#### Housing and real estate

- <span class="badge-new" title="Added in October 2026">New</span> [FHFA House Price Index](https://www.fhfa.gov/data/hpi/datasets?tab=additional-data): U.S. house price indexes by state, metro area, county, ZIP code, and census tract (public domain).
- <span class="badge-new" title="Added in October 2026">New</span> [Zillow Research data](https://www.zillow.com/research/data/): monthly U.S. home value and rent indexes (ZHVI and ZORI) as CSV files, with no login. Home values go down to ZIP codes and neighborhoods; rents start in 2015. Read Zillow's terms of use: they allow aggregate data to be used for market analysis if every page that shows the data cites "Data Provided by Zillow Group." Do not scrape Zillow's listing pages.
- <span class="badge-new" title="Added in October 2026">New</span> [HM Land Registry Price Paid Data](https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads): every residential sale in England and Wales since 1995, with price, date, address, and property type (Open Government Licence). Yearly CSV files are 115 to 230 MB and have no header row.

#### Cities and mobility

- [NYC taxi and ride-hailing trips](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page): trip records by month, with data dictionaries. Files are in Parquet format; read them with the `arrow` package. A green-taxi month is about 1 MB; a ride-hailing month is about 500 MB.
- [Citi Bike trip histories](https://citibikenyc.com/system-data): bike-share trips in New York by month. A New York month is about 1 GB zipped; Jersey City files are small. The license does not allow re-posting the raw files.
- [Google COVID-19 Community Mobility Reports](https://www.google.com/covid19/mobility/): daily change in visits to shops, transit stations, and workplaces by region, in percent compared with early 2020, from February 2020 to October 2022. Archived, still downloadable. Last year's graduate sample project used this data.
- <span class="badge-new" title="Added in October 2026">New</span> [Chicago Data Portal](https://data.cityofchicago.org/) and [NYC Open Data](https://data.cityofnewyork.us/): city records such as reported crimes (Chicago, since 2001), 911 calls (New York), and business licenses. Each dataset page explains its columns.
- <span class="badge-new" title="Added in October 2026">New</span> [Stanford Open Policing Project](https://openpolicing.stanford.edu/data/): records of police stops from dozens of U.S. cities and states, with a README for every column. The data end in 2020 or earlier.
- <span class="badge-new" title="Added in October 2026">New</span> [Fatality Analysis Reporting System](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars): every fatal motor vehicle crash in the U.S. since 1975, with a user manual. Each year is one zip of CSV files (33 MB for 2024).
- <span class="badge-new" title="Added in October 2026">New</span> [Open-Meteo](https://open-meteo.com/en/docs/historical-weather-api): daily or hourly weather for any place, including Taiwan, since 1940. No key is needed for non-commercial use (CC BY 4.0). Useful to merge with trips or sales.

#### Education

- <span class="badge-new" title="Added in October 2026">New</span> [Urban Institute Education Data Portal](https://educationdata.urban.org/documentation/): U.S. school, district, and college data (Common Core of Data, IPEDS) through one free API and the `educationdata` R package.
- <span class="badge-new" title="Added in October 2026">New</span> [Stanford Education Data Archive (SEDA)](https://edopportunity.org/opportunity/data/downloads/): test scores and achievement gaps for U.S. schools, districts, and counties, 2009 to 2019. Free with codebooks; no commercial use.

#### Politics and government

- <span class="badge-new" title="Added in October 2026">New</span> [Voteview](https://voteview.com/data): every roll-call vote in the U.S. Congress since 1789, with an ideology score for each member.
- <span class="badge-new" title="Added in October 2026">New</span> [V-Dem](https://www.v-dem.net/data/the-v-dem-dataset/): hundreds of democracy indicators by country and year, 1789 to 2025, including Taiwan (CC BY-SA 4.0).
- <span class="badge-new" title="Added in October 2026">New</span> [Quality of Government data](https://www.gu.se/en/quality-government/qog-data/data-downloads): country-level variables on government quality, corruption, and the economy, collected in one file with a codebook. Sharing the files is not allowed.

#### Policy changes and natural experiments

These help when your question is causal, because the policy change supplies the comparison.

- [Opportunity Insights](https://opportunityinsights.org/data/): data from published research on economic mobility, by neighborhood, college, and more. Free downloads.
- [Oxford COVID-19 Government Response Tracker](https://github.com/OxCGRT/covid-policy-dataset): daily policy measures for 185 countries, including Taiwan, from 2020 to 2022 (final version), with a codebook.
- [Correlates of State Policy](https://ippsr.msu.edu/public-policy/correlates-state-policy): more than 3,000 variables on policy differences across the 50 U.S. states and over time, though most variables end in 2017 or earlier. Start with the core file of about 100 variables. [LawAtlas](https://lawatlas.org/) has coded state and city health laws with the dates they changed (free account, non-commercial use).
- [MIT Election Data and Science Lab](https://electionlab.mit.edu/data): cleaned U.S. election returns by state, county, and precinct, up to 2024. For elections in other countries, including Taiwan, the [SAGE dataset](https://noahdasanaike.github.io/sage.html) has polling-station results for 134 countries.
- [FiveThirtyEight data](https://github.com/fivethirtyeight/data) and the [ProPublica Data Store archive](https://projects.propublica.org/datastore/): data behind news stories. Neither is updated any more. ProPublica's free datasets still download, but sharing the raw files is not allowed.

#### Sports

- <span class="badge-new" title="Added in October 2026">New</span> [Lahman Baseball Database](https://sabr.org/lahman-database/): season statistics for Major League Baseball players and teams, 1871 to 2025, as CSV files or the `Lahman` R package (CC BY-SA).
- <span class="badge-new" title="Added in October 2026">New</span> [nflverse](https://github.com/nflverse): NFL play-by-play and player statistics, through the `nflreadr` R package (CC BY 4.0).

#### Data from published studies

The [AEA Data and Code Repository](https://www.icpsr.umich.edu/sites/aea/home), [Harvard Dataverse](https://dataverse.harvard.edu/), and [Opportunity Insights](https://opportunityinsights.org/data/) hold the data behind published papers. These are some of the best-documented datasets you can find, though some packages leave out confidential data. **Rule:** your project must ask a question the original authors did not answer. Use their data to study something new, not to repeat their analysis.

#### Taiwan

- [data.gov.tw](https://data.gov.tw/en): Taiwan's government open data platform, with over 50,000 datasets that are free to reuse under the Open Government Data License. The site has an English interface, but most dataset titles and column names are in Chinese.
- [National Statistics, R.O.C. (Taiwan)](https://eng.stat.gov.tw/): official statistics in English, such as GDP growth, prices, unemployment, and earnings. If R cannot download a file, save it from your browser.
- [Survey Research Data Archive (SRDA)](https://srda.sinica.edu.tw/): Academia Sinica's archive of academic and government surveys of Taiwan. Membership is free; students upload proof of enrollment and wait 2 to 3 working days. The site is mostly in Chinese, and sharing the files is not allowed.
- Several international sources above include Taiwan: the World Values Survey, V-Dem, the Oxford COVID-19 tracker, SAGE, the Global Burden of Disease, and some OECD tables. World Bank Open Data and the WHO data do not.

Taiwan data are welcome. **If your data, codebook, or variable names are not in English, write the data description section of your proposal in English, with an English variable table (name, meaning, unit) for every variable you use.**

### 4. Collecting your own data

You do not have to use an existing dataset. Each option below takes more time than downloading one, so **talk to me before Milestone 2** if you plan any of them.

- **Run your own experiment.** Past PBA teams have run their own experiments, and this is a strong choice if your team is ready to spend the time and, often, some money. Decide in advance what you will randomize, what you will measure, and how many participants you need.
- **Run a survey.** Google Forms is enough for most projects. Ask only what you need, tell respondents how the data will be used, and do not publish anything that identifies them.
- **Scrape the web.** If the data exist online but cannot be downloaded, R's `rvest` package can collect them. Check the site's `robots.txt` and terms of service, keep your request rate low, and expect it to take longer than you think.
- **Code text with an LLM.** If your data are text, such as reviews or posts, a large language model can label them (topic, sentiment). Check a sample of its labels by hand and report how often it was right.

### 5. Before you commit: a checklist

Load the data in R before you write the proposal, and check:

- **The variables are there.** Your outcome (Y) and your key explanatory variable or treatment (X or T) are in the data and mostly filled in. If you want to compare subgroups, the grouping variable is there too.
- **There is enough data.** At least a few hundred observations, with real variation in Y and in X or T. You cannot study a variable that barely changes.
- **For a causal question, you know the comparison.** Write down which units or periods serve as the comparison, and why they are a fair one.
- **There is a codebook.** Save it next to the data file. You will need it to remember what each code means.
- **Cleaning is manageable.** Preparing data usually takes longer than analyzing it. Prefer a dataset that needs little recoding.
- **It fits on GitHub.** GitHub rejects files over 100 MB, and R slows down well before that. Keep the raw download out of the repository, and commit a script that subsets it plus the smaller file it produces.
- **You may share it.** Some licenses forbid redistribution. If so, commit your code and explain where readers can get the data.
- **It is ethical to use.** Think about who could be helped or harmed if the data concern people, especially on sensitive topics, and say so in your report.

### 6. Milestone 2: what the proposal covers

The proposal does not need to be formal, but it should run one to two pages and include a section that describes your data. Cover these points:

1. **Your research question,** in one sentence, and whether it is descriptive, predictive, or causal.
2. **Your hypothesis and the reason for it.** Why might the answer be yes? Say what earlier studies have found and where your question fits. Reading related papers and the studies they cite will help you find a new angle.
3. **A data description section:** the source and how the data were collected, the unit of observation, the period, the number of observations, and a table of the variables you will use (name, meaning, unit).
4. **Your key variables:** the explanatory variable or treatment and the outcome, and how each is measured.
5. **What would count as evidence.** Which pattern in the data would support your hypothesis, and which pattern would contradict it?

You are not locking anything in. You can change the question or the data later. The final report should read like a short research paper, so the question matters as much as the method. The project does not need to be groundbreaking: a careful, honest analysis of a question you care about is a good project.
