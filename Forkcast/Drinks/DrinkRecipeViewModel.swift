//
//  DrinkRecipeViewModel.swift
//  Forkcast
//
//  Created by Дмитрий Снигирев on 17.06.2024.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

// Модель рецепта напитка, которая видима и может наблюдаться другими
class DrinkRecipeViewModel: ObservableObject {
    // Список всех рецептов, который наблюдаем. Каждый раз при изменении, обновляется filteredRecipes.
    @Published var recipes: [DrinkRecipeModel] = [] {
        didSet {
            // Обновляем фильтрованные рецепты, когда общий список обновляется
            filteredRecipes = recipes
        }
    }
    
    // Выбранный рецепт, отображаемый на экране деталей
    @Published var selectedRecipe: DrinkRecipeModel?
    
    // Указывает, фильтруются ли рецепты по погодным условиям
    @Published var isFilteringByWeather: Bool = false
    
    // Список избранных рецептов пользователя
    @Published var favoriteRecipes: [DrinkRecipeModel] = []
    
    // Список рецептов, отфильтрованных на основе поисковой строки или погодных условий
    @Published var filteredRecipes: [DrinkRecipeModel] = []

    // Ссылка на базу данных Firestore
    private var db = Firestore.firestore()
    
    // Ссылка на хранилище изображений Firebase
    private let storage = Storage.storage()

    // Тег для фильтрации рецептов по погоде. Когда тег изменяется, рецепты фильтруются заново.
    var selectedWeatherTag: String? {
        didSet {
            // Если фильтрация по погоде включена, фильтруем рецепты по новому тегу
            if isFilteringByWeather {
                guard let selectedWeatherTag = selectedWeatherTag else { return }
                filterRecipesByWeather(tag: selectedWeatherTag)
            }
        }
    }

    // Первоначальная инициализация ViewModel, загрузка избранных рецептов пользователя
    init() {
        fetchFavoriteRecipes()
    }
    
    // Функция для фильтрации рецептов на основе поискового текста
    func filterRecipes(with searchText: String) {
        if searchText.isEmpty {
            // Если поисковый текст пуст, устанавливаем отфильтрованные рецепты равными основным
            filteredRecipes = recipes
        } else {
            // Иначе фильтруем рецепты по заголовку
            filteredRecipes = recipes.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // Обновление тега погоды, использующегося для фильтрации
    func updateWeatherTag() {
        guard let selectedTag = WeatherManager.shared.getWeatherTag() else { return }
        selectedWeatherTag = selectedTag
    }

    // Изменение статуса избранного для данного рецепта
    func toggleFavorite(for recipe: DrinkRecipeModel) {
        let updatedRecipe = recipe
        if recipe.isFavorite {
            // Если рецепт уже в избранном, удаляем его из избранного
            removeRecipeFromUserFavorites(recipe: recipe)
        } else {
            // В противном случае добавляем в избранное
            addRecipeToUserFavorites(recipe: recipe)
        }
        updatedRecipe.isFavorite.toggle()  // Инвертируем флаг избранного у рецепта
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = updatedRecipe  // Обновляем рецепт в общем списке
        }
    }

    // Загрузка данных рецептов из Firestore
    func fetchData() {
        db.collection("drinks_recipes").addSnapshotListener { snap, error in
            guard let documents = snap?.documents else {
                print("No documents")
                return
            }
            self.recipes = documents.map { snap -> DrinkRecipeModel in
                let data = snap.data()
                
                // Извлечение данных каждой документации и создание модели DrinkRecipeModel
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let tag = data["tag"] as? String ?? ""
                let weatherTag = data["weatherTag"] as? String ?? ""
                let instruction = data["instruction"] as? [String] ?? []
                let ingredients = data["ingredients"] as? [String] ?? []
                let image = data["image"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let recipe = DrinkRecipeModel(id: id, title: title, weatherTag: weatherTag, tag: tag, instruction: instruction, ingredients: ingredients, image: image, description: description, isFavorite: false)
                
                // Установка флага избранного, если рецепт находится в списке избранных пользователя
                recipe.isFavorite = self.favoriteRecipes.contains { $0.id == id }
                return recipe
            }
            // Фильтруем рецепты после загрузки данных
            self.filterRecipes(with: "")
        }
    }

    // Добавление рецепта в избранное пользователя
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

    // Удаление рецепта из избранного пользователя
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

    // Фильтрация рецептов по тегу погоды
    func filterRecipesByWeather(tag: String) {
        if tag == "Hot" {
            recipes = recipes.filter { $0.weatherTag == "Hot" }
        } else if tag == "Cold" {
            recipes = recipes.filter { $0.weatherTag == "Cold" }
        }
    }
    
    // Отключение фильтрации по погоде и обновление списка рецептов
    func resetFilterByWeather() {
        isFilteringByWeather = false
        fetchData()
    }
    
    // Переключение фильтра по погоде
    func toggleFilterByWeather() {
        updateWeatherTag() // Обновляем текущий тег погоды
        if isFilteringByWeather {
            resetFilterByWeather() // Если фильтрация включена, сбрасываем ее
        } else {
            filterRecipesByWeather(tag: selectedWeatherTag ?? " ") // Иначе, фильтруем рецепты по тегу погоды
        }
        isFilteringByWeather.toggle() // Переключаем состояние фильтрации по погоде
    }

    // Загрузка изображений из Firebase Storage по URL
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = storage.reference(forURL: url)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else {
                // Преобразование загруженных данных в изображение
                if let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }

    // Загрузка избранных рецептов пользователя
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
                    // Извлечение данных каждого документа и создание модели DrinkRecipeModel
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

    // Обновление состояния избранного для рецептов в основном списке
    private func updateRecipesFavoriteState() {
        // Обновление каждого рецепта в общем списке в зависимости от того, находится ли он в избранном пользователя
        recipes.indices.forEach { index in
            recipes[index].isFavorite = favoriteRecipes.contains { $0.id == recipes[index].id }
        }
        // Информируем SwiftUI о необходимости обновления интерфейса
        objectWillChange.send()
    }
}
