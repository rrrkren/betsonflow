import SportOracle from 0x42880022fd60a371
import BetExchange from 0xdc8ea2ecd2a3fa4f

pub struct BetSlipWithFixture {
    pub let fixture: SportOracle.Fixture
    pub let betSlip: BetExchange.BetSlipInfo
    pub let won: Bool?
    init(fixture: SportOracle.Fixture, betSlip: BetExchange.BetSlipInfo, won: Bool?) {
        self.fixture = fixture
        self.betSlip = betSlip
        self.won = won
    }
}

pub fun main(): [BetSlipWithFixture] {
  let oracle = getAccount(0x42880022fd60a371)

  let fixtureCollectionRef = oracle.getCapability(/public/SportOracleFixtureCollection).borrow<&AnyResource{SportOracle.PublicFixtureCollection}>() ?? panic("could not borrow collection")

  let bettor = getAccount(0x33718a8193133058)

  let betslipCollectionRef = bettor.getCapability(/public/BetSlipCollection).borrow<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>() ?? panic("could not borrow collection")

  let res: [BetSlipWithFixture] = []

  for id in betslipCollectionRef.getBetSlipIDs() {
    let betslip = betslipCollectionRef.borrowBetSlip(id: id)
    let betslipInfo = betslip.GetBetSlipInfo()
    var won: Bool? = nil
    let fixture = fixtureCollectionRef.GetFixture(id: betslipInfo.fixtureID)!

    if fixture.outcome != nil {
      won = betslip.HasWon()
    }
    let slipWithFixture = BetSlipWithFixture(
      fixture: fixtureCollectionRef.GetFixture(id: betslipInfo.fixtureID)!,
      betSlip: betslipInfo,
      won: won
    )
    res.append(slipWithFixture)
  }

  return res
}
