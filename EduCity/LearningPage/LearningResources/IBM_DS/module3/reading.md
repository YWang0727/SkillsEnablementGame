
[font_size={50}][b]Module 3 Detecting Patterns of Fraud with Data Analytics[/b][/font_size]

[font_size={40}][b]Introduction[/b][/font_size]

Throughout this Module, you will follow in the footsteps of Sally, a Data Analyst, as she works with her team and Watson Studio; to collect and prepare insurance data.

IBM Watson Studio empowers you to scale analysis across your organization to speed development time and simplify collaboration with data scientists, risk analysts, investigators, and other subject matter experts while adhering to strong governance and security posture. In order to respond to new types of fraud, waste, and abuse while minimizing false negatives and accelerating response, the platform continuously accommodates real-time data, monitors and detects fraudulent activities, and adapts as the patterns change and spot anomalies.

In this Module you will learn the following concepts:
[ul]Create a Watson Studio Project[/ul]
[ul]Upload and Refine Data[/ul]
[ul]Data Visualization[/ul]



[font_size={40}][b][center]Case Study - Episode 1[/center][/b][/font_size]

In this topic, we will be introduced to a case study focused on an Auto Insurance company, we will explore the business profile, the challenges related to existing business problems within the claims fraud department, and the involvement of the data science team to attempt to find a solution.

[font_size={30}][b]Auto Insurance Company[/b][/font_size]

5,000 employees, 650 million in operating revenue last year.

Providing insurance policies to individual car owners across the continental United States.

Drivers usually sign a six-month policy with an auto insurance policy. Each month, or all at once, the driver pays a fee, or premium, to the company.

[b]Policy Cost Factors[/b]

[b]Type of car insured[/b] - particularly its safety record and how expensive it is to repair. 

[b]Driver's record[/b] - average speeding tickets and age (teenagers cost more to insure because they're less experienced drivers, and therefore a bigger risk.) 

Lower-cost premiums are enjoyed by drivers with fewer accidents and tickets on their records, part-time drivers, people who take driver education courses, and families with multiple cars.

[b]Project Objective[/b]

An insurance company has been struggling to detect potentially fraudulent activity and has turned to IBM for their data science and AI offerings to predict fraud with insurance claims before the claim is settled.  

So what are some of the hypotheses that may flag the administrator that a fraud may be underway?

Such hypotheses or assumptions come about after extensive conversations with subject matter experts in the field of auto insurance. In this example, the following hypotheses are what the data scientist will attempt to prove or refute from this data set:
[ul]Identify auto insurance claims filed after the expiration of the insurance policy[/ul]
[ul]Claims filed after the license expiration date[/ul]
[ul]Excessive claim amount, which is over $10,000 in value[/ul]

[b]The Business Sponsor[/b]

Bob is our Business Sponsor - he will be in direct contact with the client, to ensure their needs are met by the Data Science Team.

[img=400]user://LearningPage/LearningResources/IBM_DS/module3/images/bob.png[/img]

[b]Background[/b]
[ul]36 years old[/ul]
[ul]8 years of experience[/ul]
[ul]Bob oversees the Fraud Claims Department[/ul]

[b]Situational[/b]
[ul]After meeting with the VP of the Auto Claims Division[/ul]
[ul]He has 30 days to provide analysis and a remediation plan to reduce insurance claim fraud[/ul]
[ul]Meeting with the Data Science Team next week[/ul]

Bob connects with the Data Science team:
[ul][b]Business Sponsor[/b] - Plan, define KPIs, and provide Feedback[/ul]
[ul][b]Developer[/b] - Development, Deployment & Monitoring[/ul]
[ul][b]Data Engineer[/b] - Integration & Refinement[/ul]
[ul][b]Data Scientist[/b] - Analysis & Modeling[/ul]
[ul][b]Data Analyst[/b] - Analysis & Visualization[/ul]



[font_size={40}][b][center]Milestone 1: Data Collection[/center][/b][/font_size]

In the Data Collection stage, data scientists will gain a good understanding of what techniques, such as descriptive statistics and visualization, can be applied to the dataset.

In this Milestone, you will create a Watson Studio Project and then upload a collected dataset.

[font_size={30}][b]Topic 1: Case Study - Episode 2[/b][/font_size]

Sally and Mike meet with the IT department team to collect the necessary data. Browse through the slides below to learn how the story develops.

After a week going through a back and forth with Ron’s team to confirm the size and scope of the sample dataset, and getting approvals to handle the personal sensitive information contained in the file.

Sally finally got access to the sample dataset named AutoInsClaims.csv

[b]Privacy Considerations[/b]

The dataset contains sensitive personal data, subject to data privacy regulations and will need to be removed.

Sally analyzes the information on the data they collected. Browse through the slides below to learn how the story develops.

