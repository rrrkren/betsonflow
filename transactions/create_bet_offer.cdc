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


    let escrowAddress :Address = 0x179b6b1cb6755e31
    let oracleAddress :Address = 0xf3fcd2c1a78f5eee
    let maxExposure: UFix64 = 5000.0
    let fixtureID: UInt64 = 1

    var winMultiplier = 1.2
    var winOutcome = SportOracle.FixtureOutcome.HOME_WIN
    let betOffer <- BetExchange.createBetOffer(FTProvider: vaultRef, EscrowAddress: escrowAddress, LayerBetSlipCollection: betSlipCollectionRef, WinMultiplier: winMultiplier, WinOutcome: winOutcome, fixtureID: fixtureID, oracleAddress: oracleAddress, maxExposure: maxExposure)
    betOfferCollectionRef.addBetOffer(betOffer: <-betOffer)

    winMultiplier = 2.5
    winOutcome = SportOracle.FixtureOutcome.AWAY_WIN

    let secondOffer <- BetExchange.createBetOffer(FTProvider: vaultRef, EscrowAddress: escrowAddress, LayerBetSlipCollection: betSlipCollectionRef, WinMultiplier: winMultiplier, WinOutcome: winOutcome, fixtureID: fixtureID, oracleAddress: oracleAddress, maxExposure: maxExposure)
    betOfferCollectionRef.addBetOffer(betOffer: <-secondOffer)
  }
}
