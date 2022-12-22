import FungibleToken from 0x01cf0e2f2f715450
import ExampleToken from 0x01cf0e2f2f715450

transaction {

  prepare(acct: AuthAccount) {
		let vaultA <- ExampleToken.createEmptyVault()

		// Store the vault in the account storage
		acct.save<@ExampleToken.Vault>(<-vaultA, to: /storage/exampleTokenVault)

		acct.link<&ExampleToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/exampleTokenReceiver, target: /storage/exampleTokenVault)
        acct.link<&ExampleToken.Vault{FungibleToken.Provider}>(/private/exampleTokenProvider, target: /storage/exampleTokenVault)

  }
}
