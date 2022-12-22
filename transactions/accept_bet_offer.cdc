import FungibleToken from 0x01cf0e2f2f715450
import SportOracle from 0xf3fcd2c1a78f5eee
import FTEscrow from 0x179b6b1cb6755e31
import BetExchange from 0xe03daebed8ca0615
import ExampleToken from 0x01cf0e2f2f715450

transaction {

    prepare(acct: AuthAccount) {

        let layer = getAccount(0x045a1763c93006ca)

        let betOfferPublicCollection = layer.getCapability<&AnyResource{BetExchange.PublicBetOfferCollection}>(/public/BetOfferCollection).borrow()!


        let betOffer = betOfferPublicCollection.getBetOffer(id: 52)

        let vaultRef = acct.getCapability
                <&AnyResource{FungibleToken.Provider}>
                (/private/exampleTokenProvider).borrow()!

        let stake <- vaultRef.withdraw(amount: 5.0)

        let betSlip <- betOffer.acceptOffer(stake: <- stake, outcome: SportOracle.FixtureOutcome.HOME_WIN)

        let betSlipCollectionRef = acct.getCapability<&AnyResource{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection).borrow()!

        betSlipCollectionRef.depositBetSlip(betSlip: <- betSlip)
    }
}