[b]Data Understanding[/b]

Sally sifts through the actual data, looking for Data GAPS.

[b]Recap[/b] - Now that the data  has been cleaned, we removed columns containing sensitive information, and changed the data types from string to date for further analysis.

[b]Next[/b] - Sally goes through the information in the dataset, this time to make sure the data is understandable and ready for analysis.


[font_size={30}][b]Summary[/b][/font_size]

1)In this Milestone, you learned how to navigate the Project page of IBM Watson Studio and also how to upload a new asset to your project.



[font_size={40}][b][center]Milestone 2: Data Preparation[/center][/b][/font_size]

Data preparation is a self-service activity that converts disparate, raw, messy data into a clean and consistent view.

In this Milestone, you will refine data. This is a vital process for ensuring accurate results.


[font_size={30}][b]Topic 1: Case Study - Episode 3[/b][/font_size]

Sally and Maria meet to discuss which data analysis techniques to use on the data. Browse through the slides below to learn how the story develops

After data exploration and preparation

Data Scientists typically use descriptive statistics and data visualization techniques to:
[ul]Understand the data content.[/ul]
[ul]Assess data quality.[/ul]
[ul]Discover initial insights about the data.[/ul]

Additional data collection may be necessary to fill gaps. 

[b]Algorithm alignment[/b]

[center][img=1500]user://LearningPage/LearningResources/IBM_DS/module3/images/milestone2.png[/img][/center]

[b]Data formatting[/b]

Follow Sally now, as she uses the Data Refinery applying mathematics to aggregate the information, facilitating the application of statistical analysis to the sample data. 

Here we cover the following steps:
[ul]Apply mathematical operations[/ul]
[ul]Create column SUSPICIOUS_CLAIMS_TIME[/ul]
[ul]Create aggregator SUSPICIOUS_CLAIM_FLAG[/ul]
[ul]SUSPICIOUS_CLAIM_FLAG is of values 0 or 1[/ul]


[font_size={30}][b]Summary[/b][/font_size]

In this Milestone, you learned how to refine a data set. This creates a new data set within the project that we will use to visualize the data. 



[font_size={40}][b][center]Milestone 3: Finding Fraud Patterns with Data Representation[/center][/b][/font_size]

Data visualization is the process of translating large datasets and metrics into charts, graphs, and other visuals.

In this Milestone, you will use Watson Studio Data Representation to find patterns of fraud within the dataset. 


[font_size={30}][b]Topic 1: Case Study - Episode 4[/b][/font_size]

Browse through the slides below to refresh your understanding of how Data Exploration works and the different Data Visualization tools

[b]Data Representation : Exploratory Visualization[/b]

[center][img=500]user://LearningPage/LearningResources/IBM_DS/module3/images/milestone301.png[/img]
Summary statistics can be misleading on their own.
Visualizing the data enables you to prepare or revisit the summary statistics analysis contextualizing them as needed.

[img=500]user://LearningPage/LearningResources/IBM_DS/module3/images/milestone302.png[/img]
Making complex data accessible.
One form of powerful visualization is data on a map.

[img=500]user://LearningPage/LearningResources/IBM_DS/module3/images/milestone303.png[/img]
Effective visualization makes complex data more accessible, understandable, and usable.

[img=500]user://LearningPage/LearningResources/IBM_DS/module3/images/milestone304.png[/img]
If you can visualize diverse data through mapping, you can often do your analysis in half the time. 
Line and bar plots can also be useful in visually detecting trends such as positive or negative correlations.[/center]

[b]Sally meets with Maria to discuss how they can use visualization to discover patterns within the dataset[/b]

[center][img=1500]user://LearningPage/LearningResources/IBM_DS/module3/images/milestone305.png[/img][/center]
[center]Sally and Maria meet, once again, to confirm the project is ready for hand-off[/center]

[center][img=1500]user://LearningPage/LearningResources/IBM_DS/module3/images/milestone306.png[/img][/center]
[center]Maria will now take the project, Sally has prepared, in order to bring Visualization[/center]


[font_size={30}][b]Summary[/b][/font_size]

1)In this Milestone, you learned how to use Watson Studio to visualize a dataset and perform basic statistical analysis. 

2)Using this method you are able to turn thousands of numbers into a visual representation, that is much easier for someone to analyze. While this is not concrete proof and more analysis will be needed; images are an excellent way to quickly identify possible patterns within the data.



[font_size={40}][b][center]Summary of Module 3[/center][/b][/font_size]

1)From this Module, you have created an IBM Cloud Account, which provides you access to a wide range of IBM products. 

2)Using IBM Cloud you have created your first Watson Studio project. 

3)You have learned to upload data to Watson Studio Projects. 

4)With Watson's Data Visualization, you are able to create graphs and images allowing users to quickly identify data patterns. 
