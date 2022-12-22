import BetExchange from 0xe03daebed8ca0615

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@BetExchange.BetOfferCollection>(<- BetExchange.CreateBetofferCollection(), to: /storage/BetOfferCollection)

    acct.link<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>(/public/BetOfferCollection, target: /storage/BetOfferCollection)
  }
}
