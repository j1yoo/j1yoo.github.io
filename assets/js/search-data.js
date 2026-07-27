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
  },{id: "nav-blog",
          title: "blog",
          description: "Articles and notes by Jaewon Yoo on causal inference, data science, and academic life.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/blog/";
          },
        },{id: "nav-research",
          title: "research",
          description: "The corresponding author is denoted by *. Video summaries 🎬 generated with NotebookLM.",
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
        },{id: "nav-talks",
          title: "talks",
          description: "List of invited talks and academic conference presentations.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/talks/";
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
          description: "Academic CV of Jaewon Yoo: education, publications, research experience, and professional activities.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "post-why-causal-mechanisms-are-harder-than-you-think",
        
          title: "Why Causal Mechanisms Are Harder Than You Think",
        
        description: "The hidden costs of explaining how something works: cross-world counterfactuals and heroic assumptions.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/Why_Causal_Mechanisms_Are_Harder_Than_You_Think/";
          
        },
      },{id: "post-why-better-models-can-create-stranger-counterfactuals",
        
          title: "Why Better Models Can Create Stranger Counterfactuals",
        
        description: "When AI explanations respect real-world constraints, the &quot;what-ifs&quot; become fewer but more meaningful.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/Why_Better_Models_Can_Create_Stranger_Counterfactuals/";
          
        },
      },{id: "post-what-directed-acyclic-graphs-dags-teach-us-about-choosing-covariates",
        
          title: "What Directed Acyclic Graphs (DAGs) Teach Us About Choosing Covariates",
        
        description: "Why adding more controls can backfire, and how causal graphs help you pick the right ones.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/What_Directed_Acyclic_Graphs_Teach_Us_About_Choosing_Covariates/";
          
        },
      },{id: "post-three-fundamental-conceptual-shifts-in-causal-inference",
        
          title: "Three Fundamental Conceptual Shifts in Causal Inference",
        
        description: "From missing data to survivor bias: three ideas that will reshape how you think about cause and effect.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/Three_Conceptual_Shifts_That_Will_Change_How_You_See_Causal_Inference/";
          
        },
      },{id: "post-significance-stars-a-cautionary-tale",
        
          title: "Significance Stars: A Cautionary Tale",
        
        description: "P-values, power, and the three types of significance: a guide to interpreting quantitative evidence.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/Significance_Stars_A_Cautionary_Tale/";
          
        },
      },{id: "post-ddd-estimators-and-distributional-effects",
        
          title: 'DDD Estimators and Distributional Effects <svg width="1.2rem" height="1.2rem" top=".5rem" viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg"><path d="M17 13.5v6H5v-12h6m3-3h6v6m0-6-9 9" class="icon_svg-stroke" stroke="#999" stroke-width="1.5" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round"></path></svg>',
        
        description: "A discussion of recent developments in Difference-in-Differences (DDD) estimation, focusing on how to account for distributional effects....",
        section: "Posts",
        handler: () => {
          
            window.open("https://diddigest.substack.com/p/ddd-estimators-distributional-effects", "_blank");
          
        },
      },{id: "post-one-sample-to-rule-them-all-the-subtle-power-of-the-bootstrap",
        
          title: "One Sample to Rule Them All? The Subtle Power of the Bootstrap",
        
        description: "How resampling from your own data can reveal an estimator&#39;s uncertainty: the logic and limits of the bootstrap.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/One_Sample_to_Rule_Them_All_The_Subtle_Power_of_the_Bootstrap/";
          
        },
      },{id: "post-multi-armed-bandit-mab-as-an-alternative-to-a-b-testing-a-simulation-using-r",
        
          title: "Multi-Armed Bandit (MAB) as an Alternative to A/B Testing: a Simulation using R...",
        
        description: "Earn while you learn: comparing bandit algorithms that optimize experiments in real time.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2021/Multi_Armed_Bandit_(MAB)_as_an_Alternative_to_AB_Testing-_a_Simulation_Using_R/";
          
        },
      },{id: "post-scraping-the-online-job-posting-data-39-indeed-com-39",
        
          title: "Scraping the Online Job Posting Data: &#39;Indeed.com&#39;",
        
        description: "Collecting 100k+ AI job postings from Indeed using R for labor market research.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2019/Scraping_the_Online_Job_Posting_Data_Indeed_com/";
          
        },
      },{id: "post-collection-of-useful-packages-cheat-sheets-r-and-python-and-tips",
        
          title: "Collection of Useful Packages, Cheat Sheets (R and Python), and Tips",
        
        description: "A curated list of go-to packages and resources for data science workflows.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2019/Collection_of_Useful_Packages,_Cheat_Sheets_(R_and_Python),_and_Tips/";
          
        },
      },{id: "post-hand-rolling-ols-using-r",
        
          title: "Hand-Rolling OLS Using R",
        
        description: "Deriving and coding OLS from scratch to understand what happens under the hood.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2019/Hand_Rolling_OLS_Using_R/";
          
        },
      },{id: "post-places-to-visit-in-seoul-south-korea",
        
          title: "Places to visit in Seoul, South Korea",
        
        description: "A local&#39;s guide to nightlife, culture, and hidden gems in Korea&#39;s capital.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2018/Places_to_visit_in_Seoul,_South_Korea/";
          
        },
      },{id: "post-crawling-the-annual-reports-i-e-10-ks-using-r",
        
          title: "Crawling the Annual Reports (i.e., 10-Ks) using R",
        
        description: "Automating SEC filings extraction with R for large-scale text analysis.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2017/Crawling_the_Annual_Reports_(i.e.,_10-Ks)_using_R/";
          
        },
      },{id: "gallery_events-34th-isms-marketing-science-conference",
          title: '34th ISMS Marketing Science Conference',
          description: "Attending the 2012 Marketing Science Conference with fellow participants.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/marketing-science-boston-2012/";
            },},{id: "gallery_events-36th-isms-marketing-science-conference",
          title: '36th ISMS Marketing Science Conference',
          description: "Attending the 2014 Marketing Science Conference with fellow participants.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/marketing-science-atlanta-2014/";
            },},{id: "gallery_events-global-ph-d-fellowship",
          title: 'Global Ph.D. Fellowship',
          description: "Receiving the Global Ph.D. Fellowship certificate.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/global-phd-fellowship-2014/";
            },},{id: "gallery_events-academy-of-management-annual-meeting",
          title: 'Academy of Management Annual Meeting',
          description: "Attending the 2015 annual meeting with fellow participants.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/aom-2015/";
            },},{id: "gallery_events-kellogg-qmse-workshop-2015",
          title: 'Kellogg QMSE Workshop 2015',
          description: "Participating in the Quantitative Marketing and Structural Econometrics Workshop at Kellogg.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/qmse-2015/";
            },},{id: "gallery_events-kaist-innovation-amp-entrepreneurship-research-bootcamp",
          title: 'KAIST Innovation &amp;amp; Entrepreneurship Research Bootcamp',
          description: "Taking part in research discussions at the first KAIST Innovation &amp; Entrepreneurship Research Bootcamp.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/kaist-innovation-bootcamp-2019/";
            },},{id: "gallery_events-yale-mit-china-india-insights-conference-2019",
          title: 'Yale–MIT China India Insights Conference 2019',
          description: "Presenting research at the Yale–MIT China India Insights Conference.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/china-india-insights-2019/";
            },},{id: "gallery_events-2019-dmac-dissertation-competition-best-paper-award",
          title: '2019 DMAC Dissertation Competition Best Paper Award',
          description: "Winning the Best Paper Award, the top prize in the KMA Doctoral Dissertation Competition at DMAC.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/dmac-2019/";
            },},{id: "gallery_events-nthu-ctm-brown-bag-seminar-2021",
          title: 'NTHU CTM Brown Bag Seminar 2021',
          description: "Presenting research at the College of Technology Management Brown Bag Seminar.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/nthu-brown-bag-2021/";
            },},{id: "gallery_events-hosted-research-seminar-yuxin-chen",
          title: 'Hosted Research Seminar: Yuxin Chen',
          description: "Hosting Prof. Yuxin Chen (NYU Shanghai) for an invited research seminar at NTHU.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/yuxin-chen-2023/";
            },},{id: "gallery_events-nstc-is-workshop-2023",
          title: 'NSTC IS Workshop 2023',
          description: "Giving a scholarly talk at the National Science and Technology Council IS Workshop.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/nstc-is-workshop-2023/";
            },},{id: "gallery_events-11th-aiea-nber-conference-2023",
          title: '11th AIEA–NBER Conference 2023',
          description: "Taking part in the conference and meeting fellow participants.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/aiea-nber-2023/";
            },},{id: "gallery_events-invited-talk-at-nsysu-2024",
          title: 'Invited Talk at NSYSU, 2024',
          description: "Presenting at the College of Management research seminar.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/nsysu-invited-talk-2024/";
            },},{id: "gallery_events-nycu-invited-talk-2024",
          title: 'NYCU Invited Talk 2024',
          description: "Giving an invited talk at the Institute of Information Management.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/nycu-invited-talk-2024/";
            },},{id: "gallery_events-hosted-research-seminar-steven-sungjun-park",
          title: 'Hosted Research Seminar: Steven Sungjun Park',
          description: "Hosting Prof. Steven Sungjun Park (National Chengchi University) for an invited research seminar at NTHU.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/steven-park-2024/";
            },},{id: "gallery_events-hosted-research-seminar-po-an-chen",
          title: 'Hosted Research Seminar: Po-An Chen',
          description: "Hosting Prof. Po-An Chen (NYCU) for an invited research seminar at NTHU.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/po-an-chen-2024/";
            },},{id: "gallery_events-digit-workshop-at-icis-2024",
          title: 'DIGIT Workshop at ICIS 2024',
          description: "Taking part in the DIGIT Workshop and ICIS 2024.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/icis-2024/";
            },},{id: "gallery_events-hosted-research-seminar-yu-jen-chen",
          title: 'Hosted Research Seminar: Yu-Jen Chen',
          description: "Hosting Prof. Yu-Jen Chen (National Taiwan University) for an invited research seminar at NTHU.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/yu-jen-chen-2024/";
            },},{id: "gallery_events-hosted-research-seminar-bahman-rostami-tabar",
          title: 'Hosted Research Seminar: Bahman Rostami-Tabar',
          description: "Hosting Prof. Bahman Rostami-Tabar (Cardiff University) for an invited research seminar at NTHU.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/bahman-rostami-tabar-2025/";
            },},{id: "gallery_events-2025-best-master-39-s-thesis-award-at-cmct-2026",
          title: '2025 Best Master&amp;#39;s Thesis Award at CMCT 2026',
          description: "Celebrating Zhan-Yi Liao&#39;s Best Master&#39;s Thesis Award with co-advisor Po-An Chen.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/zhanyi-2025-cmct/";
            },},{id: "gallery_events-tswim-2026",
          title: 'TSWIM 2026',
          description: "Co-organizing TSWIM 2026; presenting research; serving as a session chair and discussant in the Research Incubator; and taking part in career-development sessions.",
          section: "Gallery_events",handler: () => {
              window.location.href = "/gallery/tswim-2026/";
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
          section: "News",},{id: "news-welcomed-our-first-child-jeong-yoo-유정-兪晶-into-our-lives-on-april-6-2023",
          title: '👶 Welcomed our first child, Jeong Yoo (유정 / 兪晶), into our lives...',
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
          section: "News",},{id: "news-welcomed-our-second-child-ethan-yoo-유이산-兪貽汕-into-our-lives-on-september-27-2025",
          title: '👶 Welcomed our second child, Ethan Yoo (유이산 / 兪貽汕), into our lives...',
          description: "",
          section: "News",},{id: "news-ms-student-zhan-yi-liao-co-advised-with-po-an-chen-received-the-2025-best-master-39-s-thesis-award-from-the-algorithms-and-computation-theory-society-of-taiwan-to-be-presented-at-cmct-2026",
          title: 'MS student Zhan-Yi Liao (co-advised with Po-An Chen) received the 2025 Best Master&amp;#39;s...',
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
          description: "A graduate seminar on experimental and quasi-experimental designs for causal inference.",
          section: "Teaching",handler: () => {
              window.location.href = "/teaching/eci/";
            },},{id: "teaching-programming-for-business-analytics",
          title: 'Programming for Business Analytics',
          description: "This course introduces the basics of programming using R for business applications.",
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
        id: 'social-orcid',
        title: 'ORCID',
        section: 'Socials',
        handler: () => {
          window.open("https://orcid.org/0000-0003-1582-0020", "_blank");
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
