# HappeningClient
iOS client for Happening app

# Helpers
Date calculating

```objective-c
// Date calculation stuff
    NSDateComponents *startDateComps = [[NSDateComponents alloc] init];
    [startDateComps setYear:2016];
    [startDateComps setMonth:7];
    [startDateComps setDay:25];
    
    NSDateComponents *endDateComps = [[NSDateComponents alloc] init];
    [endDateComps setYear:2016];
    [endDateComps setMonth:8];
    [endDateComps setDay:5];
    
    NSString *sampleResponse = @"2016-07-25";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [formatter dateFromString:sampleResponse];
    NSLog(@"Date from string: %@", dateFromString);
    
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *startDate = [calendar dateFromComponents:startDateComps];
    NSDate *endDate = [calendar dateFromComponents:endDateComps];

    NSDateComponents *numberOfDays = [calendar components:(NSCalendarUnitDay)
                                                 fromDate:startDate
                                                   toDate:endDate
                                                  options:kNilOptions];
    
    NSLog(@"Number of days: %ld", numberOfDays.day);
    
    int i = 1;
    
    while (i < numberOfDays.day) {
        NSDateComponents *futureDateComps = [[NSDateComponents alloc] init];
        [futureDateComps setDay:i];
        NSDate *futureDate = [calendar dateByAddingComponents:futureDateComps toDate:startDate options:kNilOptions];
        NSLog(@"Day %i: %@", i+1, futureDate);
        i++;
    }
```
