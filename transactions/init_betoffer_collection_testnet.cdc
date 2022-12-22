import BetExchange from 0x2525efb20a173a39

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@BetExchange.BetOfferCollection>(<- BetExchange.CreateBetofferCollection(), to: /storage/BetOfferCollection)

    acct.link<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>(/public/BetOfferCollection, target: /storage/BetOfferCollection)
  }
}
