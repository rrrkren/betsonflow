import SportOracle from 0x42880022fd60a371
import BetExchange from 0xbb5968808fa5535e

pub struct FixtureWithOdds {
    pub let fixture: SportOracle.Fixture
    pub let betoffer: [&AnyResource{BetExchange.PublicBetOffer}?]

    init(fixture: SportOracle.Fixture, betoffer: [&AnyResource{BetExchange.PublicBetOffer}?]) {
        self.fixture = fixture
        self.betoffer = betoffer
    }
}

pub fun main(): [FixtureWithOdds] {

  let oracle = getAccount(0x42880022fd60a371)

  let res: [FixtureWithOdds] = []

  let fixtureCollectionRef = oracle.getCapability(/public/SportOracleFixtureCollection).borrow<&AnyResource{SportOracle.PublicFixtureCollection}>() ?? panic("could not borrow collection")

  let layer = getAccount(0x349cbc429ab9128f)

  let offerCollectionRef = layer.getCapability(/public/BetOfferCollection).borrow<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>() ?? panic("could not borrow collection")


  for id in fixtureCollectionRef.GetFixtureIDs() {
    let fixtureWithOdds = FixtureWithOdds(
      fixture: fixtureCollectionRef.GetFixture(id: id)!,
      betoffer: [offerCollectionRef.getBetOfferByFixtureID(fixtureID: id, oracleAddress: oracle.address)]
    )
    res.append(fixtureWithOdds)
  }


  return res

}
