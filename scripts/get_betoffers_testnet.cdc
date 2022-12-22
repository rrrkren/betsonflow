import BetExchange from 0x2525efb20a173a39

pub fun main(): [BetExchange.BetOfferInfoV2] {

  let layer = getAccount(0xc142566f1bed3ae6)

  let offerCollectionRef = layer.getCapability(/public/BetOfferCollection).borrow<&BetExchange.BetOfferCollection{BetExchange.PublicBetOfferCollection}>() ?? panic("could not borrow collection")

  let res: [BetExchange.BetOfferInfoV2] = []

  for id in offerCollectionRef.getBetOfferIDs() {
    res.append(offerCollectionRef.getBetOffer(id: id).getBetOfferInfo())
  }

  return res
}
