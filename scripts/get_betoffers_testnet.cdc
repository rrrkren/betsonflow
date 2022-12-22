import BetExchange from 0xbb5968808fa5535e

pub fun main(): [BetExchange.BetOfferInfo] {

  let layer = getAccount(0x349cbc429ab9128f)

  let offerCollectionRef = layer.getCapability(/public/BetOfferCollection).borrow<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>() ?? panic("could not borrow collection")

  let res: [BetExchange.BetOfferInfo] = []

  for id in offerCollectionRef.getBetOfferIDs() {
    res.append(offerCollectionRef.getBetOffer(id: id).getBetOfferInfo())
  }

  return res
}
