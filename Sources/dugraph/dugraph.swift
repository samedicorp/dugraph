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

    let tiers: Set<Tier> = [.basic]  //  Set<Tier>(Tier.allCases)

    for producer in producers.sortedProducers {
      var nonOverlappingRecipes: Set<Int> = []
      if tiers.contains(producer.tier) {
        var allOverlaps: Set<Int> = []
        for recipeID in producer.recipes {
          if let recipe = recipeIndex.recipesByID[recipeID] {
            let ingredients = Set(recipe.ingredients.map { $0.id })
            let overlappingIngredients = producer.products.intersection(ingredients)
            allOverlaps.formUnion(overlappingIngredients)
            if overlappingIngredients.isEmpty {
              nonOverlappingRecipes.insert(recipeID)
            }
          }
        }

        if !allOverlaps.isEmpty {
          let overlappingItems = allOverlaps.compactMap { items.itemsByID[$0] }
          print("\(producer.name.uppercased()) uses ingredients which it also makes:")
          for item in overlappingItems {
            let recipes = recipeIndex.recipesUsing(itemID: item.id).filter {
              producer.recipes.contains($0.id)
            }
            let names = Set(recipes.map { $0.basicName }).sorted()
            print(
              " -  \(item.name) (\(names.joined(separator: ", ")))"
            )
          }
        }

        if !nonOverlappingRecipes.isEmpty {
          let recipes = nonOverlappingRecipes.compactMap { recipeIndex.recipesByID[$0] }
          print(
            "\nNon-recursive items are:\n- \(recipes.map { $0.name }.sorted().joined(separator: ", "))"
          )
        }
        print("\n\n-----------\n\n")
      }
    }
  }

  private func reportUnnamedItems(_ items: ItemIndex) {
    let unnamed = items.unnamed.map { $0.id }
    print("Recipes with unnamed products: \(unnamed)")
  }

}
