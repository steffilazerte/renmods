# renmods

``` r
library(renmods)
```

Download/update the data and save to your cache.

``` r
renmods_update(type = "all")
```

Connect to the database ENMODS table

``` r
db <- renmods_connect()
#> ℹ Connecting to "this_yr", "yr_2_5", "yr_5_10", and "historic" data
#> ✔ this_yr: Last downloaded 2026-03-04 10:44:26 (within 1 week(s))
#> ✔ yr_2_5: Last downloaded 2026-03-02 18:13:49 (within 26 week(s))
#> ✔ yr_5_10: Last downloaded 2026-03-02 18:14:58 (within 26 week(s))
#> ✔ historic: Last downloaded 2026-03-02 18:17:33 (within 26 week(s))
```

Optionally, prefilter by data type or date range.

``` r
db <- renmods_connect(type = "this_yr")
#> ℹ Connecting to "this_yr" data
#> ✔ this_yr: Last downloaded 2026-03-04 10:44:26 (within 1 week(s))
db <- renmods_connect(dates = c("2024-12-15", "2025-01-15"))
#> ℹ Connecting to "this_yr" and "yr_2_5" data for dates between 2024-12-15 and 2025-01-15
#> ✔ this_yr: Last downloaded 2026-03-04 10:44:26 (within 1 week(s))
#> ✔ yr_2_5: Last downloaded 2026-03-02 18:13:49 (within 26 week(s))
db <- renmods_connect(dates = c("2026-01-01", "2026-01-31"))
#> ℹ Connecting to "this_yr" data for dates between 2026-01-01 and 2026-01-31
#> ✔ this_yr: Last downloaded 2026-03-04 10:44:26 (within 1 week(s))
```

Collect the data into a data frame (from a database connection) for
working/saving. The smaller the data set and the fewer data types, the
fast this will go.

``` r
df <- collect(db)
```

Or use the dplyr package to do more filtering before you collect the
data.

``` r
library(dplyr)
```

First we’ll check out what’s in the data by exploring the first couple
data points

