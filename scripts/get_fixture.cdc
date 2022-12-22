import SportOracle from 0xf3fcd2c1a78f5eee

pub fun main(): [SportOracle.Fixture] {

  let acct1 = getAccount(0xf3fcd2c1a78f5eee)

  let res: [SportOracle.Fixture] = []

  let fixtureCollectionRef = acct1.getCapability(/public/SportOracleFixtureCollection).borrow<&AnyResource{SportOracle.PublicFixtureCollection}>() ?? panic("could not borrow collection")


  for id in fixtureCollectionRef.GetFixtureIDs() {
    res.append(fixtureCollectionRef.GetFixture(id: id)!)
  }


  return res
  
}
