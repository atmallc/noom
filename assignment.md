Prompt:
Create an iOS application called NoomFoodTracker: a simple food browser app. Create an elegant welcome screen, with a search bar in the middle of the screen, when the customer taps on this screen, the search bar should move to the top of the screen.

When the user types in some text, you will query the REST API described below. The REST API will return an array of food items. 

Create an iOS app that allows users to search for food items. When the user taps on one of the names of the foods, display a simple message with the food name. 

Make sure to follow @codeOrganization.md for code organization.



For example, if the user types “chicken” into the search box, the REST API will return a json as described in @searchResponse.json

You should display the names of the foods in a list below the search box.  Each time the user types a character into the search box, the list of foods below it should be updated with the latest foods returned by the REST API.

REST API Details 
The URL for the REST API is:  https://uih0b7slze.execute-api.us-east-1.amazonaws.com/dev/search

Important Parameter for this API: "kv"
A single query parameter called “kv” MUST be provided. If no “kv” query parameter is provided, then a non-JSON error message is returned. The value for the “kv” query parameter must be at least 3 characters long. 

If “kv” is less than 3 characters long, then a non-JSON error message is returned. 

The success response from this REST API is JSON. The response format is an array of dictionaries. For example, if the URL is https://uih0b7slze.execute-api.us-east-1.amazonaws.com/dev/search?kv=chicken, then the response will be: 

More details about the returned fields: 
Calories is the number of calories in 100 grams of the food. 
Portion is the number of grams in 1 portion of the food.