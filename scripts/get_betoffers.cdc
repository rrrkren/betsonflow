import BetExchange from 0xe03daebed8ca0615

pub fun main(): [UInt64] {

  let acct1 = getAccount(0x045a1763c93006ca)

  let offerCollectionRef = acct1.getCapability(/public/BetOfferCollection).borrow<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>() ?? panic("could not borrow collection")

  return offerCollectionRef.getBetOfferIDs()

}
