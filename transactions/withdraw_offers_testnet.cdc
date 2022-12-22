import FungibleToken from 0x9a0766d93b6608b7
import SportOracle from 0x42880022fd60a371
import FTEscrow from 0x56de6f6221fee904
import BetExchange from 0xdc8ea2ecd2a3fa4f
import FlowToken from 0x7e60df042a9c0868

transaction {

  prepare(acct: AuthAccount) {


    let betOfferCollection = acct.borrow<&BetExchange.BetOfferCollection>(from: /storage/BetOfferCollection)
      ?? panic("Could not borrow a reference to the owner's BetOfferCollection")


    destroy betOfferCollection.withdrawBetOffer(id: 1)
    destroy betOfferCollection.withdrawBetOffer(id: 1)

  }
}
