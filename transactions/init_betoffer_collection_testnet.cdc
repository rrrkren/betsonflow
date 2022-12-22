import BetExchange from 0xbb5968808fa5535e

transaction {

  prepare(acct: AuthAccount) {
    acct.save<@BetExchange.BetOfferCollection>(<- BetExchange.CreateBetofferCollection(), to: /storage/BetOfferCollection)

    acct.link<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>(/public/BetOfferCollection, target: /storage/BetOfferCollection)
  }
}
