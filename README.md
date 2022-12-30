# Welcome to Endangered Humans

This is my NTU EEE 2022 FYP - Personal Carbon Footprint Application

## Application Stack

This project is built using Flutter and Dart on the Frontend with Firebase for the backend.

I also use several API's in this project:

- [Climatiq API: Calculates footprint values](https://www.climatiq.io/)
- [NewsAPI: Useful News system](https://newsapi.org/)

# Calculator

The main function of the application is the carebon footprint calculation. Here we focus on 4 main factors:

- Food expenditure (type of food consumed) in $
- Transport distance (type of transportation) in km
- Recycling earnings (type of item recycled) in $
- Energy consumption (electrical energy consumed per month) in kWh

## Food Expenditure

The carbon footprint from food consumed is calculated based on the users expenditure on specific types of food:
- Seafood
- Poultry
- Beef/Red Meat
- Vegetables
- Pork

Users are able to drag price sliders for each food type. The sum total of all the different Co2s is saved as foodCo2.

