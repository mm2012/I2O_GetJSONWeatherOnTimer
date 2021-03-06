Readme

This Custom class provides current weather information for a given city identified by a City ID or City name.
This class uses Open Weather Map web service.  Data is received in JSON format.
This Class can update the UI and/or can run repeatedly on a Timer checking the Weather in the specified time interval.

A fully functional Xcode Project is provided which illustrates the usage of this custom class.  Project is targeted for iOS 6.0 upwards.


- Accompanying Project example uses Glasgow`s weather as an example.
- The Class can check the weather at intervals specified during creation. Timer interval is specified in Seconds.
- Class UI will updated, if the Designated Initializer is used. If init is used to create the object, UI is not updated.
- Asynchronous call made to Open Weather Map API for the JSON data (NSOperation)
- Internet connectivity is not checked. Use Apple`s Reachability Class for that.
- XIB is not provided for UI updates. Console logs the formatted Weather data.

(c) 2013 Mikki Mann