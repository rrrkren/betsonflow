access(all) contract SportOracle {

    pub struct Fixture {
        pub let id: UInt64
        pub let sport: SportType
        pub let league: String
        pub let home_team: String
        pub let away_team: String
        pub var start_time_utc: UInt64
        pub(set) var outcome: FixtureOutcome?
        pub var str_extension: {String:String}
        pub var int_extension: {String:UInt64}

        pub init(id: UInt64, sport: SportType, league: String, home_team: String, away_team: String, start_time_utc: UInt64) {
            self.id = id
            self.sport = sport
            self.league = league
            self.home_team = home_team
            self.away_team = away_team
            self.start_time_utc = start_time_utc
            self.outcome = nil
            self.str_extension = {}
            self.int_extension = {}
        }
    }

    pub enum FixtureOutcome: UInt8 {
        pub case HOME_WIN
        pub case AWAY_WIN
        pub case CANCELLED
        pub case DRAW
        pub case EXT // use extension
    }

    pub enum SportType: UInt8 {
        pub case BASKETBALL
        pub case AMERICAN_FOOTBALL
        pub case EXT // use extension
    }

    pub resource interface PublicFixtureCollection {
        pub fun GetFixtureIDs(): [UInt64]
        pub fun GetFixture(id: UInt64): Fixture?
    }

    pub resource FixtureCollection: PublicFixtureCollection {
        pub let fixtures: {UInt64: Fixture}
        pub let fixture_ids: [UInt64]
        pub let str_extension: {String:String}
        pub let int_extension: {String:UInt64}
        pub let int_array_extension: {String:[UInt64]}

        pub fun GetFixtureIDs(): [UInt64] {
            return self.fixture_ids
        }    

        pub fun GetFixture(id: UInt64): Fixture? {
            return self.fixtures[id]
        }

        pub fun UpdateFixture(f: Fixture) {
            if self.fixtures[f.id] == nil {
                panic("fixture with ID does not exist")
            }
            self.fixtures[f.id] = f
        }

        pub fun AddFixture(f: Fixture) {
            if self.fixtures[f.id] != nil {
                panic("fixture with ID already exists")
            }

            self.fixture_ids.append(f.id)
            self.fixtures[f.id] = f
        }

        pub init() {
            self.fixtures = {}
            self.fixture_ids = []
            self.str_extension = {}
            self.int_extension = {}
            self.int_array_extension = {}
        }
    }

    pub fun NewFixtureCollection(): @FixtureCollection {
        return <- create FixtureCollection()
    }


    init() {
    }
}
