//
//  I2OJSONWeather.m
//  getJSONdatafromURL
//
//  Copyright (c) 2013 Mikki Man,, Idea2Objects. All rights reserved.
//
/*
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */


#import "I2OJSONWeather.h"


@interface I2OJSONWeather()     // private

-(void)fetchJSONWeatherAndUpdateUI;

@end


@implementation I2OJSONWeather

@synthesize currentCondition, currTemp, maxTemp, minTemp, humidity, lastUpdateTime;




-(id)init     // call designated initializer
{
    return [self initWithWeatherCondition:nil
                                 currTemp:nil
                                  maxTemp:nil
                                  minTemp:nil
                                 humidity:nil
                           lastUpdateTime:nil];
}


-(id)initWithWeatherCondition:(UILabel*)currCondition  // designated intializer
                     currTemp:(UILabel*)curr
                      maxTemp:(UILabel*)max
                      minTemp:(UILabel*)min
                     humidity:(UILabel*)humid
               lastUpdateTime:(UILabel*)lastUpd
{
    self = [super init];
    
    if (self) {
        /*
         [self setCurrentCondition:currCondition];
         [self setCurrTemp:curr];
         [self setMaxTemp:max];
         [self setMinTemp:min];
         [self setHumidity:humid];
         [self setLastUpdateTime:lastUpd]; */
        
        currentCondition = currCondition;
        currTemp = curr;
        maxTemp = max;
        minTemp = min;
        humidity = humid;
        lastUpdateTime = lastUpd;
        // NSLog(@"currCondition %@, curr %@, max %@, min %@, humid %@, lastupd %@", currCondition, curr, max, min, humid, lastUpd);
    }
    
    return self;
    
} // initWithWeatherCondition



-(void)fetchWeatherAndUpdateUI
{
    [self fetchJSONWeatherAndUpdateUI];
}


-(void)fetchWeatherAndUpdateUI:(float)updateSeconds
{
    [self fetchJSONWeatherAndUpdateUI];
    [NSTimer scheduledTimerWithTimeInterval:updateSeconds
                                     target:self
                                   selector:@selector(fetchJSONWeatherAndUpdateUI)
                                   userInfo:nil
                                    repeats:YES];
    
}


-(void)fetchJSONWeatherAndUpdateUI
{
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:OPENWEATHER_URL_GLASGOW]];
    
    [NSURLConnection sendAsynchronousRequest:jsonRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         if (connectionError) {
             if ([self currentCondition] != nil && [self currTemp] != nil && [self maxTemp] != nil && [self minTemp] != nil && [self humidity] != nil && [self lastUpdateTime] !=nil)
             {
                 [self.currentCondition setText:@"Did not retrieve Weather data"];
                 [self.currTemp setText:@"0"];
                 [self.maxTemp setText:@"0"];
                 [self.minTemp setText:@"0"];
                 [self.humidity setText:@"0"];
                 [self.lastUpdateTime setText:[self currentTime]]; }// (currentCondition != nil && curr != nil &&
             else {
                 QuietLog(@"error processing URL: %@", [connectionError localizedDescription]);
             }
             
         } // (connectionError)
         
         
         if (!connectionError) {
             
             //NSLog(@"\ngot here-----connection error-------------------");
             NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             
             if (self.currentCondition != nil && self.currTemp != nil && self.maxTemp!= nil && self.minTemp != nil && self.humidity != nil && self.lastUpdateTime!=nil) {
                 //    NSLog(@"\ngot here-----connection error  IF condition -------------------");
                 [self.currentCondition setText:[[JSONKEY_WEATHER objectAtIndex:0] valueForKey:@"description"]];
                 
                 [currTemp setText:[NSString stringWithFormat:@"%0.0f", [[JSONKEY_MAIN valueForKey:@"temp"] doubleValue] - 273.15]];
                 [maxTemp setText:[NSString stringWithFormat:@"%0.0f", [[JSONKEY_MAIN valueForKey:@"temp_max"] doubleValue] - 273.15]];
                 [minTemp setText:[NSString stringWithFormat:@"%0.0f", [[JSONKEY_MAIN valueForKey:@"temp_min"] doubleValue] - 273.15]];
                 [humidity setText:[NSString stringWithFormat:@"%@", [JSONKEY_MAIN valueForKey:@"humidity"]]];
                 [lastUpdateTime setText:[self currentTime]];
             } //if (currentCondition != nil && curr != nil &&
             else
             {
                 // QuietLog(@"\njson data\n%@", jsonObject);
                 // Temperature, Kelvin (subtract 273.15 to convert to Celsius)
                 QuietLog(@"\n (Glasgow Weather) Dump for `main` object (%@)\n Humidity: %@, Current Temp: %0.0f (Max: %0.0f, Min: %0.0f), Condition: %@",
                          [self currentTime],
                          [JSONKEY_MAIN valueForKey:@"humidity"],
                          [[JSONKEY_MAIN valueForKey:@"temp"] doubleValue] - 273.15,
                          [[JSONKEY_MAIN valueForKey:@"temp_max"] doubleValue] - 273.15,
                          [[JSONKEY_MAIN valueForKey:@"temp_min"] doubleValue] - 273.15,
                          [[JSONKEY_WEATHER objectAtIndex:0] valueForKey:@"description"]);
             } //else
         } // if (!connectionError)
         
     } ]; // NSURLConnection
    
} // fetchWeatherAndUpdateUI



/*debug code
 // NSStringFromClass([yourObject class])
 QuietLog(@"\nWeather condition object class: %@", NSStringFromClass([[jsonObject objectForKey:@"weather"] class]));
 QuietLog(@"\nWeather condition: %@", [[jsonObject objectForKey:@"weather"] valueForKey:@"description"]);
 NSArray *weather = [NSArray arrayWithArray:[jsonObject objectForKey:@"weather"]];
 QuietLog(@"Class of first element: %@, value: %@",
 NSStringFromClass([[weather objectAtIndex:0] class]), [[JSONKEY_WEATHER objectAtIndex:0] valueForKey:@"description"]); */


-(NSString*)currentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}


void QuietLog (NSString *format, ...) {
    if (format == nil) {
        printf("nil\n");
        return;
    }
    // Get a reference to the arguments that follow the format parameter
    va_list argList;
    va_start(argList, format);
    // Perform format string argument substitution, reinstate %% escapes, then print
    NSString *s = [[NSString alloc] initWithFormat:format arguments:argList];
    printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
    //[s release];
    va_end(argList);
}
@end
