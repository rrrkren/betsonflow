import FungibleToken from 0x01cf0e2f2f715450
import SportOracle from 0xf3fcd2c1a78f5eee
import FTEscrow from 0x179b6b1cb6755e31
import BetExchange from 0xe03daebed8ca0615
import ExampleToken from 0x01cf0e2f2f715450

transaction {

    prepare(acct: AuthAccount) {


        let flowTokenReceiver = acct.getCapability<&AnyResource{FungibleToken.Receiver}>(/public/exampleTokenReceiver).borrow()!

        let betSlipCollection = acct.borrow<&BetExchange.BetSlipCollection>(from: /storage/BetSlipCollection)
            ?? panic("Could not borrow BetSlipCollection from storage")

        let betSlip <- betSlipCollection.withdrawBetSlip(id: 58)

        let winning <- betSlip.SettleBet()!

        flowTokenReceiver.deposit(from: <-winning)
        destroy betSlip
    }
}