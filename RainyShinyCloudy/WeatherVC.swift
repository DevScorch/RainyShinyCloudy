    //
    //  WeatherVC.Swift
    //  RainyShinyCloudy
    //
    //  Created by Johan Sas on 09-01-17.
    //  Copyright © 2017 Johantsas. All rights reserved.
    //

    import UIKit
    import Alamofire
    import CoreLocation

    class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

        
        @IBOutlet weak var dateLabel: UILabel!
        @IBOutlet weak var tempLabel: UILabel!
        @IBOutlet weak var placeLabel: UILabel!
        @IBOutlet weak var weatherImage: UIImageView!
        @IBOutlet weak var weatherLabel: UILabel!
        @IBOutlet weak var tableView: UITableView!
        
        
        //Variables
        
        var currentWeather = CurrentWeather()
        var forecast: Forecast!
        var forecasts = [Forecast]()
        let locationManager = CLLocationManager()
        var currentLocation: CLLocation!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startMonitoringSignificantLocationChanges()
            
            
            tableView.delegate = self
            tableView.dataSource = self
            
            currentWeather = CurrentWeather()
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    //Setup UI to load downloaded Data
                    self.updateMainUI()
                }
              
                
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            locationAuthStatus()
        }
        
        func locationAuthStatus() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                currentLocation = locationManager.location
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
                print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
               
            } else {
                locationManager.requestWhenInUseAuthorization()
                locationAuthStatus()
            }
        }
        
        
        func downloadForecastData(completed: @escaping DownloadComplete) {
            let forecastURL = URL(string: FORECAST_URL)
            Alamofire.request(forecastURL!).responseJSON { response in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                 
                    if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                        for obj in list {
                            let forecast = Forecast(weatherDict: obj)
                            self.forecasts.append(forecast)
                            print(obj)
                            }
                        self.forecasts.remove(at: 0)
                        self.tableView.reloadData()
                        }
                    }
                    completed()
            }
                    
            }
            

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return forecasts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
                
                let forecast = forecasts[indexPath.row]
                cell.configureCell(forecast: forecast)
                return cell

            } else {
                return WeatherCell()
            }
            
            
        }
        
        func updateMainUI() {
            dateLabel.text = currentWeather.date
            tempLabel.text = "\(currentWeather.currentTemp)"
            weatherLabel.text = currentWeather.weatherType
            placeLabel.text = currentWeather.cityName
            weatherImage.image = UIImage(named: currentWeather.weatherType)
        }
        

    }

