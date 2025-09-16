struct RecipeIndex: Codable {
  var recipesByID: [Int: Recipe]
  var recipesByName: [String: Recipe]

  init(recipes: [Recipe]) {
    var byID: [Int: Recipe] = [:]
    var byName: [String: Recipe] = [:]
    for recipe in recipes {
      byID[recipe.id] = recipe
      if let name = recipe.products.first?.name {
        byName[name] = recipe
      }
    }
    self.recipesByID = byID
    self.recipesByName = byName
  }

  func recipesUsing(itemID: Int) -> [Recipe] {
    return recipesByID.values.filter { recipe in
      recipe.ingredients.contains(where: { $0.id == itemID })
    }
  }
}
