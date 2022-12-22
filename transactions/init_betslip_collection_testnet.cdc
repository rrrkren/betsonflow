import BetExchange from 0x2525efb20a173a39

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@BetExchange.BetSlipCollection>(<- BetExchange.CreateBetSlipCollection(), to: /storage/BetSlipCollection)

    acct.link<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection, target: /storage/BetSlipCollection)
  }
}
