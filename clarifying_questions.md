# NoomFoodTracker - Clarifying Questions

Please provide answers to the following questions to help guide the implementation:

## 1. Search Bar Animation & UX
The assignment mentions that when the user "taps on this screen" the search bar should move to the top. Should this animation trigger when:
- Only when the user taps specifically on the search bar itself

**Animation preferences:**
- Transition duration: __0.25 seconds_____________
- Animation style: __ease-in-out_____________

## 2. Food Item Selection Behavior
When a user taps on a food item, should we display:
- A detailed overlay view showing additional information (brand, calories, portion size) that pops up from below.

## 3. Real-time Search Implementation
For the search functionality:

**When user has typed 1-2 characters (below 3-character minimum):**
- Show instructional text ("Type at least 3 characters")

**API call optimization:**
- Debounce API calls (delay: __200___ milliseconds)
- Cache API responses for 5 minutes

**Error handling:**
- Show error message to user, with a retry button.

## 4. Architecture & Code Organization (housekeeping)
**Existing SwiftData code:**  
- Remove all SwiftData-related code (since we're only searching, not storing)

**Navigation structure:**
- Completely replace with new welcome screen design

**Caching:**
- Implement caching for search results

## 5. Welcome Screen Design
**Design preferences:**
- Follow standard iOS design patterns

**Additional welcome screen elements:**
- show an the SF symbol "fork.knife.circle" as the App logo.
