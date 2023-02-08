/// Facade for all operations with chess engine
/// only here we interact with it
abstract class AIManager {
  void initEngine();
  void disposeEngine();

  String getCurrentState();
  void setCommand(String uciCommand);

  void registerOutputCallback();
}

enum AIEngines {
  stockFish,
}

/// stock-fish manager
class StockFishAIManager implements AIManager {
  @override
  void disposeEngine() {
    // TODO: implement disposeEngine
  }

  @override
  String getCurrentState() {
    // TODO: implement getCurrentState
    throw UnimplementedError();
  }

  @override
  void initEngine() {
    // TODO: implement initEngine
  }

  @override
  void registerOutputCallback() {
    // TODO: implement registerOutputCallback
  }

  @override
  void setCommand(String uciCommand) {
    // TODO: implement setCommand
  }
}

AIManager createAIManager({AIEngines engine = AIEngines.stockFish}) {
  return StockFishAIManager();
}
