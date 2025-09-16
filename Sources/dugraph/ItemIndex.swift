struct ItemIndex {
  let itemsByID: [Int: Item]
  let itemsByName: [String: Item]

  init(items: [Item]) {
    var byID: [Int: Item] = [:]
    var byName: [String: Item] = [:]
    for item in items {
      byID[item.id] = item
      byName[item.name] = item
    }
    self.itemsByID = byID
    self.itemsByName = byName
  }

  init(recipes: [Recipe]) {
    var allItems: [Item] = []
    for recipe in recipes {
      allItems.append(contentsOf: recipe.products)
      allItems.append(contentsOf: recipe.ingredients)
    }
    self.init(items: allItems)
  }

  var count: Int {
    return itemsByID.count
  }

  var unnamed: [Item] {
    return itemsByID.values.filter { $0.isUnnamed }
  }
}
