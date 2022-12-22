import FungibleToken from 0x9a0766d93b6608b7

access(all) contract FTEscrow {
    pub resource EscrowAccessToken {
        pub let EscrowAddress: Address
        pub let agreementID: UInt64

        pub fun GetEscrowCollection(): &AnyResource{PublicEscrowCollection} {
        let escrowAccount = getAccount(self.EscrowAddress)

        return escrowAccount.getCapability(/public/escrowCollection).borrow<&{FTEscrow.PublicEscrowCollection}>()!

        }

        pub init(agreementID: UInt64, escrowAddress: Address) {
            self.agreementID = agreementID
            self.EscrowAddress = escrowAddress
        }
    }

    pub resource EscrowAgreement {
        access(self) var tokenVault: @FungibleToken.Vault?

        pub fun createAccessToken(escrowAddress: Address): @EscrowAccessToken {
            return <-create EscrowAccessToken(agreementID: self.uuid, escrowAddress: escrowAddress)
        }

        pub fun redeem(accessToken: &EscrowAccessToken): @FungibleToken.Vault {
            if accessToken.agreementID != self.uuid {
                panic("invalid token")
            }
            let vault <- self.tokenVault <- nil
            return <- vault!
        }

        pub init(vault: @FungibleToken.Vault) {
            self.tokenVault <- vault
        }

        pub destroy() {
            destroy self.tokenVault
        }
    }

    pub resource interface PublicEscrowCollection {
        pub fun depositEscrowAgreement(escrowAgreement: @EscrowAgreement)
        pub fun withdrawEscrowAgreementWithToken(accessToken: &EscrowAccessToken): @EscrowAgreement
    }

    pub fun createEscrow(vault: @FungibleToken.Vault): @EscrowAgreement {
        return <-create EscrowAgreement(vault: <-vault)
    }

    pub resource EscrowCollection: PublicEscrowCollection {

        access(self) let escrowAgreements: @{UInt64: EscrowAgreement}

        pub fun depositEscrowAgreement(escrowAgreement: @EscrowAgreement) {
            self.escrowAgreements[escrowAgreement.uuid] <-! escrowAgreement
        }

        pub fun withdrawEscrowAgreementWithToken(accessToken: &EscrowAccessToken): @EscrowAgreement {
            let escrowAgreement <- self.escrowAgreements[accessToken.agreementID] <- nil
            return <-escrowAgreement!
        }

        pub fun withdrawEscrowAgreement(agreementID: UInt64): @EscrowAgreement {
            let escrowAgreement <- self.escrowAgreements[agreementID] <- nil
            return <-escrowAgreement!
        }

        pub init() {
            self.escrowAgreements <- {}
        }

        pub destroy() {
            destroy self.escrowAgreements
        }
    }

    pub fun createEscrowCollection(): @EscrowCollection {
        return <-create EscrowCollection()
    }

    pub init() {
        self.account.save(<-create EscrowCollection(), to: /storage/escrowCollection)
        self.account.link<&{PublicEscrowCollection}>(/public/escrowCollection, target: /storage/escrowCollection)
    }
}