// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

@main
struct dugraph: ParsableCommand {
  mutating func run() throws {
    let recipes = try loadRecipes()
    let recipeIndex = RecipeIndex(recipes: recipes)

    print("Loaded \(recipes.count) recipes.")

    let items = ItemIndex(recipes: recipes)
    print("got \(items.count) unique items.")
    reportUnnamedItems(items)

    let producers = ProducerIndex(recipes: recipes)
    print("got \(producers.count) producers.")

    for producer in producers.sortedProducers {
      if producer.tier == .basic {
        var allOverlaps: Set<Int> = []
        for recipeID in producer.recipes {
          if let recipe = recipeIndex.recipesByID[recipeID] {
            let ingredients = Set(recipe.ingredients.map { $0.id })
            allOverlaps.formUnion(producer.products.intersection(ingredients))
          }
        }

        if !allOverlaps.isEmpty {
          let overlappingItems = allOverlaps.compactMap { items.itemsByID[$0] }
          print(" - \(producer.name) uses ingredients which it also makes:")
          for item in overlappingItems {
            let recipes = recipeIndex.recipesUsing(itemID: item.id).filter {
              producer.recipes.contains($0.id)
            }
            print(
              " -  \(item.name) for \(recipes.map { $0.name }.joined(separator: ", "))"
            )
          }
        }
        print("\n\n")
      }
    }
  }

  private func reportUnnamedItems(_ items: ItemIndex) {
    let unnamed = items.unnamed.map { $0.id }
    print("Recipes with unnamed products: \(unnamed)")
  }

}
