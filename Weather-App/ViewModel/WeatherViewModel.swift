//
//  WeatherViewModel.swift
//  Weather-App
//
//  Created by norelhoda on 19.01.2022.
//

import Foundation

class WeatherViewModel {
    
    var collectionCellViewModel = [CollectionCellViewModel] ()
    var tableCellViewModel = [TableCellViewModel]()
    
    
    var selectedCity:String = "paris" {
        didSet{
            fetchHoulryWeather()
            fetchDailyWeather()
        }
    }
    
    var searchIsActive:Bool = false {
        didSet{
          showSearchResult?()
        }
    }
   
    
    var weatherByHour = [List]()
    var weatherByDay = [List]()
    var cityData = data
    var datesArray = dates
    
    var reloadCollectionView : (()->())?
    var reloadTableView : (()->())?
    var showSearchResult : (()->())?
    
    
    func fetchHoulryWeather(){
        WeatherByHour.shared.getWeatherDataFromApi(url: EndPiont.weatherUrl, parameters: ["q": String(selectedCity),"appid":EndPiont.apid]) { [weak self]  (response) in
            
            guard let self = self else { return }
            if (response.list != nil) {
               
                self.processFetchedHourlyWeather(data: response.list!)
                self.reloadCollectionView?()
            }
        }
    }
    
    func fetchDailyWeather(){
        WeatherByDay.shared.getWeatherDataFromApi(url: EndPiont.weatherUrl2, parameters: ["q": String(selectedCity),"appid":EndPiont.apid,"cnt":String(7)]) { [self]  (response) in
          
            if (response.list != nil) {
                self.processFetchedDailyWeather(list: response.list!)
                self.reloadTableView?()
            }
        }
    }
    
    func processFetchedHourlyWeather(data:[List]) {
        
        weatherByHour = data
        
        var vms = [CollectionCellViewModel]()
        for weather in weatherByHour {
            vms.append (createCollectioncellViewModel(list: weather))
        }
        collectionCellViewModel = vms
    }
    
    func createCollectioncellViewModel(list: List ) -> CollectionCellViewModel {
        var time : String
        let t = String((list.main?.temp)! )
        let tt =  t[t.index(t.startIndex, offsetBy:0 )..<t.index(t.startIndex, offsetBy:2 )]
        let temp = String(tt) + "°"
        let humdatiy = String((list.main?.humidity)!) + "%"
        let x = String((list.dt_txt)!)
        let z =  x[x.index(x.startIndex, offsetBy:11 )..<x.index(x.startIndex, offsetBy:13 )]
        var zz = Int(z)!
        if zz > 12{
            zz =  zz - 12
            time =  String(zz) + "" + "pm"
        }
        else {
            time =  String(z) + "" + "am"
        }
       
        let icon = String((list.weather?[0].icon)!)
        let url = "https://openweathermap.org/img/wn/\(icon)@2x.png"
       
            
        return CollectionCellViewModel(temp: temp, humadity: humdatiy, imageUrl: url, time: time)
    }
    
    func processFetchedDailyWeather(list:[List]) {
        weatherByDay = list
        
        var vms = [TableCellViewModel]()
        
        for weather  in weatherByDay {
            vms.append(createTableCellViewModel(list: weather))
        }
        tableCellViewModel = vms
    }
    
    func createTableCellViewModel(list:List)-> TableCellViewModel{
        let t = String((list.main?.temp_max)! )
        let tt =  t[t.index(t.startIndex, offsetBy:0 )..<t.index(t.startIndex, offsetBy:2 )]
        let tempMax = String(tt) + "°"
        
        let z = String((list.main?.temp_min)! )
        let zz =  t[t.index(z.startIndex, offsetBy:0 )..<z.index(z.startIndex, offsetBy:2 )]
        let tempMin = String(zz) + "°"
        
        let description = String((list.weather?[0].description)!)
        
        let icon = String((list.weather?[0].icon)!)
        let url = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        
        
        return TableCellViewModel( description: description, maxTemprature: tempMax, minTemprature: tempMin, imgUrl: url)
    }
}