``` r
glimpse(db)
#> Rows: ??
#> Columns: 68
#> Database: DuckDB 1.4.4 [steffi@Linux 6.17.0-14-generic:R 4.5.2/:memory:]
#> $ Ministry_Contact                <chr> "Breanne Hill", "Breanne Hill", "Winnie Chan", "…
#> $ Sampling_Agency                 <chr> "74 - Permittee", "74 - Permittee", "74 - Permit…
#> $ Project                         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Project_Name                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Work_Order_number               <chr> "VA26A0226", "VA26A0232", "FJ2600022", "121157",…
#> $ Location_ID                     <chr> "E303052", "E298312", "E261281", "E218582", "E32…
#> $ Location_Name                   <chr> "MINE WATER TREATMENT PLANT INFLUENT PRETIUM", "…
#> $ Location_Type                   <chr> "In-Plant", "River, Stream, or Creek", "Outfall"…
#> $ Location_Latitude               <dbl> 56.46830, 56.46960, 56.06164, 49.91900, 55.39394…
#> $ Location_Longitude              <dbl> -130.1857, -130.1878, -121.2492, -125.4770, -121…
#> $ Location_Elevation              <dbl> NA, 1400, NA, NA, NA, NA, NA, NA, NA, NA, NA, 99…
#> $ Location_Elevation_Units        <chr> NA, "metre", NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ Location_Group                  <chr> NA, "107835", "17756", "7008", "17679", "17679",…
#> $ Field_Visit_Start_Time          <dttm> 2026-01-05 22:35:00, 2026-01-05 18:50:00, 2026-…
#> $ Field_Visit_End_Time            <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ Field_Visit_Participants        <chr> "B G    G W", "B G    G W", "KE/KT", NA, "RYAN S…
#> $ Field_Comment                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Field_Filtered                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
#> $ Field_Filtered_Comment          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Field_Preservative              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Field_Device_ID                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Field_Device_Type               <chr> NA, NA, NA, NA, NA, NA, NA, NA, "Field sampling"…
#> $ Sampling_Context_Tag            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Collection_Method               <chr> "Time Composite: Segmented Discrete", "Grab", "G…
#> $ Medium                          <chr> "Water - Waste", "Water - Fresh", "Water - Waste…
#> $ Taxonomy                        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Taxonomy_Common_Name            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Depth_Upper                     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Depth_Lower                     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Depth_Unit                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Observed_Date_Time              <dttm> 2026-01-05 22:35:00, 2026-01-05 18:50:00, 2026-…
#> $ Observed_Date_Time_Start        <chr> "2026-01-05T14:35-08:00", "2026-01-05T10:50-08:0…
#> $ Observed_Date_Time_End          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Observed_Property_ID            <chr> "Cadmium Total (fl. conc.)", "Arsenic Total (fl.…
#> $ Observed_Property_Description   <chr> "Metals - Total; EMS code: CD-T", "Metals - Tota…
#> $ Observed_Property_Analysis_Type <chr> "CHEMICAL", "CHEMICAL", "CHEMICAL", "CHEMICAL", …
#> $ Observed_Property_Result_Type   <chr> "NUMERIC", "NUMERIC", "NUMERIC", "NUMERIC", "NUM…
#> $ Observed_Property_Name          <chr> "CD-T", "AS-T", "AL-T", "LI-D", "SI-T", "P--T", …
#> $ CAS_Number                      <chr> "7440-43-9", "7440-38-2", "7429-90-5", NA, "7440…
#> $ Result_Value                    <dbl> 2.89e-03, 3.52e-03, 4.83e-02, 3.90e-03, 3.05e+00…
#> $ Method_Detection_Limit          <dbl> 1.0e-05, 1.0e-04, 3.0e-03, 2.0e-03, 1.0e-01, 2.0…
#> $ Method_Reporting_Limit          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Result_Unit                     <chr> "mg/L", "mg/L", "mg/L", "mg/L", "mg/L", "mg/L", …
#> $ Detection_Condition             <chr> NA, NA, NA, NA, NA, NA, "NOT_DETECTED", "NOT_DET…
#> $ Composite_Stat                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Fraction                        <chr> "TOTAL", "TOTAL", "TOTAL", "DISSOLVED", "TOTAL",…
#> $ Data_Classification             <chr> "LAB", "LAB", "LAB", "LAB", "LAB", "LAB", "LAB",…
#> $ Analyzing_Agency                <chr> "ALS", "ALS", "ALS", "MX", "ALS", "ALS", "ALS", …
#> $ Analyzing_Agency_Full_Name      <chr> "ALS Global", "ALS Global", "ALS Global", "Burea…
#> $ Analysis_Method                 <chr> "Aliquot:HNO3/HCL dig:ICPMS", "Aliquot:HNO3/HCL …
#> $ Analyzed_Date_Time              <chr> "2026-01-10T00:00-08:00", "2026-01-10T00:00-08:0…
#> $ Result_Status                   <chr> "Preliminary", "Preliminary", "Preliminary", "Pr…
#> $ Result_Grade                    <chr> "Ungraded", "Ungraded", "Ungraded", "Ungraded", …
#> $ Activity_Name                   <chr> "4793547;REGULAR;;Water - Waste;E303052;2026-01-…
#> $ Tissue_Type                     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Lab_Arrival_Temperature         <dbl> NA, NA, NA, 5, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ Specimen_Name                   <chr> "Metals - Total", "Metals - Total", "Metals - To…
#> $ Lab_Quality_Flag                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Lab_Arrival_Date_Time           <chr> "2026-01-06T21:15-08:00", "2026-01-06T21:15-08:0…
#> $ Lab_Prepared_Date_Time          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Lab_Sample_ID                   <chr> "003", "001", "002", "DZD195", "002", "008", "00…
#> $ Lab_Dilution_Factor             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Lab_Comment                     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Lab_Batch_ID                    <chr> "VA26A0226", "VA26A0232", "FJ2600022", "C200214"…
#> $ QC_Type                         <chr> "NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMAL"…
#> $ QC_Source_Activity_Name         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ Analysis_Method_ID              <chr> "F082", "F082", "F082", "F032", "F082", "X257", …
#> $ filename                        <chr> "/home/steffi/.local/share/R/renmods/this_yr.csv…
```

Remind yourself of the column names

``` r
colnames(db)
#>  [1] "Ministry_Contact"                "Sampling_Agency"                
#>  [3] "Project"                         "Project_Name"                   
#>  [5] "Work_Order_number"               "Location_ID"                    
#>  [7] "Location_Name"                   "Location_Type"                  
#>  [9] "Location_Latitude"               "Location_Longitude"             
#> [11] "Location_Elevation"              "Location_Elevation_Units"       
#> [13] "Location_Group"                  "Field_Visit_Start_Time"         
#> [15] "Field_Visit_End_Time"            "Field_Visit_Participants"       
#> [17] "Field_Comment"                   "Field_Filtered"                 
#> [19] "Field_Filtered_Comment"          "Field_Preservative"             
#> [21] "Field_Device_ID"                 "Field_Device_Type"              
#> [23] "Sampling_Context_Tag"            "Collection_Method"              
#> [25] "Medium"                          "Taxonomy"                       
#> [27] "Taxonomy_Common_Name"            "Depth_Upper"                    
#> [29] "Depth_Lower"                     "Depth_Unit"                     
#> [31] "Observed_Date_Time"              "Observed_Date_Time_Start"       
#> [33] "Observed_Date_Time_End"          "Observed_Property_ID"           
#> [35] "Observed_Property_Description"   "Observed_Property_Analysis_Type"
#> [37] "Observed_Property_Result_Type"   "Observed_Property_Name"         
#> [39] "CAS_Number"                      "Result_Value"                   
#> [41] "Method_Detection_Limit"          "Method_Reporting_Limit"         
#> [43] "Result_Unit"                     "Detection_Condition"            
#> [45] "Composite_Stat"                  "Fraction"                       
#> [47] "Data_Classification"             "Analyzing_Agency"               
#> [49] "Analyzing_Agency_Full_Name"      "Analysis_Method"                
#> [51] "Analyzed_Date_Time"              "Result_Status"                  
#> [53] "Result_Grade"                    "Activity_Name"                  
#> [55] "Tissue_Type"                     "Lab_Arrival_Temperature"        
#> [57] "Specimen_Name"                   "Lab_Quality_Flag"               
#> [59] "Lab_Arrival_Date_Time"           "Lab_Prepared_Date_Time"         
#> [61] "Lab_Sample_ID"                   "Lab_Dilution_Factor"            
#> [63] "Lab_Comment"                     "Lab_Batch_ID"                   
#> [65] "QC_Type"                         "QC_Source_Activity_Name"        
#> [67] "Analysis_Method_ID"              "filename"
```

