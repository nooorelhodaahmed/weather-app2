//
//  WeatherByDay.swift
//  Weather-App
//
//  Created by norelhoda on 15.01.2022.
//

import Foundation

struct WeatherByDay{
    
   
    static let shared = WeatherByDay()

    func  getWeatherDataFromApi( url: String, parameters: [String: String],completion : @escaping (WeatherHourly) -> Void) {
        var components = URLComponents(string: url)!
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            let request = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
           
         guard let data = data else {return}
         

         do {
            
            let postsResponse = try JSONDecoder().decode(WeatherHourly.self, from: data)
           
          
             completion(postsResponse)
         } catch {
             print("Error decoding Json comments - \(error)")
            
         }
         
        }).resume()
     
        
        }
        
    
    }
    
