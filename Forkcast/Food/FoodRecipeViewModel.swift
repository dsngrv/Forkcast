//
//  FoodRecipeModel.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 28.05.2024.
//

import FirebaseFirestore
import FirebaseStorage

class FoodRecipeViewModel: ObservableObject {
    
    @Published var recipes: [FoodRecipeModel] = []
    @Published var selectedRecipe: FoodRecipeModel?
    @Published var filteredRecipesByWeather: [FoodRecipeModel] = []
    @Published var isFilteringByWeather: Bool = false


    
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    
    var selectedWeatherTag: String? {
        didSet {
            if isFilteringByWeather {
                guard let selectedWeatherTag = selectedWeatherTag else {
                    return
                }
                filterRecipesByWeather(tag: selectedWeatherTag)
            }
        }
    }
    
    func updateWeatherTag() {
        guard let selectedTag = WeatherManager.shared.getWeatherTag() else {
            return
        }
        selectedWeatherTag = selectedTag
    }
    
    func fetchData() {
        db.collection("food_recipes").addSnapshotListener { snap, error in
            guard let documents = snap?.documents else {
                print("No documents")
                return
            }
            
            self.recipes = documents.map { snap -> FoodRecipeModel in
                let data = snap.data()
                
                let title = data["title"] as? String ?? ""
                let tag = data["tag"] as? String ?? ""
                let weatherTag = data["weatherTag"] as? String ?? ""
                let instruction = data["instruction"] as? String ?? ""
                let ingredience = data["ingredience"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                return FoodRecipeModel(title: title, weatherTag: weatherTag, tag: tag, instruction: instruction, ingredience: ingredience, image: image, desriprion: description)
            }
        }
    }
    
    func filterRecipesByWeather(tag: String) {
        if tag == "Hot" {
            recipes = recipes.filter { $0.weatherTag == "Hot" }
        } else if tag == "Cold" {
            recipes = recipes.filter { $0.weatherTag == "Cold" }
        }
    }
    
    func resetFilterByWeather() {
        isFilteringByWeather = false
        filteredRecipesByWeather = []
        fetchData()
    }
    
    func toggleFilterByWeather() {
        updateWeatherTag()
        if isFilteringByWeather {
            resetFilterByWeather()
        } else {
            filterRecipesByWeather(tag: selectedWeatherTag ?? " ")
        }
        isFilteringByWeather.toggle()
    }
    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = storage.reference(forURL: url)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
}
