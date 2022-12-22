import SportOracle from 0x42880022fd60a371
import BetExchange from 0xdc8ea2ecd2a3fa4f

pub struct BetSlipWithFixture {
    pub let fixture: SportOracle.Fixture
    pub let betSlip: BetExchange.BetSlipInfo
    init(fixture: SportOracle.Fixture, betSlip: BetExchange.BetSlipInfo) {
        self.fixture = fixture
        self.betSlip = betSlip
    }
}

pub fun main(): [BetSlipWithFixture] {
  let oracle = getAccount(0x42880022fd60a371)

  let fixtureCollectionRef = oracle.getCapability(/public/SportOracleFixtureCollection).borrow<&AnyResource{SportOracle.PublicFixtureCollection}>() ?? panic("could not borrow collection")

  let bettor = getAccount(0x342e1f6b0676a66e)

  let betslipCollectionRef = bettor.getCapability(/public/BetSlipCollection).borrow<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>() ?? panic("could not borrow collection")

  let res: [BetSlipWithFixture] = []

  for id in betslipCollectionRef.getBetSlipIDs() {
    let betslip = betslipCollectionRef.borrowBetSlip(id: id).GetBetSlipInfo()
    let slipWithFixture = BetSlipWithFixture(
      fixture: fixtureCollectionRef.GetFixture(id: betslip.fixtureID)!,
      betSlip: betslip
    )
    res.append(slipWithFixture)
  }

  return res
}
