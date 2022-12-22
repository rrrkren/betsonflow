import FungibleToken from 0x9a0766d93b6608b7
import SportOracle from 0x42880022fd60a371
import FTEscrow from 0x56de6f6221fee904

access(all) contract BetExchange {

   pub event BetRedeemed(betSlipID: UInt64, wonAmount: UFix64);


   pub resource interface PublicBetSlip {
    pub fun GetBetSlipInfo(): BetSlipInfo
   }

  pub struct BetSlipInfo {
    pub let betSlipID: UInt64
    pub let WinMultiplier: UFix64
    pub let WinOutcome: SportOracle.FixtureOutcome
    pub let fixtureID: UInt64
    pub let oracleAddress: Address
    pub let inverseOutcome: Bool
    pub let won: Bool?

    init(betSlipID: UInt64, WinMultiplier: UFix64, WinOutcome: SportOracle.FixtureOutcome, fixtureID: UInt64, oracleAddress: Address, inverseOutcome: Bool, won: Bool?) {
      self.betSlipID = betSlipID
      self.WinMultiplier = WinMultiplier
      self.WinOutcome = WinOutcome
      self.fixtureID = fixtureID
      self.oracleAddress = oracleAddress
      self.inverseOutcome = inverseOutcome
      self.won = won
    }
  }

  pub resource BetSlip: PublicBetSlip {
    pub let EscrowAccessToken: @FTEscrow.EscrowAccessToken
    pub let WinMultiplier: UFix64
    pub let WinOutcome: SportOracle.FixtureOutcome
    pub let fixtureID: UInt64
    pub let oracleAddress: Address
    pub let inverseOutcome: Bool
    pub var won: Bool?

    pub var str_extension: {String:String}
    pub var int_extension: {String:UInt64}

    pub fun GetBetSlipInfo(): BetSlipInfo {
        return BetSlipInfo(betSlipID: self.uuid, WinMultiplier: self.WinMultiplier, WinOutcome: self.WinOutcome, fixtureID: self.fixtureID, oracleAddress: self.oracleAddress, inverseOutcome: self.inverseOutcome, won: self.won)
    }

    pub fun HasWon(): Bool {
       let oracle = getAccount(self.oracleAddress)
       let fixtureCollectionRef = oracle.getCapability(/public/SportOracleFixtureCollection).borrow<&AnyResource{SportOracle.PublicFixtureCollection}>() ?? panic("could not borrow collection")
       let fixture = fixtureCollectionRef.GetFixture(id: self.fixtureID) ?? panic ("fixture does not exist")

       if fixture.outcome == nil {
           panic("fixture outcome not set")
       }

       if (fixture.outcome! == self.WinOutcome) && !self.inverseOutcome {
             return true
       }
       if (fixture.outcome! != self.WinOutcome) && self.inverseOutcome {
           return true
       }

       return false

    }

    pub fun SettleBet(): @FungibleToken.Vault? {

        self.won = self.HasWon()

        if self.won! {
            let escrowCollection = self.EscrowAccessToken.GetEscrowCollection()

            let escrowAgreement <- escrowCollection.withdrawEscrowAgreementWithToken(accessToken: &self.EscrowAccessToken as &FTEscrow.EscrowAccessToken)
            let escrowVault <- escrowAgreement.redeem(accessToken:  &self.EscrowAccessToken as &FTEscrow.EscrowAccessToken)
            destroy escrowAgreement

            let totalAmount = escrowVault.balance

            emit BetRedeemed(betSlipID: self.uuid, wonAmount: totalAmount)
            return <- escrowVault
        }

        return nil
    }

    init(escrowAccessToken: @FTEscrow.EscrowAccessToken, winMultiplier: UFix64, winOutcome: SportOracle.FixtureOutcome, fixtureID: UInt64, oracleAddress: Address, inverseOutcome: Bool) {
        pre {
            winMultiplier > 0.0: "Win multiplier must be greater than 0"
        }

        self.EscrowAccessToken <- escrowAccessToken
        self.WinMultiplier = winMultiplier
        self.WinOutcome = winOutcome
        self.fixtureID = fixtureID
        self.oracleAddress = oracleAddress
        self.inverseOutcome = inverseOutcome
        self.won = nil
        self.int_extension = {}
        self.str_extension = {}
    }

    destroy() {
      destroy self.EscrowAccessToken
    }
  }

  pub resource BetSlipCollection: PublicBetSlipCollection {
    pub let betSlips: @{UInt64: BetSlip}

    pub fun depositBetSlip(betSlip: @BetSlip) {
        self.betSlips[betSlip.uuid] <-! betSlip
    }

    pub fun withdrawBetSlip(id: UInt64): @BetSlip {
        return <- self.betSlips.remove(key: id)!
    }

    pub fun borrowBetSlip(id: UInt64): &AnyResource{PublicBetSlip} {
        let betSlip <- self.betSlips.remove(key: id)!

        let res = &betSlip as &BetSlip

        self.betSlips[id] <-! betSlip

        return res
    }

    pub fun getBetSlipIDs(): [UInt64] {
        return self.betSlips.keys
    }

    init() {
      self.betSlips <- {}
    }
    destroy() {
      destroy self.betSlips
    }
  }

  pub fun CreateBetSlipCollection(): @BetSlipCollection {
    return <- create BetSlipCollection()
  }

  pub resource interface PublicBetSlipCollection {
    pub fun depositBetSlip(betSlip: @BetSlip)
    pub fun getBetSlipIDs(): [UInt64]
    pub fun borrowBetSlip(id: UInt64): &AnyResource{PublicBetSlip}
  }


  // betoffer allows betslip to be created

  pub resource interface PublicBetOffer {
    pub fun acceptOffer(stake: @FungibleToken.Vault, outcome: SportOracle.FixtureOutcome): @BetSlip
  }

  pub resource BetOffer: PublicBetOffer {
  // you can bet for this outcome, if the outcome is true, you get the payout, otherwise you lose your bet

  // FTProvider is where the source of funds come from for the layer
    access(self) let FTProvider: Capability<&{FungibleToken.Provider}>

  // The bet stakes are held in this escrow
    access(self) let EscrowAddress: Address

  // When the offer is accepted, the layer's bet slip is deposited here
    access(self) let LayerBetSlipCollection: Capability<&{PublicBetSlipCollection}>

    pub var WinMultiplier: UFix64

    access(self) let WinOutcome: SportOracle.FixtureOutcome

    pub let fixtureID: UInt64
    pub let oracleAddress: Address

    pub var maxExposure: UFix64

    pub fun updateWinMultiplier(newMultiplier: UFix64) {
        pre {
            newMultiplier > 0.0: "Win multiplier must be greater than 0"
        }
        self.WinMultiplier = newMultiplier
    }

    pub fun acceptOffer(stake: @FungibleToken.Vault, outcome: SportOracle.FixtureOutcome): @BetSlip {
        pre {
            outcome != SportOracle.FixtureOutcome.CANCELLED: "Outcome must be decided"
            outcome != SportOracle.FixtureOutcome.EXT: "EXT NOT SUPPORTED"
        }

        let stakeBalance = stake.balance

        // check if layer has sufficient balance to back the bet
        let totalPayout = stakeBalance * self.WinMultiplier

        let layerStake = totalPayout - stakeBalance

        if layerStake > self.maxExposure {
            panic("layer cannot afford to back this bet")
        }

        // withdraw stake from layer
        stake.deposit(from: <- self.FTProvider.borrow()!.withdraw(amount: layerStake))

        self.maxExposure = self.maxExposure - layerStake

        // create escrow
        let escrowAgreement <- FTEscrow.createEscrow(vault: <-stake)
        // create betslips
        let bettorAccessToken <- escrowAgreement.createAccessToken(escrowAddress: self.EscrowAddress)
        let bettorSlip <- create BetSlip(escrowAccessToken: <-bettorAccessToken, winMultiplier: self.WinMultiplier, winOutcome: self.WinOutcome, fixtureID: self.fixtureID, oracleAddress: self.oracleAddress, inverseOutcome: false)
        let layerAccessToken <- escrowAgreement.createAccessToken(escrowAddress: self.EscrowAddress)
        let escrowCollection = layerAccessToken.GetEscrowCollection()
        let layerSlip <- create BetSlip(escrowAccessToken: <-layerAccessToken, winMultiplier: self.WinMultiplier, winOutcome: self.WinOutcome, fixtureID: self.fixtureID, oracleAddress: self.oracleAddress, inverseOutcome: true)


        escrowCollection.depositEscrowAgreement(escrowAgreement: <-escrowAgreement)
        self.LayerBetSlipCollection.borrow()!.depositBetSlip(betSlip: <- layerSlip)

        return <- bettorSlip
    }

    init(FTProvider: Capability<&{FungibleToken.Provider}>, EscrowAddress: Address, LayerBetSlipCollection: Capability<&{PublicBetSlipCollection}>, WinMultiplier: UFix64, WinOutcome: SportOracle.FixtureOutcome, fixtureID: UInt64, oracleAddress: Address, maxExposure: UFix64) {
        pre {
            WinMultiplier > 0.0: "Win multiplier must be greater than 0"
        }

        self.FTProvider = FTProvider
        self.EscrowAddress = EscrowAddress
        self.LayerBetSlipCollection = LayerBetSlipCollection
        self.WinMultiplier = WinMultiplier
        self.WinOutcome = WinOutcome
        self.fixtureID = fixtureID
        self.oracleAddress = oracleAddress
        self.maxExposure = maxExposure
    }
  }

  pub fun createBetOffer(FTProvider: Capability<&{FungibleToken.Provider}>, EscrowAddress: Address, LayerBetSlipCollection: Capability<&{PublicBetSlipCollection}>, WinMultiplier: UFix64, WinOutcome: SportOracle.FixtureOutcome, fixtureID: UInt64, oracleAddress: Address, maxExposure: UFix64): @BetOffer {
    return <- create BetOffer(FTProvider: FTProvider, EscrowAddress: EscrowAddress, LayerBetSlipCollection: LayerBetSlipCollection, WinMultiplier: WinMultiplier, WinOutcome: WinOutcome, fixtureID: fixtureID, oracleAddress: oracleAddress, maxExposure: maxExposure)
  }

  pub resource interface PublicBetOfferCollection {
    pub fun getBetOffer(id: UInt64): &AnyResource{PublicBetOffer}
    pub fun getBetOfferIDs(): [UInt64]
    pub fun getBetOfferByFixtureID(fixtureID: UInt64, oracleAddress: Address): &AnyResource{PublicBetOffer}
  }

  pub resource BetOfferCollection: PublicBetOfferCollection {
      pub let betOffers: @{UInt64: BetOffer}
      pub let oracleFixtureOffers: {Address: {UInt64: UInt64}}

    // update Offer
    // add Offer
    pub fun addBetOffer(betOffer: @BetOffer) {
        self.betOffers[betOffer.uuid] <-! betOffer
    }
    pub fun getBetOffer(id: UInt64): &AnyResource{PublicBetOffer} {
        let ref = &self.betOffers[id] as &BetOffer?
        return ref!
    }
    pub fun getBetOfferIDs(): [UInt64] {
        return self.betOffers.keys
    }
    pub fun getBetOfferByFixtureID(fixtureID: UInt64, oracleAddress: Address): &AnyResource{PublicBetOffer} {
        return self.getBetOffer(id: self.oracleFixtureOffers[oracleAddress]![fixtureID]!)
    }
    pub fun withdrawBetOffer(id: UInt64): @BetOffer {
        return <- self.betOffers.remove(key: id)!
    }

    init(){
      self.betOffers <- {}
      self.oracleFixtureOffers = {}
    }

    destroy() {
      destroy self.betOffers
      }
  }

  pub fun CreateBetofferCollection(): @BetOfferCollection {
    return <- create BetOfferCollection()
  }

}
 