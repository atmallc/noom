
Mobile Take-Home Assignment 
Please look to complete this take-home assignment before your interview that will be conducted over Zoom. You will need to share your project with your interviewer ~one day in advance. There are instructions on how to do that in your interview confirmation email. 

Mobile Tech Interview Prompt 
For this exercise, you’ll be working on a small application (live) during the interview.  To speed things along, please prepare a basic app with the functionality described below, using your preferred libraries and patterns, and have it ready before the interview begins (you can create a private Github project and invite your Noom interviewer to it). 
Tips and tricks:  
When the user taps on one of the names of the foods, display a simple message with the food name. 
We don’t care about the prototype looking good — don’t spend time aligning pixels. We want to see how you organize your code, how you consider corner cases, and what your favorite libraries are.
During the interview you will add functionality to this food browser. 

The application to prepare is a simple food browser. Create a simple screen with the search bar on top. When the user types in some text, you will query the REST API described below. The REST API will return an array of food items. 

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