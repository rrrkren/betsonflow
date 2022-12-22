import SportOracle from 0xf3fcd2c1a78f5eee

transaction {

  prepare(acct: AuthAccount) {
    let fixtureCollection = acct.borrow<&SportOracle.FixtureCollection>(from: /storage/SportOracleFixtureCollection) ?? panic("sport oracle fixture collection not found")
    var f = SportOracle.Fixture(id: 1,sport: SportOracle.SportType.BASKETBALL,league: "NBA", home_team: "Cleveland Cavaliers", away_team: "Utah Jazz", start_time_utc: 1671494400000)
    fixtureCollection.AddFixture(f: f)

    f = SportOracle.Fixture(id: 2,sport: SportOracle.SportType.BASKETBALL,league: "NBA", home_team: "Philadelphia 76ers", away_team: "Toronto Raptors", start_time_utc: 1671495000000)
    fixtureCollection.AddFixture(f: f)

    
  }
}
