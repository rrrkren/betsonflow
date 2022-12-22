import BetExchange from 0xe03daebed8ca0615

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@BetExchange.BetSlipCollection>(<- BetExchange.CreateBetSlipCollection(), to: /storage/BetSlipCollection)

    acct.link<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection, target: /storage/BetSlipCollection)
  }
}
