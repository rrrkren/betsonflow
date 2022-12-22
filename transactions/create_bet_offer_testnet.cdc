import FungibleToken from 0x9a0766d93b6608b7
import SportOracle from 0x42880022fd60a371
import FTEscrow from 0x56de6f6221fee904
import BetExchange from 0xbb5968808fa5535e
import FlowToken from 0x7e60df042a9c0868

transaction {

  prepare(acct: AuthAccount) {

    var vaultRef = acct.getCapability
            <&AnyResource{FungibleToken.Provider}>
            (/private/flowTokenProvider)
    if vaultRef.borrow() == nil {
        acct.link<&FlowToken.Vault{FungibleToken.Provider}>(/private/flowTokenProvider, target: /storage/flowTokenVault)
        vaultRef = acct.getCapability<&AnyResource{FungibleToken.Provider}>(/private/flowTokenProvider)
    }

    let betOfferCollectionRef = acct.borrow<&BetExchange.BetOfferCollection>(from: /storage/BetOfferCollection) ?? panic("Could not borrow a reference to the owner's BetOffer collection")

    let betSlipCollectionRef = acct.getCapability<&AnyResource{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection)

    let escrowAddress :Address = 0x56de6f6221fee904
    let oracleAddress :Address = 0x42880022fd60a371
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
