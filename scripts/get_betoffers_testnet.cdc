import BetExchange from 0xdc8ea2ecd2a3fa4f

pub fun main(): [BetExchange.BetOfferInfo] {

  let layer = getAccount(0xc8a2e850a44c8063)

  let offerCollectionRef = layer.getCapability(/public/BetOfferCollection).borrow<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>() ?? panic("could not borrow collection")

  let res: [BetExchange.BetOfferInfo] = []

  for id in offerCollectionRef.getBetOfferIDs() {
    res.append(offerCollectionRef.getBetOffer(id: id).getBetOfferInfo())
  }

  return res
}
