---
title: iOS101 Final Project App Ideas

---

# iOS101 Final Project App Ideas

## Activity 1- 

## Step 1:

### Pantry Inventory App
Catalog the contents of your pantry (think things like rice, flour, spices, frozen berries, etc...) and then upload recipes to verify that you have all the little things that you could swear you have (but might not). If you mark a recipe as cooked then it will deduct relevant items from the pantry for future reference.
Possible API:
[Spoonacular](https://spoonacular.com/food-api) 

Possible Persistent Data:
-Out of stock products
-Favorite recipes

### Morning App
Combination of journaling, guided meditations, and maybe some more. Once you've completed things the things that fill you, then you it brings up an aggregation of calendar events and to-dos.
Possible API:
[Affirmations.dev](https://www.affirmations.dev/)
Possible Persistent Data:
-To-do list

### All Purpose Homeowner's App
All purpose app to remind you about hard to remember maintenance chores like changing your air filter, flushing the hot water heater, cleaning the AC condenser fan, flea and tick medications etc... Optional links to Amazon, Walmart, Chewy, etc to give you reminders to purchase or automate purchasing.
Possible API:
[Amazon Selling Partner API](https://developer.amazonservices.com/?ref=spapi_gs_c1_hp_kw_amazonproductsapi)
Possible Persistent Data:
-Start dates and service intervals for maintenance

### TrackMy
Shipping app that tracks packages from across platforms including USPS, FedEx, UPS, DHL, Amazon to aggregate all incoming and outgoing package information into one place.
Possible APIs:
[USPS API](https://developers.usps.com/?_gl=1*ezcv1y*_ga*NjE2MzUwMjQzLjE3NDEzMDY2NzM.*_ga_QM3XHZ2B95*MTc0MjQ2ODgxMy42LjAuMTc0MjQ2ODgxMy4wLjAuMA..)
[UPS Quantum View API](https://developer.ups.com/legacyupsdeveloperkit?loc=en_US)
[FedEx Tracking API](https://developer.fedex.com/api/en-us/catalog/track.html)
Possible Persistent Data:
-Login info?


## Requirements:
- API Integration
    - Connect to a public API
    - Fetch data and parse it into useable Swift structs or classes
    - Display fetched data in UI
- Navigation and Data Passing
    - Use a UINavigationController or another navigation mechanism to move between at least two distinct view controllers
- Data Persistence
    - Save at least one piece of data locally
- Swift Basics
    - Use at least one each class, struct, and enum
- UIKit
    - Build the UI with storyboards
    - Use autolayout and appropriate constraints to verify views are positioned appropriately
    - Include common UIKit components like UILabel, UIButton, UITableViewws, UITextField

## Color Schemes
![Screenshot 2025-03-21 at 12.33.45 AM](https://hackmd.io/_uploads/Skw4nD93Jl.png)
03071e
370617
6a040f
9d0208
d00000
dc2f02
e85d04
f48c06
faa307
ffba08


## Step 2:

### 2.1: Top Two
Pantry App
Morning App

### 2.2: APP EVALUATION CRITERIA

For Pantry:

Mobile: How uniquely mobile is the product experience?
I think that this app is extremely compatible with mobile and that the platform provides significant advantages over trying to do the same thing with desktop. I'm planning to integrate the Vision framework barcode scanner to allow users to 'stock' their pantry which is very specific to mobile. Additionally, it would be a real pain to carry a laptop around the kitchen to try to do all of this work. I think the concept is inherently mobile-centric.

Story: How compelling is the story around this app once completed?
I'm not completely impartial because I cook a lot and this is addressing an issue that I constantly run into. With that being said, I think it's far from a unique issue. How often do people end up having to make another trip to the grocery store because they could swear something was in the cabinet, but it wasn't. I think that utility apps are compelling when they cleanly fix a user frustration and make life easier and this has the ability to hit those marks well.

Market: How large or unique is the market for this app?
There is an extremely large market of people who cook at home. A significant number of people who cook at home do so to save money and this app has the potential to help avoid over or repurchasing staple items that will just wither away in the pantry.


Habit: 
The barrier to using this app efficiently is that it needs to be used regularly to track additions/depletions in order to stay functional. This means that the UI needs to be compelling and it needs to be largely bug-free so that people don't get frustrated.


Scope: How well-formed is the scope for this app?
The app isn't going to be easy to build but I think that if I break it into sub-components it should stay manageable. The big parts are:
- Creating the data model for the pantry and recipes
- Getting my API integration for recipes right and parsing the data in a manageable way.
- Figuring out how to store pantry data efficiently without building a db for the MVP.
- Integrating the barcode scanner and making manual entry pretty seamless.

None of these are incredibly challenging on their own but it's going to take time and there are some things I need to give myself padding on to make sure that I don't get in a bind at the last minute trying to brute force them into working (barcode scanner). It's pretty clearly defined but I need to hit ~80% of my intended functionality to make it interesting enough to be viable.


For Morning:

Mobile: How uniquely mobile is the product experience?
This product makes sense on mobile because (for better or worse) most folks have their phone in hand during their morning routine.

Story: How compelling is the story around this app once completed?
Given that people have their phone in hand during their morning routine, this app can help transform habits that are detrimental to mental health (doom scrolling) into something that can help make mornings a little bit more gentle and wholesome. That's a pretty good story, but I think the challenges with this one lie more in habit building than initial engagement.

Market: How large or unique is the market for this app?
It's a smaller market than the pantry app but still not insignificant. I think that potential users for this product are much more likely to form a routine and stick with it.


Habit: 
I see two types of users. The first one is somebody that wants to switch up their morning routine but doesn't currently meditate, journal, etc... I think they're likely to download the app but getting them to build a morning practice is outside of the scope of this or any app. Alternatively, I think there's a user base that already does these things in disparate places and would benefit from the convenience of having an all in one solution. They may be more difficult to convince intially but are likely to become regular users if the app is highly functional.


Scope: How well-formed is the scope for this app?
The app is pretty simple to execute from a technical perspective but is much more reliant on UI and aesthetics being well formed. This app needs to make you feel something as much as it needs to perform a task (if not more so). I'm slightly less comfortable on the design/aesthetic side than on the implementation side so that makes ti a little bit challenging.

## Activity 2- 

## Step 1 Setting Up:
- New HackMD doc created with the capstone README populated
- App idea and evaluation criteria added

## Step 2 Design Product Spec:
### a.) Design required and optional features
Required features:
- The ability to log in
- The ability to add an ingredient to the pantry
- An ability to remove an ingredient from the pantry
- The ability to modify the quantity of the ingredient in the pantry
- The ability to search for a recipe to cook
- The ability to view the details of that recipe
- The ability to mark a recipe as cooked and decrease the relevant quantities in the pantry
- The ability to produce a shopping list for all ingredients for recipes currently marked as to cook (persistent list of recipes and ingredients)

Optional features:
- The ability to scan a barcode and have basic product information populate a new or existing entry in the pantry.
- The ability to view a recipe and see what ingredients are currently stocked or need to be purchased.


### b.) Identify the screens in app
- Login screen
- Home screen
- Current pantry screen
- Item add screen (including manual add and barcode scan)
- Item detail screen (including a modify qty or remove button)
- Recipe search screen
- Recipe detail screen (incl. the ability to mark as to cook or cooked)
- Shopping list screen

### c.) Documenting navigation flows

Tab Navigation:
- Pantry
- Recipes
- Shopping List

Flow Navigation:
- Login
    - Home
- Pantry
    - Add/Edit item
    - Item detail screen
- Recipes
    - Recipe search
    - Recipe detail
- Shopping List

## Activity 3- 

## Step 1 Review product spec:

## Step 2- Hand sketch low fi wireframes

<img src="https://github.com/beautate/pantryApp/blob/main/iOS%20Dev-2.jpg" width=600>
<img src="https://github.com/beautate/pantryApp/blob/main/iOS%20Dev-3.jpg" width=600>

## Sprint Plan:
### Sprint 1:
- Specify MVP requirements
- Create pantry app project in xcode
- Build out pantry view controller and support classes

### Sprint 2:
- Build out recipe search and detail view controllers and support classes
- Implement API call to spoonacular for recipe search and detail view
- Refine UI for existing features
- Implement 'to cook' functionality to allow user to select recipes and store in persistent memory

### Sprint 3:
- Build out shopping cart view controller and supporting classes
- Implement logic necessary to compare 'to cook' against current pantry stock
- Implement logic to populate shopping cart with ingredients to be purchased
- Test functionality
- Build out home/log in view controller
- Refine UI
- Populate app icon