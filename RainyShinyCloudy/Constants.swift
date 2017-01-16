//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by Johan Sas on 13-01-17.
//  Copyright © 2017 Johantsas. All rights reserved.
//

import Foundation

//

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon"
let APP_ID = "&appid="
let API_KEY = "78866288bd5846d087e37c94930863e5"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)-36\(LONGITUDE)123\(APP_ID)\(API_KEY)"

