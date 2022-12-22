import SportOracle from 0x42880022fd60a371

transaction {

  prepare(acct: AuthAccount) {
    let fixtureCollection = acct.borrow<&SportOracle.FixtureCollection>(from: /storage/SportOracleFixtureCollection) ?? panic("sport oracle fixture collection not found")
    var f = SportOracle.Fixture(id: 3,sport: SportOracle.SportType.BASKETBALL,league: "NBA", home_team: "Toronto Raptors", away_team: "Utah Jazz", start_time_utc: 1672020001000)
    fixtureCollection.AddFixture(f: f)

    f = SportOracle.Fixture(id: 4,sport: SportOracle.SportType.BASKETBALL,league: "NBA", home_team: "Philadelphia 76ers", away_team: "Cleveland Cavaliers", start_time_utc: 1672020000000)
    fixtureCollection.AddFixture(f: f)
  }
}
