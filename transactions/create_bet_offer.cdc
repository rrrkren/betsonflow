import FungibleToken from 0x01cf0e2f2f715450
import SportOracle from 0xf3fcd2c1a78f5eee
import FTEscrow from 0x179b6b1cb6755e31
import BetExchange from 0xe03daebed8ca0615
import ExampleToken from 0x01cf0e2f2f715450

transaction {

  prepare(acct: AuthAccount) {

    let vaultRef = acct.getCapability
            <&AnyResource{FungibleToken.Provider}>
            (/private/exampleTokenProvider)

    let betOfferCollectionRef = acct.borrow<&BetExchange.BetOfferCollection>(from: /storage/BetOfferCollection) ?? panic("Could not borrow a reference to the owner's BetOffer collection")

    let betSlipCollectionRef = acct.getCapability<&AnyResource{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection)


    let betOffer <- BetExchange.createBetOffer(FTProvider: vaultRef, EscrowAddress: 0x179b6b1cb6755e31, LayerBetSlipCollection: betSlipCollectionRef, WinMultiplier: 1.5, WinOutcome: SportOracle.FixtureOutcome.HOME_WIN, fixtureID: 2, oracleAddress: 0xf3fcd2c1a78f5eee, maxExposure: 5000.0)

    betOfferCollectionRef.addBetOffer(betOffer: <-betOffer)
  }
}
