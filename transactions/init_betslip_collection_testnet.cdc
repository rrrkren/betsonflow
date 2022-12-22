import BetExchange from 0xdc8ea2ecd2a3fa4f

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@BetExchange.BetSlipCollection>(<- BetExchange.CreateBetSlipCollection(), to: /storage/BetSlipCollection)

    acct.link<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection, target: /storage/BetSlipCollection)
  }
}
