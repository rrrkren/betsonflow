import BetExchange from 0xbb5968808fa5535e

pub fun main(): [UInt64] {

  let layer = getAccount(0x349cbc429ab9128f)

  let offerCollectionRef = layer.getCapability(/public/BetOfferCollection).borrow<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>() ?? panic("could not borrow collection")

  return offerCollectionRef.getBetOfferIDs()

}
