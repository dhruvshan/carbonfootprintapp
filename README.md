# Welcome to Endangered Humans

This is my NTU EEE 2022 FYP - Personal Carbon Footprint Application

## Application Stack

This project is built using Flutter and Dart on the Frontend with Firebase for the backend.

I also use several API's in this project:

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
