//
//  WeatherView.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 30.05.2024.
//

import CoreLocation
import SwiftUI

struct WeatherView: View {
    
    @StateObject private var locationManager = LocationManager()
    @ObservedObject private var weatherManager = WeatherManager.shared
    
    var body: some View {
        
//        let temperature = Int(weatherManager.weatherData?.temperature ?? 0)
//        let isCold = temperature < 20
        
        HStack {
            // Display weather information if available
            if let weatherData = weatherManager.weatherData {
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 4).foregroundColor(Color("accent"))
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .overlay {
                        Text("\(Int(weatherData.temperature))°C")
                            .font(.callout)
                    }
//                    .padding()
//                
//                VStack {
//                    Text("\(weatherData.locationName)")
//                        .font(.callout).bold()
//                    Text("\(weatherData.condition)")
//                        .font(.body).bold()
//                        .foregroundColor(.gray)
//                }
            } else {
                // Display a progress view while weather data is being fetched
                ProgressView()
            }
        }
        .frame(width: 50, height: 50)
//        .background(isCold ? Color.blue : Color.orange)
        .cornerRadius(10)
        .onAppear {
            // Request location when the view appears
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { location in
            // Fetch weather data when the location is updated
            guard let location = location else { return }
            WeatherManager.shared.fetchWeather(for: location)
        }
    }
}

#Preview {
    WeatherView()
}
