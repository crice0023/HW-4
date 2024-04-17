# HW-4 Modern Workflow in Data Science
### Chris Rice
 # Wave 6 Country Analysis Project
## File Structure
![image](https://github.com/crice0023/HW-4/assets/161267590/3da3fc0e-28ad-42a2-89d8-17c78e33607d)

# Project Overview #
This project started by going to the following website to extract a particular
data set: [World Values Survey](http://www.worldvaluessurvey.org/WVSDocumentationWV6.jsp)

This data set called Wave 6 has the year range of 2010 - 2014. Users can download zip files
of different formats such as R, CSV, and SAS. First, however, you need to ask permission and fill out the purpose for requesting such data set/s. 

We ended up downloading the CSV which did not import as intended. We found the STATA
download much more user-friendly in terms of importing into R Studio. 

Then we created a smaller data frame from the original which was comprised of only the columns we were interested in as well as the all of the countries within the WAVE 6.
The app needed only one input: the country. Then followed by 4 sections or tab:
a. Overview: here you can say what is the aim of the app and guide the user in how to navigate it
b. Exploring attitudes to democracy (V228A-V228I) 
c. Exploring news consumption (V217-V224) 
d. Exploring attitudes to science (V192-197) 

We explored the data frame and noticed there were some NAs. Instead of removing the NAs we opted to impute any NA values within the columns with the median value of the column. 
The codebook might be useful to any interested parties. Variable definitions, or more specifically, questions asked along side answer choices can be found at the following location (please scroll down to find):
[Wave 6 Codebook](https://www.worldvaluessurvey.org/WVSDocumentationWV6.jsp)


Once we had our dataset where we wanted it to be we began the process of creating our Shiny App. Country was used as user-reference point with a convenient drop down. Within the App we have 5 tabs. 


![image](https://github.com/crice0023/HW-4/blob/main/Shiny_Layout_Photo.png)

We ended up adding 1 more tab than necessary to provide a link to the Codebook (see Variable Definitions tab) from the Shiny App. 
However, we also created an Overview, Attitudes to Democracy, News Consumption, and Attitudes to Science tab. Within these tabs users can select a country of interest and a plot will be presented along with a table of of the proportions plotted. In addition, each tab has an additional table that follows the initial table which represents the global proportions for the variables in view. 

Now users can explore and interact with Attitudes to Democracy, News Consumption, and Attitudes to Science tabs! 

Last, we established a connection to shinyapps.io and confirmed any interested parties could effectively see the output we created. Unfortunately, there was an initial issue that would not allow users to view the output. Specifically, we learned that we needed to add the df1 (dataframe) reference to our shiny app.R code. Once that was in place the problem was resolved. Here is a link to the shiny app [Shiny App Link](https://crice0023.shinyapps.io/Country/)

## Session Info

```
sessionInfo()
R version 4.3.0 (2023-04-21 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 19045)

Matrix products: default


locale:
[1] LC_COLLATE=English_United States.utf8  LC_CTYPE=English_United States.utf8   
[3] LC_MONETARY=English_United States.utf8 LC_NUMERIC=C                          
[5] LC_TIME=English_United States.utf8    

time zone: America/New_York
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] rsconnect_1.2.2      DT_0.33              shinydashboard_0.7.2
[4] shiny_1.8.1.1        tidyr_1.3.1          ggplot2_3.5.0       
[7] dplyr_1.1.4          haven_2.5.4         

loaded via a namespace (and not attached):
 [1] gtable_0.3.4       xfun_0.43          bslib_0.7.0        htmlwidgets_1.6.4 
 [5] tzdb_0.4.0         vctrs_0.6.5        tools_4.3.0        crosstalk_1.2.1   
 [9] generics_0.1.3     curl_5.2.1         tibble_3.2.1       fansi_1.0.6       
[13] pkgconfig_2.0.3    RColorBrewer_1.1-3 readxl_1.4.3       lifecycle_1.0.4   
[17] compiler_4.3.0     farver_2.1.1       textshaping_0.3.7  munsell_0.5.1     
[21] fontawesome_0.5.2  httpuv_1.6.15      htmltools_0.5.8.1  sass_0.4.9        
[25] yaml_2.3.8         later_1.3.2        pillar_1.9.0       crayon_1.5.2      
[29] jquerylib_0.1.4    openssl_2.1.1      cachem_1.0.8       sessioninfo_1.2.2 
[33] mime_0.12          tidyselect_1.2.1   digest_0.6.34      purrr_1.0.2       
[37] labeling_0.4.3     forcats_1.0.0      fastmap_1.1.1      grid_4.3.0        
[41] colorspace_2.1-0   cli_3.6.2          magrittr_2.0.3     utf8_1.2.4        
[45] readr_2.1.5        withr_3.0.0        scales_1.3.0       promises_1.3.0    
[49] rmarkdown_2.26     cellranger_1.1.0   askpass_1.2.0      ragg_1.3.0        
[53] hms_1.1.3          memoise_2.0.1      evaluate_0.23      knitr_1.46        
[57] rlang_1.1.3        Rcpp_1.0.12        xtable_1.8-4       glue_1.7.0        
[61] renv_1.0.7         rstudioapi_0.16.0  jsonlite_1.8.8     R6_2.5.1          
[65] systemfonts_1.0.6 
```
