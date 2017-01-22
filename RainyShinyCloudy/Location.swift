//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by Johan Sas on 22-01-17.
//  Copyright © 2017 Johantsas. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init(){}
    
    var latitude: Double!
    var longitude: Double!
    
}