Now we can filter by column values and collect the data into R

``` r
df <- db |>
  filter(Location_ID %in% c("E303052", "E309247")) |>
  collect()

df
#> # A tibble: 318 × 68
#>    Ministry_Contact Sampling_Agency Project Project_Name Work_Order_number Location_ID
#>    <chr>            <chr>           <chr>   <chr>        <chr>             <chr>      
#>  1 Breanne Hill     74 - Permittee  <NA>    <NA>         VA26A0226         E303052    
#>  2 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600007         E309247    
#>  3 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600040         E309247    
#>  4 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600007         E309247    
#>  5 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600040         E309247    
#>  6 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600007         E309247    
#>  7 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600040         E309247    
#>  8 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600007         E309247    
#>  9 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600040         E309247    
#> 10 Winnie Chan      74 - Permittee  <NA>    <NA>         FJ2600007         E309247    
#> # ℹ 308 more rows
#> # ℹ 62 more variables: Location_Name <chr>, Location_Type <chr>, Location_Latitude <dbl>,
#> #   Location_Longitude <dbl>, Location_Elevation <dbl>, Location_Elevation_Units <chr>,
#> #   Location_Group <chr>, Field_Visit_Start_Time <dttm>, Field_Visit_End_Time <dttm>,
#> #   Field_Visit_Participants <chr>, Field_Comment <chr>, Field_Filtered <lgl>,
#> #   Field_Filtered_Comment <chr>, Field_Preservative <chr>, Field_Device_ID <chr>,
#> #   Field_Device_Type <chr>, Sampling_Context_Tag <chr>, Collection_Method <chr>, …
```

You can also pre-select your columns of interest.

``` r
df <- db |>
  filter(Location_ID %in% c("E303052", "E309247")) |>
  select(
    "Location_ID",
    "Location_Name",
    "Observed_Date_Time",
    "Observed_Property_Name",
    "Result_Value",
    "Result_Unit",
    "Analysis_Method_ID"
  ) |>
  collect()

df
#> # A tibble: 318 × 7
#>    Location_ID Location_Name       Observed_Date_Time  Observed_Property_Name Result_Value
#>    <chr>       <chr>               <dttm>              <chr>                         <dbl>
#>  1 E303052     MINE WATER TREATME… 2026-01-05 22:35:00 CD-T                        0.00289
#>  2 E309247     CONUMA - BRULE MIN… 2026-01-02 20:19:01 P--T                        0.008  
#>  3 E309247     CONUMA - BRULE MIN… 2026-01-07 20:20:00 BI-T                        0.0001 
#>  4 E309247     CONUMA - BRULE MIN… 2026-01-02 20:19:00 CU-T                        0.001  
#>  5 E309247     CONUMA - BRULE MIN… 2026-01-07 20:20:00 SB-D                        0.00105
#>  6 E309247     CONUMA - BRULE MIN… 2026-01-02 20:19:00 B--D                        0.298  
#>  7 E309247     CONUMA - BRULE MIN… 2026-01-07 20:20:00 NA-T                      252      
#>  8 E309247     CONUMA - BRULE MIN… 2026-01-02 20:19:00 S--D                      378      
#>  9 E309247     CONUMA - BRULE MIN… 2026-01-07 20:20:00 U--D                        0.0229 
#> 10 E309247     CONUMA - BRULE MIN… 2026-01-02 20:19:00 1106                        0.4    
#> # ℹ 308 more rows
#> # ℹ 2 more variables: Result_Unit <chr>, Analysis_Method_ID <chr>
```

Don’t forget to close the connection to the database

``` r
renmods_disconnect(db)
```
