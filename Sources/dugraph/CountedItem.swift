struct CountedItem: Item, Codable {
  let id: Int
  let displayNameWithSize: String?
  let locDisplayNameWithSize: String?
  let locDisplayNameWithSizeDE: String?
  let quantity: Double
}
