//
//  WeatherTableViewCell.swift
//  Weather-App
//
//  Created by norelhoda on 14.01.2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherMax: UILabel!
    @IBOutlet weak var weatherMin: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(with weather: List){
        
        let t = String((weather.main?.temp_max)! )
        let tt =  t[t.index(t.startIndex, offsetBy:0 )..<t.index(t.startIndex, offsetBy:2 )]
        weatherMax.text = String(tt) + "°"
        
        let z = String((weather.main?.temp_min)! )
        let zz =  t[t.index(z.startIndex, offsetBy:0 )..<z.index(z.startIndex, offsetBy:2 )]
        weatherMin.text = String(zz) + "°"
        
        weatherDescription.text = String((weather.weather?[0].description)!)
        
        let icon = String((weather.weather?[0].icon)!)
        let url = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        weatherImage?.downloaded(from: url )
    }

   
    
}
