import BetExchange from 0xdc8ea2ecd2a3fa4f

pub fun main(): [BetExchange.BetSlipInfo] {

  let bettor = getAccount(0x342e1f6b0676a66e)

  let betslipCollectionRef = bettor.getCapability(/public/BetSlipCollection).borrow<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>() ?? panic("could not borrow collection")

  let res: [BetExchange.BetSlipInfo] = []

  for id in betslipCollectionRef.getBetSlipIDs() {
    res.append(betslipCollectionRef.borrowBetSlip(id: id).GetBetSlipInfo())
  }

  return res
}
