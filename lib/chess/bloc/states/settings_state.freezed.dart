part of 'settings_state.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SettingsState {
  Player get whitePlayer => throw _privateConstructorUsedError;
  Player get blackPlayer => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsStateCopyWith<SettingsState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) then) = _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call({Player whitePlayer, Player blackPlayer, int difficulty});
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState> implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? whitePlayer = null,
    Object? blackPlayer = null,
    Object? difficulty = null,
  }) {
    return _then(_value.copyWith(
      whitePlayer: null == whitePlayer
          ? _value.whitePlayer
          : whitePlayer // ignore: cast_nullable_to_non_nullable
              as Player,
      blackPlayer: null == blackPlayer
          ? _value.blackPlayer
          : blackPlayer // ignore: cast_nullable_to_non_nullable
              as Player,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$$_SettingsStateCopyWith(_$_SettingsState value, $Res Function(_$_SettingsState) then) = __$$_SettingsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player whitePlayer, Player blackPlayer, int difficulty});
}

/// @nodoc
class __$$_SettingsStateCopyWithImpl<$Res> extends _$SettingsStateCopyWithImpl<$Res, _$_SettingsState> implements _$$_SettingsStateCopyWith<$Res> {
  __$$_SettingsStateCopyWithImpl(_$_SettingsState _value, $Res Function(_$_SettingsState) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? whitePlayer = null,
    Object? blackPlayer = null,
    Object? difficulty = null,
  }) {
    return _then(_$_SettingsState(
      whitePlayer: null == whitePlayer
          ? _value.whitePlayer
          : whitePlayer // ignore: cast_nullable_to_non_nullable
              as Player,
      blackPlayer: null == blackPlayer
          ? _value.blackPlayer
          : blackPlayer // ignore: cast_nullable_to_non_nullable
              as Player,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_SettingsState extends _SettingsState {
  const _$_SettingsState({required this.whitePlayer, required this.blackPlayer, required this.difficulty}) : super._();

  @override
  final Player whitePlayer;
  @override
  final Player blackPlayer;
  @override
  final int difficulty;

  @override
  String toString() {
    return 'SettingsState(whitePlayer: $whitePlayer, blackPlayer: $blackPlayer, difficulty: $difficulty)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _$_SettingsState && (identical(other.whitePlayer, whitePlayer) || other.whitePlayer == whitePlayer) && (identical(other.blackPlayer, blackPlayer) || other.blackPlayer == blackPlayer) && (identical(other.difficulty, difficulty) || other.difficulty == difficulty));
  }

  @override
  int get hashCode => Object.hash(runtimeType, whitePlayer, blackPlayer, difficulty);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingsStateCopyWith<_$_SettingsState> get copyWith => __$$_SettingsStateCopyWithImpl<_$_SettingsState>(this, _$identity);
}

abstract class _SettingsState extends SettingsState {
  const factory _SettingsState({required final Player whitePlayer, required final Player blackPlayer, required final int difficulty}) = _$_SettingsState;
  const _SettingsState._() : super._();

  @override
  Player get whitePlayer;
  @override
  Player get blackPlayer;
  @override
  int get difficulty;
  @override
  @JsonKey(ignore: true)
  _$$_SettingsStateCopyWith<_$_SettingsState> get copyWith => throw _privateConstructorUsedError;
}
