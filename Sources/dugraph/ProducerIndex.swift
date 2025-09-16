struct ProducerIndex {
  let producersByID: [Int: Producer]
  let producersByName: [String: Producer]

  init(recipes: [Recipe]) {
    var allProducers: [Int: Producer] = [:]
    for recipe in recipes {
      for item in recipe.producers {
        var producer = allProducers[item.id]
        if producer == nil {
          producer = Producer(item)
          allProducers[item.id] = producer
        }
        producer!.addRecipe(recipe)
      }
    }
    self.producersByID = allProducers
    self.producersByName = Dictionary(
      uniqueKeysWithValues: allProducers.values.map { ($0.name, $0) })
  }

  var count: Int {
    return producersByID.count
  }

  var sortedProducers: [Producer] {
    return producersByName.values.sorted(by: { $0.tier.rawValue < $1.tier.rawValue })
  }
}
