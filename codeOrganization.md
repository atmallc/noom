We will create different information layers within the app to separate the concerns of the app. 

Layer 1,2,3: We will follow a classic MVVM architecture. So the first three layers will be the View, the View Model, and the Model. 

Layer 4: Then we will have the Networking layer, which will be responsible for making the API calls to one of more REST APIs. It will provide simple methods to the View Model layer to get the data from the API in clean swift models.

Layer 5: This will be a utility layer, which will be responsible for providing utility methods to the View Model layer. It will provide methods for caching, debouncing, and Logging.