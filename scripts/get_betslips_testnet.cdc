import BetExchange from 0xdc8ea2ecd2a3fa4f

pub fun main(): [UInt64] {

  let bettor = getAccount(0x342e1f6b0676a66e)

  let betslipCollectionRef = bettor.getCapability(/public/BetSlipCollection).borrow<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>() ?? panic("could not borrow collection")

  return betslipCollectionRef.getBetSlipIDs()
}
