import FungibleToken from 0x01cf0e2f2f715450
import ExampleToken from 0x01cf0e2f2f715450

// This transaction mints tokens and deposits them into account 3's vault
transaction {

	prepare(acct: AuthAccount) {
        // Borrow a reference to the stored, private minter resource
        let vaultRef = acct.borrow<&ExampleToken.Vault>(from: /storage/exampleTokenVault)
            ?? panic("Could not borrow owner's vault reference")

        // withdraw tokens from the buyers Vault
        let v <- vaultRef.withdraw(amount: 10.0)

        let recipientReceiver = getAccount(0x120e725050340cab).getCapability(/public/exampleTokenReceiver).borrow<&{FungibleToken.Receiver}>()!

        recipientReceiver.deposit(from: <-v)
	}
}

