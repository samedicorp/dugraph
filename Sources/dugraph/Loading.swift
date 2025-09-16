import Foundation

func loadRecipes() throws -> [Recipe] {
  guard
    let recipesURL = Bundle.module.url(
      forResource: "recipes_api_dump", withExtension: "json", subdirectory: "Data")
  else {
    throw NSError(
      domain: "dugraph", code: 1,
      userInfo: [NSLocalizedDescriptionKey: "Failed to locate JSON file."])
  }

  let recipesData = try Data(contentsOf: recipesURL)
  let decoder = JSONDecoder()
  return try decoder.decode([Recipe].self, from: recipesData)
}

func loadItems() throws {
  guard
    let itemsURL = Bundle.module.url(
      forResource: "items_api_dump", withExtension: "json", subdirectory: "Data")
  else {
    print("Failed to locate JSON file.")
    return
  }

  let itemsData = try Data(contentsOf: itemsURL)
  let itemsObject = try JSONSerialization.jsonObject(with: itemsData, options: [])
  guard let items = itemsObject as? [[String: Any]] else {
    print("Failed to cast JSON object to [String: Any]")
    return
  }

  print("Loaded \(items.count) items.")
}
