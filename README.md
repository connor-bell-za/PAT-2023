# Grade 12 IT Practical Assessment Task 2023
## What is the Practical Assessment Task (PAT)? 
A practical assessment task (PAT) mark is a compulsory component of the final
promotion mark for all candidates offering subjects that have a practical component
and counts 25% (100 marks) of the end-of-the-year examination mark. The PAT is
implemented across the first three terms of the school year. This is broken down into
different phases or a series of smaller activities that make up the PAT. The PAT
allows for learners to be assessed on a regular basis during the school year and it
also allows for the assessment of skills that cannot be assessed in a written format,
e.g. test or examination. It is therefore important that schools ensure that all learners
complete the practical assessment tasks within the stipulated period to ensure that
learners are resulted at the end of the school year. The planning and execution of the
PAT differs from subject to subject.

## About PAT-2023 
The 2023 PAT is a limited, climate analysis and tracking tool that also shows live weather data and a weather forecast as well as what a climate footprint is and what you can do to reduce it. The application also lets you use the WWF Environmental Footprint calculator and shows recent climate events across South Africa. 
***
## Screenshots 
Images showing the various screens of the application, what they do and how they look. 

### Weather
<img src="Weather.PNG" width="245" height="164"> <img src="Overcast Clouds.PNG" width="245" height="164"> <img src="Clear Sky.PNG" width="245" height="164">
- View current and forecasted weather for a specific location.

### Climate Action & News 
<img src="Save the Planet.PNG" width="245" height="164"> <img src="Carbon Footprint.PNG" width="245" height="164"> <img src="News.PNG" width="245" height="164">
- View information about a Carbon Footprint and how to reduce yours.
- Calculate your Carbon Footprint using the WWF Environmental Footprint Calculator.
- View recent climate news. 

### Settings 
<img src="Settings Connected.png" width="245" height="164"> <img src="Settings Disconnected.png" width="245" height="164"> <img src="Settings Connection Failed.png" width="245" height="164"> 
- Manage the connection to the climate database.
- Change the database location.
- Manage the OpenAI API Key for the AI climate discussion. 
- Restart the application.

### Climate Analysis
<img src="Climate.PNG" width="245" height="164"> <img src="Climate Graph.PNG" width="245" height="164"> <img src="Discussion.PNG" width="245" height="164">
- View up-to-date climate data, like annual average temperature and rainfall data for certain South African cities.
- View temperature and rainfall data in a graph and in a table.
- View the graphed climate trend for temperature and rainfall.
- Export/Print data and graphs.
- View information about a city.
- Read the OpenAI ChatGPT climate trend discussion.   

### Data Management 
<img src="Login.PNG" width="245" height="164"> <img src="SQL Query.PNG" width="245" height="164"> <img src="Capture Data.PNG" width="245" height="164"> 
- Query the database using SQL (Create, Read, Update and Delete).
- Export the query results.
- View activity within the system.
- Capture data for the database.

### About Screen
<img src="About Screen.PNG" width="245" height="164">

- View application license and developer information. 
- View application version information. 
***

## How to use PAT-2023 
Visit ```Releases``` and **download** the latest edition of the application. 

### Database 
- The database name is ```PATDB.mdb``` and MUST be stored in the same working folder as the EXE. The EXE should be named ```PAT-2023.exe```.
- The database stores information about places, cliamtes and news. The database also stores temperature and rainfall data.
The structure of the database is as follows:

***

### Database Tables 

**tblPlaces**                                                                       
| Field | Description |
| --- | --- |
| Place_ID | Primary Key |
| Place_Name | Name of the place |
| Climate_ID | Foreign Key - links to ```tblClimates``` |
| Province | Province of place |
| Maritime | Is the place maritime or not? |
| Population | Total population of the place |
| Image_Location | Location of the image of the place |
| Established | Date of place establishment |
| Description | Description of the place |

**tblClimates**
| Field | Description |
| --- | --- |
| Climate_ID | Primary Key - Koppen Code |
| Koppen_Name | Koppen Climate Name |
| Short_Description | Short description of the climate |
| Rainfall_Season | What season rainfall occurs in this climate |
| Heat_Level | How hot the climate gets |
| Rainfall_Type | Type of rainfall |
| Climate_Group | Koppen Climate group |
| Long_Description | Longer description of the climate |

**tblNews**
| Field | Description |
| --- | --- |
| Article_ID | Primary Key |
| Place_ID | Foreign Key - Links to ```tblPlaces``` |
| Article_Headline | Headline for the article |
| Source | URL of the article |
| Date_Published | When the article was published |
| Author | Author of the article |
| Source_Name | Source of the article |
| Marjor_Event | Is the event major or minor? |
| Article_Body | Full article body |

**tblTemperature**
| Field | Description |
| --- | --- |
| Temp_ID | Primary Key |
| Place_ID | Foreign Key - Links to ```tblPlaces``` |
| Record_High | Headline for the article |
| Record_High_Year | URL of the article |
| Record_Low | When the article was published |
| Record_Low_Year | Author of the article |
| * 2010 - 2022 | Temperature averages (C) for 2010 - 2022 |

* 2010 - 2022 are each individual fields.
 
**tblRainfall**
| Field | Description |
| --- | --- |
| Rainfall_ID | Primary Key |
| Place_ID | Foreign Key - Links to ```tblPlaces``` |
| Record_High | Record Amount of Rainfall (Max) |
| Record_High_Year | Year of Max record |
| Record_Low | Record Amount of Rainfall (Min) |
| Record_Low_Year | Year of Min record |
| * 2010 - 2022 | Rainfall averages (mm) for 2010 - 2022 |

* 2010 - 2022 are each individual fields. 

***
