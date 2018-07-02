//
//  ViewController.swift
//  Clima
//
//  Created by Jo Thorpe on 25/06/2018.
//  Copyright © 2018 Oxfam Reject. All rights reserved.
//


import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityNAme(city: String)
}


class ChangeCityViewController: UIViewController {
    

    var delegate: ChangeCityDelegate?
   
    @IBOutlet weak var changeCityTextField: UITextField!

    @IBAction func getWeatherPressed(_ sender: AnyObject) {

        let cityName = changeCityTextField.text!
        delegate?.userEnteredANewCityNAme(city: cityName)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
