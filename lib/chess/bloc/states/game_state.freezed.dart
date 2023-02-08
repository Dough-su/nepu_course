part of 'game_state.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GameState {
  Board get board => throw _privateConstructorUsedError;
  Cell? get selectedCell => throw _privateConstructorUsedError;
  Set<String> get availablePositionsHash => throw _privateConstructorUsedError;
  GameColors get activeColor => throw _privateConstructorUsedError;
  bool get isAIthinking => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameStateCopyWith<GameState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) = _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({Board board, Cell? selectedCell, Set<String> availablePositionsHash, GameColors activeColor, bool isAIthinking});
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState> implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? selectedCell = freezed,
    Object? availablePositionsHash = null,
    Object? activeColor = null,
    Object? isAIthinking = null,
  }) {
    return _then(_value.copyWith(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as Board,
      selectedCell: freezed == selectedCell
          ? _value.selectedCell
          : selectedCell // ignore: cast_nullable_to_non_nullable
              as Cell?,
      availablePositionsHash: null == availablePositionsHash
          ? _value.availablePositionsHash
          : availablePositionsHash // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      activeColor: null == activeColor
          ? _value.activeColor
          : activeColor // ignore: cast_nullable_to_non_nullable
              as GameColors,
      isAIthinking: null == isAIthinking
          ? _value.isAIthinking
          : isAIthinking // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$$_GameStateCopyWith(_$_GameState value, $Res Function(_$_GameState) then) = __$$_GameStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Board board, Cell? selectedCell, Set<String> availablePositionsHash, GameColors activeColor, bool isAIthinking});
}

/// @nodoc
class __$$_GameStateCopyWithImpl<$Res> extends _$GameStateCopyWithImpl<$Res, _$_GameState> implements _$$_GameStateCopyWith<$Res> {
  __$$_GameStateCopyWithImpl(_$_GameState _value, $Res Function(_$_GameState) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? selectedCell = freezed,
    Object? availablePositionsHash = null,
    Object? activeColor = null,
    Object? isAIthinking = null,
  }) {
    return _then(_$_GameState(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as Board,
      selectedCell: freezed == selectedCell
          ? _value.selectedCell
          : selectedCell // ignore: cast_nullable_to_non_nullable
              as Cell?,
      availablePositionsHash: null == availablePositionsHash
          ? _value._availablePositionsHash
          : availablePositionsHash // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      activeColor: null == activeColor
          ? _value.activeColor
          : activeColor // ignore: cast_nullable_to_non_nullable
              as GameColors,
      isAIthinking: null == isAIthinking
          ? _value.isAIthinking
          : isAIthinking // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_GameState extends _GameState {
  const _$_GameState({required this.board, required this.selectedCell, required final Set<String> availablePositionsHash, required this.activeColor, required this.isAIthinking})
      : _availablePositionsHash = availablePositionsHash,
        super._();

  @override
  final Board board;
  @override
  final Cell? selectedCell;
  final Set<String> _availablePositionsHash;
  @override
  Set<String> get availablePositionsHash {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_availablePositionsHash);
  }

  @override
  final GameColors activeColor;
  @override
  final bool isAIthinking;

  @override
  String toString() {
    return 'GameState(board: $board, selectedCell: $selectedCell, availablePositionsHash: $availablePositionsHash, activeColor: $activeColor, isAIthinking: $isAIthinking)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_GameState && (identical(other.board, board) || other.board == board) && (identical(other.selectedCell, selectedCell) || other.selectedCell == selectedCell) && const DeepCollectionEquality().equals(other._availablePositionsHash, _availablePositionsHash) && (identical(other.activeColor, activeColor) || other.activeColor == activeColor) && (identical(other.isAIthinking, isAIthinking) || other.isAIthinking == isAIthinking));
  }

  @override
  int get hashCode => Object.hash(runtimeType, board, selectedCell, const DeepCollectionEquality().hash(_availablePositionsHash), activeColor, isAIthinking);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GameStateCopyWith<_$_GameState> get copyWith => __$$_GameStateCopyWithImpl<_$_GameState>(this, _$identity);
}

abstract class _GameState extends GameState {
  const factory _GameState({required final Board board, required final Cell? selectedCell, required final Set<String> availablePositionsHash, required final GameColors activeColor, required final bool isAIthinking}) = _$_GameState;
  const _GameState._() : super._();

  @override
  Board get board;
  @override
  Cell? get selectedCell;
  @override
  Set<String> get availablePositionsHash;
  @override
  GameColors get activeColor;
  @override
  bool get isAIthinking;
  @override
  @JsonKey(ignore: true)
  _$$_GameStateCopyWith<_$_GameState> get copyWith => throw _privateConstructorUsedError;
}
