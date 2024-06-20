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
        
        HStack {
            if let weatherData = weatherManager.weatherData {
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 4).foregroundColor(Color("accent"))
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .overlay {
                        Text("\(Int(weatherData.temperature))°C")
                            .font(.callout)
                    }

            } else {
                // Отображение progress view во время получения данных о погоде
                ProgressView()
            }
        }
        .frame(width: 50, height: 50)
        .cornerRadius(10)
        .onAppear {
            // запрос локации при появлении вью
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { location in
            // получаем данные о погоде, когда локация обновлена
            guard let location = location else { return }
            WeatherManager.shared.fetchWeather(for: location)
        }
    }
}

#Preview {
    WeatherView()
}
