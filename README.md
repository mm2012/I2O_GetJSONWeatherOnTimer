Readme

This Custom class downloads and formats Open Weather Map web service data for current Weather.  Data is received in JSON format.

A fully functional Xcode Project is provided which illustrates the usage of this custom class.  Project deployed for iOS 6.0 upwards.


- Accompanying Project example uses Glasgow`s weather as an example.
- The weather object can check the weather at intervals specified during creation.
- UI can be updated, if specified
- Asynchronous call made to Open Weather Map API for the JSON data (NSOperation)
- Internet connectivity is not checked. Use Apple`s Reachability Class for that.
- XIB is not provided for UI updates. Console logs the formatted Weather data.

(c) 2013 Mikki Mann