import RealmSwift

/// Responsible for creating game data objects and saving results
class GameManager {

    private let realm: Realm
    private let notifier: GameCenterNotifier
    private var currentLevel: Level?

    /// Initialize manager with realm instance, useful for testing
    ///
    /// - Parameter realm: realm instance
    init(realm: Realm) {
        self.realm = realm
        self.notifier = GameCenterNotifier(realm: realm)
    }

    /// Creates game data with the indicated difficulty
    ///
    /// - Parameter difficulty: difficulty of the game
    /// - Returns: game data containing relevant phrases and difficulty
    func createGame(fromLevel level: Level) -> GameData {
        currentLevel = level
        let gameData = GameData(name: level.name,
                                phrases: level.phrases,
                                difficulty: level.difficulty)
        return gameData
    }

    func saveGame(result: GameData) {
        guard let currentLevel = currentLevel else {
            assertionFailure("No game ongoing, failed to save")
            return
        }
        // convert game data to LevelResult
        let finalResult = LevelResult(level: currentLevel, gameData: result)
        try? realm.write {
            realm.add(finalResult)
        }
        self.currentLevel = nil
    }

}
