// SetupAccount1TransactionMinting.cdc

import ExampleToken from 0x02
import FTEscrow from 0x03

// This transaction mints tokens for both accounts using
// the minter stored on account 0x01.
transaction {


  prepare(acct: AuthAccount) {

        let vaultRef = acct.borrow<&ExampleToken.Vault>(from: /storage/exampleTokenVault)
            ?? panic("Could not borrow owner's vault reference")

        // withdraw tokens from the buyers Vault
        let stakeVault <- vaultRef.withdraw(amount: 10.0)

        let escrowAccount = getAccount(0x03)

        let escrowCollection = escrowAccount.getCapability(/public/escrowCollection).borrow<&{FTEscrow.PublicEscrowCollection}>()!


        let escrow <- FTEscrow.createEscrow(vault: <-stakeVault)

        let accessToken <- escrow.createAccessToken(escrowAddress: 0x03)

        escrowCollection.depositEscrowAgreement(escrowAgreement: <- escrow)

        let ATescrowCollection = accessToken.GetEscrowCollection()
        let escrowAgreement <- ATescrowCollection.withdrawEscrowAgreementWithToken(accessToken: &accessToken as &FTEscrow.EscrowAccessToken)


        let escrowVault <- escrowAgreement.redeem(accessToken:  &accessToken as &FTEscrow.EscrowAccessToken)

        destroy accessToken

        destroy escrowAgreement

        log(escrowVault.balance)
        destroy escrowVault


  }
}
