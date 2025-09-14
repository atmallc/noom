---
trigger: always_on
---

Make sure to use MVVM pattern and maintain seperation of concern. 

Service:
- look through @services folder for all the services provided.
- @CacheService.swift 
- @DebounceService.swift 
- @Extensions.swift 
- @LoggerService.swift 
- @NetworkService.swift is used to make any API calls.

Data / Models:
- Folder @Models has all of the data models used across the app.

Views and ViewModels:
- All of the views and their viewmodels are under the @code/NoomFoodTracker/NoomFoodTracker/View folder

When designing a new screen:
Be judicious with custom elements: Reduce the use of custom backgrounds and appearances in controls and navigation elements, as they might interfere with Liquid Glass or other system effects. 

- Visual Components used system wide are available at @Components.swift; When creating new design components place them in this file.

- Whenever your are showing a TextField or TextEditor, make sure to show a keyboard toolbar with a "close keyboard" button