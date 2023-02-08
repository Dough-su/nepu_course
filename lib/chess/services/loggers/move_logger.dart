import 'package:muse_nepu_course/chess/models/cell.dart';
import 'package:muse_nepu_course/chess/services/loggers/i_logger.dart';

class MoveLogger implements ILogger<Cell> {
  final List<Cell> _movements = [];

  @override
  add(note) {
    _movements.add(note);
  }

  @override
  clear() {
    _movements.clear();
  }

  @override
  remove(note) {
    _movements.remove(note);
  }

  @override
  List<Cell> getAll() {
    return _movements;
  }
}

MoveLogger createMoveLogger() {
  return MoveLogger();
}
