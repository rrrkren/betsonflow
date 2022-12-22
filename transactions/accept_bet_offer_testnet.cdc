import FungibleToken from 0x9a0766d93b6608b7
import SportOracle from 0x42880022fd60a371
import FTEscrow from 0x56de6f6221fee904
import BetExchange from 0xdc8ea2ecd2a3fa4f
import FlowToken from 0x7e60df042a9c0868

transaction {

    prepare(acct: AuthAccount) {


        let layer = getAccount(0xc8a2e850a44c8063)

        let betOfferPublicCollection = layer.getCapability<&AnyResource{BetExchange.PublicBetOfferCollection}>(/public/BetOfferCollection).borrow()!

        let betOffer = betOfferPublicCollection.getBetOffer(id: 123788328)

    var vaultRef = acct.getCapability
            <&AnyResource{FungibleToken.Provider}>
            (/private/flowTokenProvider)
    if vaultRef.borrow() == nil {
        acct.link<&FlowToken.Vault{FungibleToken.Provider}>(/private/flowTokenProvider, target: /storage/flowTokenVault)
        vaultRef = acct.getCapability<&AnyResource{FungibleToken.Provider}>(/private/flowTokenProvider)
    }

        let stake <- vaultRef.borrow()!.withdraw(amount: 5.0)

        let betSlip <- betOffer.acceptOffer(stake: <- stake)

        var betSlipCollectionRef = acct.getCapability<&AnyResource{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection)

        if betSlipCollectionRef.borrow() == nil {
            acct.save<@BetExchange.BetSlipCollection>(<- BetExchange.CreateBetSlipCollection(), to: /storage/BetSlipCollection)
            acct.link<&BetExchange.BetSlipCollection{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection, target: /storage/BetSlipCollection)
            betSlipCollectionRef = acct.getCapability<&AnyResource{BetExchange.PublicBetSlipCollection}>(/public/BetSlipCollection)
        }


        betSlipCollectionRef.borrow()!.depositBetSlip(betSlip: <- betSlip)
    }
}