# myproject

There are 2 different sample datasets in myproject: Adventureworks and SQLserverdatabase. Files of which names start with either "Adventureworks" or "SQLserverdatabase" belong respectively to each dataset. This is to showcase how to use SQL to extract data needed from the databases and Excel to visualize those data.

## ABOUT THE ADVENTUREWORKS
1. Credit for  this Adventureworks dummy dataset:
- The link to this dataset is incorporated in this blog post by Maz Nguyen:
https://madzynguyen.com/xay-dung-portfolio-cho-data-analyst-thanh-thao-sql/
 Since I do not own this dataset, please visit Maz nguyen's blog post via the link above for a direct download if needed.
- However, all of the SQL codes, AdventureWorks_ERD (Entities Relational Diagram) uploaded in this repository are self_written and designed.
  
2. AdventureWorks_ERD is to visualize the structure of the dummy database 

3. Data presented in Adventuresworks_topline_final is extracted by either using Excel power query, or Excel power pivot or SQL queries results.
 
## ABOUT SQLserverdatabase
1. Credit for  this SQLserverdatabase dataset:
sqlservertutorial.net provides readers with the SQL codes to construct the sample database. The codes are available for download in the below link:
https://www.sqlservertutorial.net/load-sample-database/
I ran the SQL codes to construct the database in MySQL and added one more table "Order_Status" 

2. I used the reverse engineer feature in MySQL to extract the database ERD (Entities Relational Diagram) to better visualize the structure of this sample database.


3. 'SQL queries for Dashboard' contains the SQL codes written to extract data from the database. This extracted data then loaded to the Reference tabs_Sales and Reference tabs_Orders of Excel file "Dashboard_report_final" which serve as the inputs of the Dashboard report.
