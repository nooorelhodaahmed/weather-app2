//
//  WeatherCollectionViewCell.swift
//  Weather-App
//
//  Created by norelhoda on 14.01.2022.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tempratureDegree: UILabel!
    @IBOutlet weak var humdatiyDegree: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
   func setUp(with weather: List) {
    let t = String((weather.main?.temp)! )
    let tt =  t[t.index(t.startIndex, offsetBy:0 )..<t.index(t.startIndex, offsetBy:2 )]
    tempratureDegree.text = String(tt) + "°"
    humdatiyDegree.text = String((weather.main?.humidity)!) + "%"
    let x = String((weather.dt_txt)!)
    let z =  x[x.index(x.startIndex, offsetBy:11 )..<x.index(x.startIndex, offsetBy:13 )]
    var zz = Int(z)!
    if zz > 12{
        zz =  zz - 12
        timeLabel.text =  String(zz) + "" + "pm"
    }
    else {
        timeLabel.text =  String(z) + "" + "am"
    }
   
    let icon = String((weather.weather?[0].icon)!)
    let url = "https://openweathermap.org/img/wn/\(icon)@2x.png"
    weatherImage?.downloaded(from: url )
        
    }
}
