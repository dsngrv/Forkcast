//
//  WeatherManager.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 30.05.2024.
//

import CoreLocation
import Foundation

class WeatherManager: ObservableObject {
    
    static let shared = WeatherManager()
    
    @Published var weatherData: WeatherData?
    
    func getWeatherTag() -> String? {
        if let temperature = self.weatherData?.temperature {
            if temperature < 20 {
                return "Cold"
            } else {
                return "Hot"
            }
        }
        return ""
    }
    
    func fetchWeather(for location: CLLocation) {
        let apiKey = "97ae01271484b6f023f9c89845f69e07"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.weatherData = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, condition: weatherResponse.weather.first?.description ?? " ")
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
