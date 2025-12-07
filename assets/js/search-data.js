// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "about",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-research",
          title: "research",
          description: "The corresponding author is denoted by *.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/research/";
          },
        },{id: "nav-teaching",
          title: "teaching",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/teaching/";
          },
        },{id: "nav-supervision",
          title: "supervision",
          description: "My thesis supervisions, past and present.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/supervision/";
          },
        },{id: "nav-cv",
          title: "cv",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "nav-blog",
          title: "blog",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/blog/";
          },
        },{id: "post-ddd-estimators-and-distributional-effects",
        
          title: 'DDD Estimators and Distributional Effects <svg width="1.2rem" height="1.2rem" top=".5rem" viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg"><path d="M17 13.5v6H5v-12h6m3-3h6v6m0-6-9 9" class="icon_svg-stroke" stroke="#999" stroke-width="1.5" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round"></path></svg>',
        
        description: "A discussion of recent developments in Difference-in-Differences (DDD) estimation, focusing on how to account for distributional effects....",
        section: "Posts",
        handler: () => {
          
            window.open("https://diddigest.substack.com/p/ddd-estimators-distributional-effects", "_blank");
          
        },
      },{id: "post-multi-armed-bandit-mab-as-an-alternative-to-a-b-testing-a-simulation-using-r",
        
          title: "Multi-Armed Bandit (MAB) as an Alternative to A/B Testing: a Simulation using R...",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2021/Multi_Armed_Bandit_(MAB)_as_an_Alternative_to_AB_Testing-_a_Simulation_Using_R/";
          
        },
      },{id: "post-scraping-the-online-job-posting-data-39-indeed-com-39",
        
          title: "Scraping the Online Job Posting Data: &#39;Indeed.com&#39;",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2019/Scraping_the_Online_Job_Posting_Data-_'Indeed.com'/";
          
        },
      },{id: "post-collection-of-useful-packages-cheat-sheets-r-and-python-and-tips",
        
          title: "Collection of Useful Packages, Cheat Sheets (R and Python), and Tips",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2019/Collection_of_Useful_Packages,_Cheat_Sheets_(R_and_Python),_and_Tips/";
          
        },
      },{id: "post-hand-rolling-ols-using-r",
        
          title: "Hand-Rolling OLS Using R",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2019/Hand_Rolling_OLS_Using_R/";
          
        },
      },{id: "post-places-to-visit-in-seoul-south-korea",
        
          title: "Places to visit in Seoul, South Korea",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2018/Places_to_visit_in_Seoul,_South_Korea/";
          
        },
      },{id: "post-crawling-the-annual-reports-i-e-10-ks-using-r",
        
          title: "Crawling the Annual Reports (i.e., 10-Ks) using R",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2017/Crawling_the_Annual_Reports_(i.e.,_10-Ks)_using_R/";
          
        },
      },{id: "books-the-godfather",
          title: 'The Godfather',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/the_godfather/";
            },},{id: "news-scholarly-speech-interdisciplinary-research-in-marketing-amp-amp-innovation-at-the-institute-of-service-science-national-tsing-hua-university-nthu",
          title: 'Scholarly speech: Interdisciplinary Research in Marketing &amp;amp;amp; Innovation at the Institute of Service...',
          description: "",
          section: "News",},{id: "news-brownbag-seminar-mobile-payment-and-in-store-mobile-purchase-behavior-at-the-college-of-technology-management-national-tsing-hua-university-nthu-hosted-by-prof-po-hsuan-hsu",
          title: 'Brownbag seminar: Mobile Payment and In-Store Mobile Purchase Behavior at the College of...',
          description: "",
          section: "News",},{id: "news-hosted-prof-yuxin-chen-new-york-university-nyu-for-an-invited-talk-on-managing-multi-rooming-why-uniform-price-can-be-optimal-for-a-monopoly-retailer-and-can-be-uniformly-lower-forthcoming-at-management-science",
          title: 'Hosted Prof. Yuxin Chen (New York University, NYU) for an invited talk on...',
          description: "",
          section: "News",},{id: "news-hosted-prof-minki-kim-kaist-college-of-business-for-an-invited-talk-on-zero-pricing-in-bundle-offers-does-it-reinforce-or-weaken-anticompetitive-effects",
          title: 'Hosted Prof. Minki Kim (KAIST College of Business) for an invited talk on...',
          description: "",
          section: "News",},{id: "news-hosted-prof-yuxin-chen-new-york-university-nyu-for-an-invited-talk-on-understanding-the-impacts-of-de-personalization-in-search-algorithm-a-field-experiment-with-a-large-online-retail-platform",
          title: 'Hosted Prof. Yuxin Chen (New York University, NYU) for an invited talk on...',
          description: "",
          section: "News",},{id: "news-scholarly-speech-emerging-topics-in-digital-economy-services-at-national-science-and-technology-council-nstc-2023-is-workshop",
          title: 'Scholarly speech: Emerging Topics in Digital Economy Services at National Science and Technology...',
          description: "",
          section: "News",},{id: "news-appointed-to-the-editorial-board-of-the-asia-marketing-journal-amj-the-flagship-journal-of-the-korean-marketing-association-kma-scopus-and-esci-indexed",
          title: 'Appointed to the Editorial Board of the Asia Marketing Journal (AMJ), the flagship...',
          description: "",
          section: "News",},{id: "news-invited-talk-empirical-causal-studies-in-is-at-the-college-of-management-national-sun-yat-sen-university-nsysu-hosted-by-prof-wenshin-chen",
          title: 'Invited talk: Empirical Causal Studies in IS at the College of Management, National...',
          description: "",
          section: "News",},{id: "news-invited-talk-empirical-causal-studies-in-is-at-the-institute-of-information-management-national-yang-ming-chiao-tung-university-nycu-hosted-by-prof-yungming-lee-amp-amp-prof-po-an-chen",
          title: 'Invited talk: Empirical Causal Studies in IS at the Institute of Information Management,...',
          description: "",
          section: "News",},{id: "news-invited-talk-review-of-causal-inference-methods-at-the-college-of-commerce-national-chengchi-university-nccu-hosted-by-prof-howard-hao-chun-chuang",
          title: 'Invited talk: Review of Causal Inference Methods at the College of Commerce, National...',
          description: "",
          section: "News",},{id: "news-invited-talk-a-quick-peek-at-causal-data-science-at-imba-research-methods-seminar-national-tsing-hua-university-nthu-hosted-by-prof-ali-ying-che-hsieh",
          title: 'Invited talk: A Quick Peek at Causal Data Science at iMBA Research Methods...',
          description: "",
          section: "News",},{id: "news-hosted-prof-steven-sungjun-park-nccu-for-an-invited-talk-on-it-s-all-about-timing-captive-targeting-through-mobile-ads-forthcoming-at-the-journal-of-advertising",
          title: 'Hosted Prof. Steven Sungjun Park (NCCU) for an invited talk on It’s All...',
          description: "",
          section: "News",},{id: "news-hosted-prof-po-an-chen-nycu-for-an-invited-talk-on-competitive-demand-learning-for-equilibrium-pricing-forthcoming-at-the-production-and-operations-management",
          title: 'Hosted Prof. Po-An Chen (NYCU) for an invited talk on Competitive Demand Learning...',
          description: "",
          section: "News",},{id: "news-hosted-prof-yu-jen-chen-ntu-for-an-invited-talk-on-how-and-why-does-product-review-guideline-bias-reviewing-behavior-the-role-of-sense-of-community",
          title: 'Hosted Prof. Yu-Jen Chen (NTU) for an invited talk on How and Why...',
          description: "",
          section: "News",},{id: "news-hosted-prof-bahman-rostami-tabar-cardiff-university-uk-for-an-invited-talk-on-forecasting-for-healthcare-operations-management",
          title: 'Hosted Prof. Bahman Rostami-Tabar (Cardiff University, UK) for an invited talk on Forecasting...',
          description: "",
          section: "News",},{id: "news-received-the-2025-emerging-scholar-research-award-from-the-college-of-technology-management-national-tsing-hua-university-nthu",
          title: 'Received the 2025 Emerging Scholar Research Award from the College of Technology Management,...',
          description: "",
          section: "News",},{id: "projects-project-1",
          title: 'project 1',
          description: "with background image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/1_project/";
            },},{id: "projects-project-2",
          title: 'project 2',
          description: "a project with a background image and giscus comments",
          section: "Projects",handler: () => {
              window.location.href = "/projects/2_project/";
            },},{id: "projects-project-3-with-very-long-name",
          title: 'project 3 with very long name',
          description: "a project that redirects to another website",
          section: "Projects",handler: () => {
              window.location.href = "/projects/3_project/";
            },},{id: "projects-project-4",
          title: 'project 4',
          description: "another without an image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/4_project/";
            },},{id: "projects-project-5",
          title: 'project 5',
          description: "a project with a background image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/5_project/";
            },},{id: "projects-project-6",
          title: 'project 6',
          description: "a project with no image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/6_project/";
            },},{id: "projects-project-7",
          title: 'project 7',
          description: "with background image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/7_project/";
            },},{id: "projects-project-8",
          title: 'project 8',
          description: "an other project with a background image and giscus comments",
          section: "Projects",handler: () => {
              window.location.href = "/projects/8_project/";
            },},{id: "projects-project-9",
          title: 'project 9',
          description: "another project with an image 🎉",
          section: "Projects",handler: () => {
              window.location.href = "/projects/9_project/";
            },},{id: "teaching-experiments-and-causal-inference",
          title: 'Experiments and Causal Inference',
          description: "A deep dive into experimental design and causal inference methods for business analytics.",
          section: "Teaching",handler: () => {
              window.location.href = "/teaching/eci/";
            },},{id: "teaching-programming-for-business-analytics",
          title: 'Programming for Business Analytics',
          description: "This course introduces the basics of programming using *R* for business applications.",
          section: "Teaching",handler: () => {
              window.location.href = "/teaching/pba/";
            },},{
        id: 'social-github',
        title: 'GitHub',
        section: 'Socials',
        handler: () => {
          window.open("https://github.com/j1yoo", "_blank");
        },
      },{
        id: 'social-scholar',
        title: 'Google Scholar',
        section: 'Socials',
        handler: () => {
          window.open("https://scholar.google.com/citations?user=6vinVNUAAAAJ", "_blank");
        },
      },{
        id: 'social-researchgate',
        title: 'ResearchGate',
        section: 'Socials',
        handler: () => {
          window.open("https://www.researchgate.net/profile/Jaewon-Yoo-3/", "_blank");
        },
      },{
        id: 'social-ssrn_id',
        title: 'Ssrn_id',
        section: 'Socials',
        handler: () => {
          window.open("", "_blank");
        },
      },{
        id: 'social-arxiv_id',
        title: 'Arxiv_id',
        section: 'Socials',
        handler: () => {
          window.open("", "_blank");
        },
      },{
        id: 'social-linkedin',
        title: 'LinkedIn',
        section: 'Socials',
        handler: () => {
          window.open("https://www.linkedin.com/in/jaewon-yoo", "_blank");
        },
      },{
        id: 'social-x',
        title: 'X',
        section: 'Socials',
        handler: () => {
          window.open("https://twitter.com/j1yoo4", "_blank");
        },
      },{
      id: 'light-theme',
      title: 'Change theme to light',
      description: 'Change the theme of the site to Light',
      section: 'Theme',
      handler: () => {
        setThemeSetting("light");
      },
    },
    {
      id: 'dark-theme',
      title: 'Change theme to dark',
      description: 'Change the theme of the site to Dark',
      section: 'Theme',
      handler: () => {
        setThemeSetting("dark");
      },
    },
    {
      id: 'system-theme',
      title: 'Use system default theme',
      description: 'Change the theme of the site to System Default',
      section: 'Theme',
      handler: () => {
        setThemeSetting("system");
      },
    },];
