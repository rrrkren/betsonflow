import BetExchange from 0xdc8ea2ecd2a3fa4f

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@BetExchange.BetOfferCollection>(<- BetExchange.CreateBetofferCollection(), to: /storage/BetOfferCollection)

    acct.link<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>(/public/BetOfferCollection, target: /storage/BetOfferCollection)
  }
}
