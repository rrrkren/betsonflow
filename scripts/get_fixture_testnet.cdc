import SportOracle from 0x42880022fd60a371

pub fun main(): [SportOracle.Fixture] {

  let acct1 = getAccount(0x42880022fd60a371)

  let res: [SportOracle.Fixture] = []

  let fixtureCollectionRef = acct1.getCapability(/public/SportOracleFixtureCollection).borrow<&AnyResource{SportOracle.PublicFixtureCollection}>() ?? panic("could not borrow collection")


  for id in fixtureCollectionRef.GetFixtureIDs() {
    res.append(fixtureCollectionRef.GetFixture(id: id)!)
  }


  return res
  
}
