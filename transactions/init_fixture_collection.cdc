import SportOracle from 0xf3fcd2c1a78f5eee

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@SportOracle.FixtureCollection>(<- SportOracle.NewFixtureCollection(), to: /storage/SportOracleFixtureCollection)

    acct.link<&SportOracle.FixtureCollection{SportOracle.PublicFixtureCollection}>(/public/SportOracleFixtureCollection, target: /storage/SportOracleFixtureCollection)
  }
}
