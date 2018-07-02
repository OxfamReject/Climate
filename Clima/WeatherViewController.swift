//
//  ViewController.swift
//  Clima
//
//  Created by Jo Thorpe on 25/06/2018.
//  Copyright © 2018 Oxfam Reject. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
  
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b1ca0c6587c13a3932807714ba5ac5f2"
    

    
    let myLocationManager = CLLocationManager()
    let weaatherDataModel = WeatherDataModel()
    

    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //location manager setup
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        myLocationManager.requestWhenInUseAuthorization()
        myLocationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getWeatherData(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print(response.result.error as Any)
                self.cityLabel.text = "Connection Isssues"
            }
        }
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    func updateWeatherData(json: JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            
            weaatherDataModel.temperature = Int(tempResult - 273.15)
            
            weaatherDataModel.city = json["name"].stringValue
            
            weaatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weaatherDataModel.weatherIconName = weaatherDataModel.updateWeatherIcon(condition: weaatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        } else {
            cityLabel.text = "Weather unavailable"
        }
    }
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData() {
        cityLabel.text = weaatherDataModel.city
        temperatureLabel.text = "\(weaatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weaatherDataModel.weatherIconName)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        //check value is valid
        if location.horizontalAccuracy > 0 {
            //stop updating when you have correct locations so dont waste battery
            myLocationManager.stopUpdatingLocation()
            
            print(location.coordinate.longitude)
            print(location.coordinate.latitude)
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String : String] = ["lat": latitude, "lon": longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    func userEnteredANewCityNAme(city: String) {
        print(city)
        let params: [String:String] = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
    
}


