// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

protocol Item: Codable {
  var id: Int { get }
  var displayNameWithSize: String? { get }
  var locDisplayNameWithSize: String? { get }
  var locDisplayNameWithSizeDE: String? { get }
}

extension Item {
  var name: String {
    return locDisplayNameWithSize ?? displayNameWithSize ?? "Unknown Item"
  }
}

struct BasicItem: Item, Codable {
  let id: Int
  let displayNameWithSize: String?
  let locDisplayNameWithSize: String?
  let locDisplayNameWithSizeDE: String?
}

struct CountedItem: Item, Codable {
  let id: Int
  let displayNameWithSize: String?
  let locDisplayNameWithSize: String?
  let locDisplayNameWithSizeDE: String?
  let quantity: Double
}

struct Recipe: Codable {
  let id: Int
  let tier: Int
  let time: Int  // in seconds
  let nanocraftable: Bool
  let ingredients: [CountedItem]
  let products: [CountedItem]
  let producers: [BasicItem]
}

@main
struct dugraph: ParsableCommand {
  mutating func run() throws {
    let recipes = try loadRecipes()
    print("Loaded \(recipes.count) recipes.")

    var items: [Int: Item] = [:]
    for recipe in recipes {
      for product in recipe.products {
        items[product.id] = product
      }
      for ingredient in recipe.ingredients {
        items[ingredient.id] = ingredient
      }
    }

    let unnamed =
      items
      .filter {
        $0.value.name == "Unknown Item"
      }
      .map { $0.value.id }
    print("Recipes with unnamed products: \(unnamed)")

    try loadItems()
  }

  private func loadRecipes() throws -> [Recipe] {
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

  private func loadItems() throws {
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
}
