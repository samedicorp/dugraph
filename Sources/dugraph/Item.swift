protocol Item: Codable {
  var id: Int { get }
  var displayNameWithSize: String? { get }
  var locDisplayNameWithSize: String? { get }
  var locDisplayNameWithSizeDE: String? { get }
}

extension Item {
  var name: String {
    return displayNameWithSize ?? locDisplayNameWithSize ?? locDisplayNameWithSizeDE
      ?? "Unknown Item"
  }

  var isUnnamed: Bool {
    locDisplayNameWithSize == nil && displayNameWithSize == nil && locDisplayNameWithSizeDE == nil
  }

  var tier: Tier {
    if let name = name.lowercased() as String? {
      if name.contains("basic") {
        return .basic
      } else if name.contains("uncommon") {
        return .uncommon
      } else if name.contains("advanced") {
        return .advanced
      } else if name.contains("rare") {
        return .rare
      }
    }
    return .unknown
  }

  var basicName: String {
    let wordsToRemove = [
      "Basic", "Uncommon", "Advanced", "Rare", "xs", "s", "m", "l", "xl", "product",
    ]
    let words = name.split(separator: " ")
    let filtered = words.filter { !wordsToRemove.contains(String($0)) }
    return filtered.joined(separator: " ")
  }
}
