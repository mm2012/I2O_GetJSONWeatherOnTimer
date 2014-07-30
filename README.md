Readme

This Custom class downloads and parses current weather data from Open Weather Map web service.  Data is received in JSON format.
If specified updates the UI and/or runs repeats on a Timer.

A fully functional Xcode Project is provided which illustrates the usage of this custom class.  Project deployed for iOS 6.0 upwards.


- Accompanying Project example uses Glasgow`s weather as an example.
- The weather object can check the weather at intervals specified during creation.
- UI can be updated, if specified
- Asynchronous call made to Open Weather Map API for the JSON data (NSOperation)
- Internet connectivity is not checked. Use Apple`s Reachability Class for that.
- XIB is not provided for UI updates. Console logs the formatted Weather data.

(c) 2013 Mikki Mann