import BetExchange from 0xbb5968808fa5535e

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@BetExchange.BetSlipCollection>(<- BetExchange.CreateBetSlipCollection(), to: /storage/BetSlipCollection)

    acct.link<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection, target: /storage/BetSlipCollection)
  }
}
