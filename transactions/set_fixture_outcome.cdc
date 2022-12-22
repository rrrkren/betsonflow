import SportOracle from 0xf3fcd2c1a78f5eee

transaction {

  prepare(acct: AuthAccount) {
    let fixtureCollection = acct.borrow<&SportOracle.FixtureCollection>(from: /storage/SportOracleFixtureCollection) ?? panic("sport oracle fixture collection not found")
    let fixture = fixtureCollection.GetFixture(id: 1)!

    fixture.outcome = SportOracle.FixtureOutcome.HOME_WIN

    fixtureCollection.UpdateFixture(f: fixture)
  }
}
