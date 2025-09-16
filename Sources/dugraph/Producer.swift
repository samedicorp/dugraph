class Producer: Item {
  let id: Int
  let displayNameWithSize: String?
  let locDisplayNameWithSize: String?
  let locDisplayNameWithSizeDE: String?
  var products: Set<Int>
  var recipes: Set<Int>

  init(_ item: Item) {
    self.id = item.id
    self.displayNameWithSize = item.displayNameWithSize
    self.locDisplayNameWithSize = item.locDisplayNameWithSize
    self.locDisplayNameWithSizeDE = item.locDisplayNameWithSizeDE
    self.products = []
    self.recipes = []
  }

  func addRecipe(_ recipe: Recipe) {
    recipes.insert(recipe.id)
    for item in recipe.products {
      products.insert(item.id)
    }
  }
}
