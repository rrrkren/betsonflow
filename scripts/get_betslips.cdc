import BetExchange from 0xe03daebed8ca0615

pub fun main(): [UInt64] {

  let acct1 = getAccount(0x120e725050340cab)

  let betslipCollectionRef = acct1.getCapability(/public/BetSlipCollection).borrow<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>() ?? panic("could not borrow collection")

  return betslipCollectionRef.getBetSlipIDs()
}
