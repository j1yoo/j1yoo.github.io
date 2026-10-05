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
nav: false
---

Finding data is the biggest single step of the team project. Use **real data**: records that someone collected for a real purpose, or data your team collects itself. Synthetic data made to test machine-learning models, which is common on Kaggle, cannot tell you anything about the world. There are two ways in, and both are fine: start from a question and look for data that can answer it, or start from an interesting dataset and ask what it can answer. **Milestone 2 (data and proposal) is due Sunday, October 25.**

### 1. Know what kind of question you are asking

Your question is one of three kinds, and the kind decides what counts as a good answer.

- **Describe.** What does the world look like? *How do Airbnb prices in Taipei vary across districts?* A careful description is a good project on its own.
- **Predict.** Can we forecast something we have not seen yet? *Which new listings will get their first booking within a month?* What counts is how well the prediction does on data the model has not seen.
- **Explain a cause.** Does T change Y? *Did a city's short-term rental rule lower rents?* Here you need a reason why your comparison is fair: a policy that starts at different times in different places (difference-in-differences), a group you can compare before and after, or variables you can control for, as in Weeks 4 and 5. The graduate section's project needs this kind of identification argument.

### 2. Finding a question

- **Start from what you care about.** You will spend weeks on this. Pick something you have read about, argued about, or wondered about.
- **Ask "compared to what?"** Every claim hides a comparison: compared to last year, to another city, to people who did not use the service. Naming the comparison tells you what data you need.
- **Narrow it down to one sentence.** "Online shopping" is a topic. "Did same-day delivery raise order frequency in cities where it launched first?" is a question.
- **Starting from the data is fine.** Browse the lists below, open a dataset, and ask what it could tell you.

### 3. Where to look

#### Search engines and archives

- [Google Dataset Search](https://datasetsearch.research.google.com/): a search engine for datasets across the web. A good first stop.
- [Harvard Dataverse](https://dataverse.harvard.edu/): data behind published research, searchable by topic.
- [ICPSR](https://www.icpsr.umich.edu/): a large social science data archive. Some files need a login from a member institution.
- [Data.gov](https://catalog.data.gov/dataset): open data from the U.S. federal government.
- [Kaggle Datasets](https://www.kaggle.com/datasets): use with care. Many Kaggle datasets have no codebook and no stated origin. A Kaggle dataset is acceptable only if you can find and document where the data originally came from.

#### People and households: surveys and census data

- [IPUMS](https://www.ipums.org/): U.S. census and survey microdata (ACS, CPS) and census samples from many countries, harmonized across years. Free, with registration.
- [General Social Survey](https://gss.norc.org/): attitudes and behavior of U.S. adults, repeated since 1972.
- [Pew Research Center datasets](https://www.pewresearch.org/datasets/): surveys on technology, media, and society. Free account required.
- [World Values Survey](https://www.worldvaluessurvey.org/): values and beliefs across many countries, including Taiwan.

#### Economy, jobs, and business

- [FRED](https://fred.stlouisfed.org/): thousands of economic time series (prices, employment, interest rates), easy to download.
- [World Bank Open Data](https://data.worldbank.org/) and [OECD Data Explorer](https://data-explorer.oecd.org/): country-level indicators over many years.
- [Our World in Data](https://ourworldindata.org/): cleaned country-level data on many topics, with sources listed for every chart.
- [U.S. Bureau of Labor Statistics](https://www.bls.gov/data/): employment, wages, prices, and productivity.
- [O\*NET](https://www.onetcenter.org/database.html): skills, abilities, and work activities for each U.S. occupation. The sample project on the undergraduate course page combined O\*NET with BLS wage data.

#### Consumers, platforms, and reviews

- [Inside Airbnb](https://insideairbnb.com/get-the-data/): listings, prices, availability calendars, and reviews for cities around the world, including Taipei, updated quarterly. Licensed CC BY 4.0.
- [Yelp Open Dataset](https://business.yelp.com/data/resources/open-dataset/): businesses, reviews, and check-ins in 11 metropolitan areas, released for educational use. The download is 4.35 GB, so keep only the part you need.
- [Amazon Reviews 2023](https://amazon-reviews-2023.github.io/): reviews and product information, split by product category. Start with one small category.
- [MovieLens](https://grouplens.org/datasets/movielens/): movie ratings. The license does not allow public redistribution, so keep the raw files out of your public repository and commit only your code.
- [UCSD recommender-system datasets](https://cseweb.ucsd.edu/~jmcauley/datasets.html): reviews and behavior from Steam, Goodreads, and other platforms.
- [Google Trends](https://trends.google.com/trends/) and [Wikipedia pageviews](https://pageviews.wmcloud.org/): attention to a topic over time.

#### Cities and mobility

- [NYC taxi and ride-hailing trips](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page): trip records by month, with data dictionaries. Files are in Parquet format; read them with the `arrow` package.
- [Citi Bike trip histories](https://citibikenyc.com/system-data): bike-share trips in New York by month.
- [Google COVID-19 Community Mobility Reports](https://www.google.com/covid19/mobility/): daily visits to shops, transit, and workplaces by region, February 2020 to October 2022. Archived, still downloadable. Last year's graduate sample project used this data.

#### Policy changes and natural experiments

These help when your question is causal, because the policy change supplies the comparison.

- [Opportunity Insights](https://opportunityinsights.org/data/): data from published research on economic mobility, by neighborhood, college, and more. Free downloads.
- [Oxford COVID-19 Government Response Tracker](https://github.com/OxCGRT/covid-policy-dataset): daily policy measures by country, with a codebook.
- [Correlates of State Policy](https://ippsr.msu.edu/public-policy/correlates-state-policy): more than 3,000 variables on policy differences across the 50 U.S. states and over time.
- [MIT Election Data and Science Lab](https://electionlab.mit.edu/data): cleaned U.S. election returns.
- [FiveThirtyEight data](https://github.com/fivethirtyeight/data) and the [ProPublica Data Store archive](https://projects.propublica.org/datastore/): data behind news stories. The ProPublica archive is no longer updated, and some of its datasets are free.

#### Data from published studies

The [AEA Data and Code Repository](https://www.icpsr.umich.edu/sites/aea/home), [Harvard Dataverse](https://dataverse.harvard.edu/), and [Opportunity Insights](https://opportunityinsights.org/data/) hold the data behind published papers. These are some of the best-documented datasets you can find. **Rule:** your project must ask a question the original authors did not answer. Use their data to study something new, not to repeat their analysis.

#### Taiwan

- [data.gov.tw](https://data.gov.tw/en): Taiwan's government open data platform. The site has an English interface, but many datasets and column names are in Chinese.
- [National Statistics, R.O.C. (Taiwan)](https://eng.stat.gov.tw/): official statistics in English, such as GDP growth, prices, unemployment, and earnings.
- [Survey Research Data Archive (SRDA)](https://srda.sinica.edu.tw/): Academia Sinica's archive of academic surveys of Taiwan. The site is mostly in Chinese and requires sign-up.

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
2. **Your hypothesis and the reason for it.** Why might the answer be yes? A plausible mechanism matters more than a citation.
3. **A data description section:** the source and how the data were collected, the unit of observation, the period, the number of observations, and a table of the variables you will use (name, meaning, unit).
4. **Your key variables:** the explanatory variable or treatment and the outcome, and how each is measured.
5. **What would count as evidence.** Which pattern in the data would support your hypothesis, and which pattern would contradict it?

You are not locking anything in. You can change the question or the data later. The project does not need to be groundbreaking: a careful, honest analysis of a question you care about is a good project.
