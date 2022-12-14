# Welcome to Endangered Humans

This is my NTU EEE 2022 FYP - Personal Carbon Footprint Application. The main objective of this project was to develop an effective carbon footprint calculator app that also provides users with footprint tracking and intelligent recommendations.

## Application Stack

This project is built using Flutter and Dart on the Frontend with Firebase for the backend.

I also use two external public API's in this project:

- [Climatiq API: Calculates footprint values](https://www.climatiq.io/)
- [NewsAPI: Useful News system](https://newsapi.org/)

# Calculator

The main function of the application is the carbon footprint calculation, represented in kgCo2e. Here we focus on 4 main factors:

- Food expenditure (type of food consumed) in $
- Transport distance (type of transportation) in km
- Recycling earnings (type of item recycled) in $
- Energy consumption (electrical energy consumed per month) in kWh

## Food Expenditure

The Co2e for food can be calculated in both an Advanced and Simple Mode. 

### Advanced Mode
The carbon footprint from food consumed is calculated based on the users expenditure on specific types of food:
- Seafood
- Poultry
- Beef/Red Meat
- Vegetables
- Pork

Users are able to drag price sliders for each food type. The sum total of all the different Co2s is saved as foodCo2.

<img width="481" alt="Screenshot 2022-12-30 181944" src="https://user-images.githubusercontent.com/66048526/210059779-7105c131-f956-4d81-8e7c-0e937efcf689.png">

### Simple Mode
The carbon footprint from consumed is summed up based on the individual footprints of the selected food preset options. There are currently 6 food preset options available.

<img width="421" alt="Screenshot 2022-12-04 090516" src="https://user-images.githubusercontent.com/66048526/210060054-5e4d112a-7655-411d-90a2-d28746b4b614.png">

## Transport Distance

Here we focus on the 4 main types of transport methods:
- Walking
- Cycling
- Public Transport using Trains
- Cars/Vehicles

While this is not a very comprehensive sample, it does cover the majority of transportation types used by people on a global basis.

As such for calculation their transportCo2, users will select their mode of transport as well as the distance travelled.

## Recycling Earnings

Since recycling is known to reduce a users carbon footprint and many items in an around a typical household are recylcable to a certain extent, it made sense to calculate a users "absorption of Co2" based on the quantities and types of items they recycled. 

In the application, there are 3 item types:
- Aluminium (Cans)
- Paper
- Clothing

We have chosen the above three types of items as they are commonly recycled in recycling centres. Additionally, since this application is focused on users from the city of Singapore, the country provides users a financial incentive if they recycle the aforementioned items.

For  calculating a recyleCo2, users need to input the amount of money they earned via recycling (because of the aforementioned financial icentive). However, it also possible that users recycle these items separately and may not recieve any financial compensation. In that case users can calculate their recycleCo2, by estimating the theoretically amount they would have earned using the handy kg to $ table present in the application.

## Energy Consumption

The last factor used to calculate a users carbon footprint is their electrical energy consumption (kwH) on a daily/monthly basis. Users can calculate their energyCo2 by entering the energy usage for the last month of use. The system will then estimate an average daily amount to carry out the calculation. 

This is an area that can definitely be improved upon on the future as its difficult for people to expect to know their energy consumption and energy consumption can vary masssively from one day to the next.

## Other Aspects of the Calculator

### User History

The calculatory currently tracks the user input values for transportation (mode and distance) and recycling (type of item and expenditure). This user history is shown on the Progress tracking page of the application.

# Recommendation system

Since the footprint is calculated based on food, transportation, energy usage and recycled quantities, the recommendation system addresses these 4 factors.
The system is split into 3 components:
- Input-based recommendations
- Random recommendations
- Constant recommendations

## Input-based recommendations

In this system, the application algorithm checks user values against preset "lowest Co2e" points. 

For example, an input based recommendation for food Co2 will compare the users expenditure on any X type vs the equivalent expenditure on vegetables (as they have the lowest carbon footprint).
If the co2 of users is found to be greater, they would then be recommnended to "eat/spend more on vegetables instead of X". Since we are comparing, the recommendation system will also showcase by how much the users kgCo2e would have been reduced by if they had spent that amount on vegetables instead.

Since users could also input multiple types of food as seen in the Advanced mode, it is imperative that the system calculates the max food Co2 value (from all the types) and then compares accordingly.

## Random Recommendations

These recommendations are lines of text picked at random from a 'recommendations' collection present in Firebase. This collection is a list of curated requests, activities or initiatives that reduce a users carbon footprint.

Some examples include:
- "Fast fashion is a bad way to dress yourself. They are one of the most environmentally unfriendly companies in the world"
- "Change all your lightbulbs to LED as the consume less than half the energy of a standard bulb"

## Constant Recommendations

These are recommendation(s) that are constantly shown to users, regardless of their footprint or goal. For this, they obviously need to have something of value. As such the decision was taken to have one constant recommendation that showcases the location of all the Cash for Stations in Singapore (using the Google Maps API)

# Other Features

## Pets

Every user, once logged in has the opportunity to pick from between 3 endangered animals (Polar Bear, Penguin, Sealion/Seal) as their pet. The status of their pet is then directly correlated to their score. 
For example, if a user scores higher (i.e. worse) than their reduced carbon footprint goal, the pet or rather the pets polar habitat will start sinking and vice versa. 

After certain number of days/tries/attempts/calculations, if the user score continues to worsen, their pet will eventually get killed off. To interact with the application any further, users will then have to get a new pet. This action will increase a users "kill count", which is publicly known to everyone via the application's Rankings page.

## Rankings

To provide an implicit recommendation for users to continue to improve, I created a Rankings page. This ranks the users both based on their Footprint (lower the better) and their kill count (also lower the better). This page is available for all users.

## Tracking 

To showcase user score over time, I built a graph like tracking page. This showcases the user cabon footprint score versus their daily goal. Additionally, every days score breakdown is shown below the graph page. This allows users to see their score history on a day to day basis so that in the future they can look back and understand why their score was high or low on a given day.

## News

To improve the interactivity with the application, the News page, powered by the News API, showcases a list of news articles (related to Global Warming) from top websites in a list format on the application. The key values used from the API response include:
- image url
- title
- description

All article tabs are also interactive, allowing the user to click on a specific article to read it further.



