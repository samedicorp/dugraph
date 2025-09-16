struct Recipe: Codable {
  let id: Int
  let tier: Int
  let time: Int  // in seconds
  let nanocraftable: Bool
  let ingredients: [CountedItem]
  let products: [CountedItem]
  let producers: [BasicItem]

  var name: String {
    products.first?.name ?? "Unknown Recipe"
  }
}
