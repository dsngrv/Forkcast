//
//  DrinkRecipeViewModel.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 17.06.2024.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class DrinkRecipeViewModel: ObservableObject {
    @Published var recipes: [DrinkRecipeModel] = [] {
        didSet {
            // Обновляем фильтрованные рецепты, когда общий список обновляется
            filteredRecipes = recipes
        }
    }
    @Published var selectedRecipe: DrinkRecipeModel?
    @Published var isFilteringByWeather: Bool = false
    @Published var favoriteRecipes: [DrinkRecipeModel] = []
    
    @Published var filteredRecipes: [DrinkRecipeModel] = []

    private var db = Firestore.firestore()
    private let storage = Storage.storage()

    var selectedWeatherTag: String? {
        didSet {
            if isFilteringByWeather {
                guard let selectedWeatherTag = selectedWeatherTag else { return }
                filterRecipesByWeather(tag: selectedWeatherTag)
            }
        }
    }

    init() {
        fetchFavoriteRecipes()
    }
    
    func filterRecipes(with searchText: String) {
            if searchText.isEmpty {
                filteredRecipes = recipes
            } else {
                filteredRecipes = recipes.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }
            }
        }

    func updateWeatherTag() {
        guard let selectedTag = WeatherManager.shared.getWeatherTag() else { return }
        selectedWeatherTag = selectedTag
    }

    func toggleFavorite(for recipe: DrinkRecipeModel) {
        var updatedRecipe = recipe
        if recipe.isFavorite {
            removeRecipeFromUserFavorites(recipe: recipe)
        } else {
            addRecipeToUserFavorites(recipe: recipe)
        }
        updatedRecipe.isFavorite.toggle()  // Изменяем состояние избранного у рецепта
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = updatedRecipe  // Обновляем рецепт в списке
        }
    }

    func fetchData() {
        db.collection("drinks_recipes").addSnapshotListener { snap, error in
            guard let documents = snap?.documents else {
                print("No documents")
                return
            }
            self.recipes = documents.map { snap -> DrinkRecipeModel in
                let data = snap.data()
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let tag = data["tag"] as? String ?? ""
                let weatherTag = data["weatherTag"] as? String ?? ""
                let instruction = data["instruction"] as? [String] ?? []
                let ingredients = data["ingredients"] as? [String] ?? []
                let image = data["image"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                var recipe = DrinkRecipeModel(id: id, title: title, weatherTag: weatherTag, tag: tag, instruction: instruction, ingredients: ingredients, image: image, description: description)
                recipe.isFavorite = self.favoriteRecipes.contains { $0.id == id }
                return recipe
            }
            // Вызываем метод filterRecipes после того, как все рецепты были обновлены
            self.filterRecipes(with: "")
        }
    }

    func addRecipeToUserFavorites(recipe: DrinkRecipeModel) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let uniqueId = "\(userId)_\(recipe.id)"
        let docRef = db.collection("user_drinks_recipes").document(uniqueId)
        let recipeData: [String: Any] = [
            "userId": userId,
            "recipeId": recipe.id,
            "title": recipe.title,
            "weatherTag": recipe.weatherTag,
            "tag": recipe.tag,
            "instruction": recipe.instruction,
            "ingredients": recipe.ingredients,
            "image": recipe.image,
            "description": recipe.description
        ]
        docRef.setData(recipeData) { error in
            if let error = error {
                print("Ошибка при сохранении рецепта пользователю: \(error)")
            } else {
                if let index = self.recipes.firstIndex(where: { $0.id == recipe.id }) {
                    self.recipes[index].isFavorite = true
                }
                print("Рецепт успешно добавлен в избранное пользователя")
            }
        }
    }

    func removeRecipeFromUserFavorites(recipe: DrinkRecipeModel) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let uniqueId = "\(userId)_\(recipe.id)"
        db.collection("user_drinks_recipes").document(uniqueId).delete { error in
            if let error = error {
                print("Ошибка при удалении рецепта из избранного: \(error)")
            } else {
                if let index = self.recipes.firstIndex(where: { $0.id == recipe.id }) {
                    self.recipes[index].isFavorite = false
                }
                print("Рецепт успешно удален из избранного пользователя")
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

    func fetchFavoriteRecipes() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("user_drinks_recipes")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snap, error in
                guard let documents = snap?.documents else {
                    print("No favorite recipes documents")
                    return
                }
                self.favoriteRecipes = documents.map { doc -> DrinkRecipeModel in
                    let data = doc.data()
                    let id = data["recipeId"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let tag = data["tag"] as? String ?? ""
                    let weatherTag = data["weatherTag"] as? String ?? ""
                    let instruction = data["instruction"] as? [String] ?? []
                    let ingredients = data["ingredients"] as? [String] ?? []
                    let image = data["image"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    return DrinkRecipeModel(id: id, title: title, weatherTag: weatherTag, tag: tag, instruction: instruction, ingredients: ingredients, image: image, description: description, isFavorite: true)
                }
                self.updateRecipesFavoriteState()
            }
    }

    private func updateRecipesFavoriteState() {
        recipes.indices.forEach { index in
            recipes[index].isFavorite = favoriteRecipes.contains { $0.id == recipes[index].id }
        }
        objectWillChange.send()
    }
}
