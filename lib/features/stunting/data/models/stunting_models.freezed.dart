// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stunting_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StuntingQuestion _$StuntingQuestionFromJson(Map<String, dynamic> json) {
  return _StuntingQuestion.fromJson(json);
}

/// @nodoc
mixin _$StuntingQuestion {
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  List<StuntingOption>? get options => throw _privateConstructorUsedError;
  double? get min => throw _privateConstructorUsedError;
  double? get max => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;

  /// Serializes this StuntingQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StuntingQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StuntingQuestionCopyWith<StuntingQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StuntingQuestionCopyWith<$Res> {
  factory $StuntingQuestionCopyWith(
          StuntingQuestion value, $Res Function(StuntingQuestion) then) =
      _$StuntingQuestionCopyWithImpl<$Res, StuntingQuestion>;
  @useResult
  $Res call(
      {String key,
      String label,
      String type,
      bool required,
      List<StuntingOption>? options,
      double? min,
      double? max,
      String? unit});
}

/// @nodoc
class _$StuntingQuestionCopyWithImpl<$Res, $Val extends StuntingQuestion>
    implements $StuntingQuestionCopyWith<$Res> {
  _$StuntingQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StuntingQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? type = null,
    Object? required = null,
    Object? options = freezed,
    Object? min = freezed,
    Object? max = freezed,
    Object? unit = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<StuntingOption>?,
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double?,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StuntingQuestionImplCopyWith<$Res>
    implements $StuntingQuestionCopyWith<$Res> {
  factory _$$StuntingQuestionImplCopyWith(_$StuntingQuestionImpl value,
          $Res Function(_$StuntingQuestionImpl) then) =
      __$$StuntingQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String label,
      String type,
      bool required,
      List<StuntingOption>? options,
      double? min,
      double? max,
      String? unit});
}

/// @nodoc
class __$$StuntingQuestionImplCopyWithImpl<$Res>
    extends _$StuntingQuestionCopyWithImpl<$Res, _$StuntingQuestionImpl>
    implements _$$StuntingQuestionImplCopyWith<$Res> {
  __$$StuntingQuestionImplCopyWithImpl(_$StuntingQuestionImpl _value,
      $Res Function(_$StuntingQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of StuntingQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? type = null,
    Object? required = null,
    Object? options = freezed,
    Object? min = freezed,
    Object? max = freezed,
    Object? unit = freezed,
  }) {
    return _then(_$StuntingQuestionImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<StuntingOption>?,
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double?,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StuntingQuestionImpl implements _StuntingQuestion {
  const _$StuntingQuestionImpl(
      {required this.key,
      required this.label,
      required this.type,
      required this.required,
      final List<StuntingOption>? options,
      this.min,
      this.max,
      this.unit})
      : _options = options;

  factory _$StuntingQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StuntingQuestionImplFromJson(json);

  @override
  final String key;
  @override
  final String label;
  @override
  final String type;
  @override
  final bool required;
  final List<StuntingOption>? _options;
  @override
  List<StuntingOption>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? min;
  @override
  final double? max;
  @override
  final String? unit;

  @override
  String toString() {
    return 'StuntingQuestion(key: $key, label: $label, type: $type, required: $required, options: $options, min: $min, max: $max, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StuntingQuestionImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.required, required) ||
                other.required == required) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, label, type, required,
      const DeepCollectionEquality().hash(_options), min, max, unit);

  /// Create a copy of StuntingQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StuntingQuestionImplCopyWith<_$StuntingQuestionImpl> get copyWith =>
      __$$StuntingQuestionImplCopyWithImpl<_$StuntingQuestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StuntingQuestionImplToJson(
      this,
    );
  }
}

abstract class _StuntingQuestion implements StuntingQuestion {
  const factory _StuntingQuestion(
      {required final String key,
      required final String label,
      required final String type,
      required final bool required,
      final List<StuntingOption>? options,
      final double? min,
      final double? max,
      final String? unit}) = _$StuntingQuestionImpl;

  factory _StuntingQuestion.fromJson(Map<String, dynamic> json) =
      _$StuntingQuestionImpl.fromJson;

  @override
  String get key;
  @override
  String get label;
  @override
  String get type;
  @override
  bool get required;
  @override
  List<StuntingOption>? get options;
  @override
  double? get min;
  @override
  double? get max;
  @override
  String? get unit;

  /// Create a copy of StuntingQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StuntingQuestionImplCopyWith<_$StuntingQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StuntingOption _$StuntingOptionFromJson(Map<String, dynamic> json) {
  return _StuntingOption.fromJson(json);
}

/// @nodoc
mixin _$StuntingOption {
  dynamic get value => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  /// Serializes this StuntingOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StuntingOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StuntingOptionCopyWith<StuntingOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StuntingOptionCopyWith<$Res> {
  factory $StuntingOptionCopyWith(
          StuntingOption value, $Res Function(StuntingOption) then) =
      _$StuntingOptionCopyWithImpl<$Res, StuntingOption>;
  @useResult
  $Res call({dynamic value, String label});
}

/// @nodoc
class _$StuntingOptionCopyWithImpl<$Res, $Val extends StuntingOption>
    implements $StuntingOptionCopyWith<$Res> {
  _$StuntingOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StuntingOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StuntingOptionImplCopyWith<$Res>
    implements $StuntingOptionCopyWith<$Res> {
  factory _$$StuntingOptionImplCopyWith(_$StuntingOptionImpl value,
          $Res Function(_$StuntingOptionImpl) then) =
      __$$StuntingOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({dynamic value, String label});
}

/// @nodoc
class __$$StuntingOptionImplCopyWithImpl<$Res>
    extends _$StuntingOptionCopyWithImpl<$Res, _$StuntingOptionImpl>
    implements _$$StuntingOptionImplCopyWith<$Res> {
  __$$StuntingOptionImplCopyWithImpl(
      _$StuntingOptionImpl _value, $Res Function(_$StuntingOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of StuntingOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
    Object? label = null,
  }) {
    return _then(_$StuntingOptionImpl(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StuntingOptionImpl implements _StuntingOption {
  const _$StuntingOptionImpl({required this.value, required this.label});

  factory _$StuntingOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StuntingOptionImplFromJson(json);

  @override
  final dynamic value;
  @override
  final String label;

  @override
  String toString() {
    return 'StuntingOption(value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StuntingOptionImpl &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(value), label);

  /// Create a copy of StuntingOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StuntingOptionImplCopyWith<_$StuntingOptionImpl> get copyWith =>
      __$$StuntingOptionImplCopyWithImpl<_$StuntingOptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StuntingOptionImplToJson(
      this,
    );
  }
}

abstract class _StuntingOption implements StuntingOption {
  const factory _StuntingOption(
      {required final dynamic value,
      required final String label}) = _$StuntingOptionImpl;

  factory _StuntingOption.fromJson(Map<String, dynamic> json) =
      _$StuntingOptionImpl.fromJson;

  @override
  dynamic get value;
  @override
  String get label;

  /// Create a copy of StuntingOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StuntingOptionImplCopyWith<_$StuntingOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShapFactor _$ShapFactorFromJson(Map<String, dynamic> json) {
  return _ShapFactor.fromJson(json);
}

/// @nodoc
mixin _$ShapFactor {
  String get feature => throw _privateConstructorUsedError;
  String get impact => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this ShapFactor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShapFactor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShapFactorCopyWith<ShapFactor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShapFactorCopyWith<$Res> {
  factory $ShapFactorCopyWith(
          ShapFactor value, $Res Function(ShapFactor) then) =
      _$ShapFactorCopyWithImpl<$Res, ShapFactor>;
  @useResult
  $Res call({String feature, String impact, double value, String? message});
}

/// @nodoc
class _$ShapFactorCopyWithImpl<$Res, $Val extends ShapFactor>
    implements $ShapFactorCopyWith<$Res> {
  _$ShapFactorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShapFactor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feature = null,
    Object? impact = null,
    Object? value = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      feature: null == feature
          ? _value.feature
          : feature // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShapFactorImplCopyWith<$Res>
    implements $ShapFactorCopyWith<$Res> {
  factory _$$ShapFactorImplCopyWith(
          _$ShapFactorImpl value, $Res Function(_$ShapFactorImpl) then) =
      __$$ShapFactorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String feature, String impact, double value, String? message});
}

/// @nodoc
class __$$ShapFactorImplCopyWithImpl<$Res>
    extends _$ShapFactorCopyWithImpl<$Res, _$ShapFactorImpl>
    implements _$$ShapFactorImplCopyWith<$Res> {
  __$$ShapFactorImplCopyWithImpl(
      _$ShapFactorImpl _value, $Res Function(_$ShapFactorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShapFactor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feature = null,
    Object? impact = null,
    Object? value = null,
    Object? message = freezed,
  }) {
    return _then(_$ShapFactorImpl(
      feature: null == feature
          ? _value.feature
          : feature // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShapFactorImpl implements _ShapFactor {
  const _$ShapFactorImpl(
      {required this.feature,
      required this.impact,
      required this.value,
      this.message});

  factory _$ShapFactorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShapFactorImplFromJson(json);

  @override
  final String feature;
  @override
  final String impact;
  @override
  final double value;
  @override
  final String? message;

  @override
  String toString() {
    return 'ShapFactor(feature: $feature, impact: $impact, value: $value, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShapFactorImpl &&
            (identical(other.feature, feature) || other.feature == feature) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, feature, impact, value, message);

  /// Create a copy of ShapFactor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShapFactorImplCopyWith<_$ShapFactorImpl> get copyWith =>
      __$$ShapFactorImplCopyWithImpl<_$ShapFactorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShapFactorImplToJson(
      this,
    );
  }
}

abstract class _ShapFactor implements ShapFactor {
  const factory _ShapFactor(
      {required final String feature,
      required final String impact,
      required final double value,
      final String? message}) = _$ShapFactorImpl;

  factory _ShapFactor.fromJson(Map<String, dynamic> json) =
      _$ShapFactorImpl.fromJson;

  @override
  String get feature;
  @override
  String get impact;
  @override
  double get value;
  @override
  String? get message;

  /// Create a copy of ShapFactor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShapFactorImplCopyWith<_$ShapFactorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShapExplanation _$ShapExplanationFromJson(Map<String, dynamic> json) {
  return _ShapExplanation.fromJson(json);
}

/// @nodoc
mixin _$ShapExplanation {
  String get method => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_factors')
  List<ShapFactor> get topFactors => throw _privateConstructorUsedError;

  /// Serializes this ShapExplanation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShapExplanation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShapExplanationCopyWith<ShapExplanation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShapExplanationCopyWith<$Res> {
  factory $ShapExplanationCopyWith(
          ShapExplanation value, $Res Function(ShapExplanation) then) =
      _$ShapExplanationCopyWithImpl<$Res, ShapExplanation>;
  @useResult
  $Res call(
      {String method,
      @JsonKey(name: 'top_factors') List<ShapFactor> topFactors});
}

/// @nodoc
class _$ShapExplanationCopyWithImpl<$Res, $Val extends ShapExplanation>
    implements $ShapExplanationCopyWith<$Res> {
  _$ShapExplanationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShapExplanation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? topFactors = null,
  }) {
    return _then(_value.copyWith(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      topFactors: null == topFactors
          ? _value.topFactors
          : topFactors // ignore: cast_nullable_to_non_nullable
              as List<ShapFactor>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShapExplanationImplCopyWith<$Res>
    implements $ShapExplanationCopyWith<$Res> {
  factory _$$ShapExplanationImplCopyWith(_$ShapExplanationImpl value,
          $Res Function(_$ShapExplanationImpl) then) =
      __$$ShapExplanationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String method,
      @JsonKey(name: 'top_factors') List<ShapFactor> topFactors});
}

/// @nodoc
class __$$ShapExplanationImplCopyWithImpl<$Res>
    extends _$ShapExplanationCopyWithImpl<$Res, _$ShapExplanationImpl>
    implements _$$ShapExplanationImplCopyWith<$Res> {
  __$$ShapExplanationImplCopyWithImpl(
      _$ShapExplanationImpl _value, $Res Function(_$ShapExplanationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShapExplanation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? topFactors = null,
  }) {
    return _then(_$ShapExplanationImpl(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      topFactors: null == topFactors
          ? _value._topFactors
          : topFactors // ignore: cast_nullable_to_non_nullable
              as List<ShapFactor>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShapExplanationImpl implements _ShapExplanation {
  const _$ShapExplanationImpl(
      {required this.method,
      @JsonKey(name: 'top_factors') required final List<ShapFactor> topFactors})
      : _topFactors = topFactors;

  factory _$ShapExplanationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShapExplanationImplFromJson(json);

  @override
  final String method;
  final List<ShapFactor> _topFactors;
  @override
  @JsonKey(name: 'top_factors')
  List<ShapFactor> get topFactors {
    if (_topFactors is EqualUnmodifiableListView) return _topFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topFactors);
  }

  @override
  String toString() {
    return 'ShapExplanation(method: $method, topFactors: $topFactors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShapExplanationImpl &&
            (identical(other.method, method) || other.method == method) &&
            const DeepCollectionEquality()
                .equals(other._topFactors, _topFactors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, method, const DeepCollectionEquality().hash(_topFactors));

  /// Create a copy of ShapExplanation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShapExplanationImplCopyWith<_$ShapExplanationImpl> get copyWith =>
      __$$ShapExplanationImplCopyWithImpl<_$ShapExplanationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShapExplanationImplToJson(
      this,
    );
  }
}

abstract class _ShapExplanation implements ShapExplanation {
  const factory _ShapExplanation(
      {required final String method,
      @JsonKey(name: 'top_factors')
      required final List<ShapFactor> topFactors}) = _$ShapExplanationImpl;

  factory _ShapExplanation.fromJson(Map<String, dynamic> json) =
      _$ShapExplanationImpl.fromJson;

  @override
  String get method;
  @override
  @JsonKey(name: 'top_factors')
  List<ShapFactor> get topFactors;

  /// Create a copy of ShapExplanation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShapExplanationImplCopyWith<_$ShapExplanationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PredictionResult _$PredictionResultFromJson(Map<String, dynamic> json) {
  return _PredictionResult.fromJson(json);
}

/// @nodoc
mixin _$PredictionResult {
  @JsonKey(name: 'predictionId')
  int get predictionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'riskLabel')
  String get riskLabel => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  int get riskLevel => throw _privateConstructorUsedError;
  String get recommendation => throw _privateConstructorUsedError;
  ShapExplanation? get explanation => throw _privateConstructorUsedError;

  /// Serializes this PredictionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictionResultCopyWith<PredictionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictionResultCopyWith<$Res> {
  factory $PredictionResultCopyWith(
          PredictionResult value, $Res Function(PredictionResult) then) =
      _$PredictionResultCopyWithImpl<$Res, PredictionResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'predictionId') int predictionId,
      @JsonKey(name: 'riskLabel') String riskLabel,
      double score,
      int riskLevel,
      String recommendation,
      ShapExplanation? explanation});

  $ShapExplanationCopyWith<$Res>? get explanation;
}

/// @nodoc
class _$PredictionResultCopyWithImpl<$Res, $Val extends PredictionResult>
    implements $PredictionResultCopyWith<$Res> {
  _$PredictionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictionId = null,
    Object? riskLabel = null,
    Object? score = null,
    Object? riskLevel = null,
    Object? recommendation = null,
    Object? explanation = freezed,
  }) {
    return _then(_value.copyWith(
      predictionId: null == predictionId
          ? _value.predictionId
          : predictionId // ignore: cast_nullable_to_non_nullable
              as int,
      riskLabel: null == riskLabel
          ? _value.riskLabel
          : riskLabel // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as int,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: freezed == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as ShapExplanation?,
    ) as $Val);
  }

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShapExplanationCopyWith<$Res>? get explanation {
    if (_value.explanation == null) {
      return null;
    }

    return $ShapExplanationCopyWith<$Res>(_value.explanation!, (value) {
      return _then(_value.copyWith(explanation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PredictionResultImplCopyWith<$Res>
    implements $PredictionResultCopyWith<$Res> {
  factory _$$PredictionResultImplCopyWith(_$PredictionResultImpl value,
          $Res Function(_$PredictionResultImpl) then) =
      __$$PredictionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'predictionId') int predictionId,
      @JsonKey(name: 'riskLabel') String riskLabel,
      double score,
      int riskLevel,
      String recommendation,
      ShapExplanation? explanation});

  @override
  $ShapExplanationCopyWith<$Res>? get explanation;
}

/// @nodoc
class __$$PredictionResultImplCopyWithImpl<$Res>
    extends _$PredictionResultCopyWithImpl<$Res, _$PredictionResultImpl>
    implements _$$PredictionResultImplCopyWith<$Res> {
  __$$PredictionResultImplCopyWithImpl(_$PredictionResultImpl _value,
      $Res Function(_$PredictionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictionId = null,
    Object? riskLabel = null,
    Object? score = null,
    Object? riskLevel = null,
    Object? recommendation = null,
    Object? explanation = freezed,
  }) {
    return _then(_$PredictionResultImpl(
      predictionId: null == predictionId
          ? _value.predictionId
          : predictionId // ignore: cast_nullable_to_non_nullable
              as int,
      riskLabel: null == riskLabel
          ? _value.riskLabel
          : riskLabel // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as int,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: freezed == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as ShapExplanation?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictionResultImpl implements _PredictionResult {
  const _$PredictionResultImpl(
      {@JsonKey(name: 'predictionId') required this.predictionId,
      @JsonKey(name: 'riskLabel') required this.riskLabel,
      required this.score,
      required this.riskLevel,
      required this.recommendation,
      this.explanation});

  factory _$PredictionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictionResultImplFromJson(json);

  @override
  @JsonKey(name: 'predictionId')
  final int predictionId;
  @override
  @JsonKey(name: 'riskLabel')
  final String riskLabel;
  @override
  final double score;
  @override
  final int riskLevel;
  @override
  final String recommendation;
  @override
  final ShapExplanation? explanation;

  @override
  String toString() {
    return 'PredictionResult(predictionId: $predictionId, riskLabel: $riskLabel, score: $score, riskLevel: $riskLevel, recommendation: $recommendation, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictionResultImpl &&
            (identical(other.predictionId, predictionId) ||
                other.predictionId == predictionId) &&
            (identical(other.riskLabel, riskLabel) ||
                other.riskLabel == riskLabel) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, predictionId, riskLabel, score,
      riskLevel, recommendation, explanation);

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictionResultImplCopyWith<_$PredictionResultImpl> get copyWith =>
      __$$PredictionResultImplCopyWithImpl<_$PredictionResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictionResultImplToJson(
      this,
    );
  }
}

abstract class _PredictionResult implements PredictionResult {
  const factory _PredictionResult(
      {@JsonKey(name: 'predictionId') required final int predictionId,
      @JsonKey(name: 'riskLabel') required final String riskLabel,
      required final double score,
      required final int riskLevel,
      required final String recommendation,
      final ShapExplanation? explanation}) = _$PredictionResultImpl;

  factory _PredictionResult.fromJson(Map<String, dynamic> json) =
      _$PredictionResultImpl.fromJson;

  @override
  @JsonKey(name: 'predictionId')
  int get predictionId;
  @override
  @JsonKey(name: 'riskLabel')
  String get riskLabel;
  @override
  double get score;
  @override
  int get riskLevel;
  @override
  String get recommendation;
  @override
  ShapExplanation? get explanation;

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictionResultImplCopyWith<_$PredictionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodModel _$FoodModelFromJson(Map<String, dynamic> json) {
  return _FoodModel.fromJson(json);
}

/// @nodoc
mixin _$FoodModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageUrl')
  String? get imageUrl => throw _privateConstructorUsedError;
  double get protein => throw _privateConstructorUsedError;
  double get calories => throw _privateConstructorUsedError;
  double? get fat => throw _privateConstructorUsedError;
  double? get carbohydrates => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this FoodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodModelCopyWith<FoodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodModelCopyWith<$Res> {
  factory $FoodModelCopyWith(FoodModel value, $Res Function(FoodModel) then) =
      _$FoodModelCopyWithImpl<$Res, FoodModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'imageUrl') String? imageUrl,
      double protein,
      double calories,
      double? fat,
      double? carbohydrates,
      String? reason});
}

/// @nodoc
class _$FoodModelCopyWithImpl<$Res, $Val extends FoodModel>
    implements $FoodModelCopyWith<$Res> {
  _$FoodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? protein = null,
    Object? calories = null,
    Object? fat = freezed,
    Object? carbohydrates = freezed,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      fat: freezed == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double?,
      carbohydrates: freezed == carbohydrates
          ? _value.carbohydrates
          : carbohydrates // ignore: cast_nullable_to_non_nullable
              as double?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodModelImplCopyWith<$Res>
    implements $FoodModelCopyWith<$Res> {
  factory _$$FoodModelImplCopyWith(
          _$FoodModelImpl value, $Res Function(_$FoodModelImpl) then) =
      __$$FoodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'imageUrl') String? imageUrl,
      double protein,
      double calories,
      double? fat,
      double? carbohydrates,
      String? reason});
}

/// @nodoc
class __$$FoodModelImplCopyWithImpl<$Res>
    extends _$FoodModelCopyWithImpl<$Res, _$FoodModelImpl>
    implements _$$FoodModelImplCopyWith<$Res> {
  __$$FoodModelImplCopyWithImpl(
      _$FoodModelImpl _value, $Res Function(_$FoodModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? protein = null,
    Object? calories = null,
    Object? fat = freezed,
    Object? carbohydrates = freezed,
    Object? reason = freezed,
  }) {
    return _then(_$FoodModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      fat: freezed == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double?,
      carbohydrates: freezed == carbohydrates
          ? _value.carbohydrates
          : carbohydrates // ignore: cast_nullable_to_non_nullable
              as double?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodModelImpl implements _FoodModel {
  const _$FoodModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'imageUrl') this.imageUrl,
      required this.protein,
      required this.calories,
      this.fat,
      this.carbohydrates,
      this.reason});

  factory _$FoodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @override
  final double protein;
  @override
  final double calories;
  @override
  final double? fat;
  @override
  final double? carbohydrates;
  @override
  final String? reason;

  @override
  String toString() {
    return 'FoodModel(id: $id, name: $name, imageUrl: $imageUrl, protein: $protein, calories: $calories, fat: $fat, carbohydrates: $carbohydrates, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.carbohydrates, carbohydrates) ||
                other.carbohydrates == carbohydrates) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, imageUrl, protein,
      calories, fat, carbohydrates, reason);

  /// Create a copy of FoodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodModelImplCopyWith<_$FoodModelImpl> get copyWith =>
      __$$FoodModelImplCopyWithImpl<_$FoodModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodModelImplToJson(
      this,
    );
  }
}

abstract class _FoodModel implements FoodModel {
  const factory _FoodModel(
      {required final String id,
      required final String name,
      @JsonKey(name: 'imageUrl') final String? imageUrl,
      required final double protein,
      required final double calories,
      final double? fat,
      final double? carbohydrates,
      final String? reason}) = _$FoodModelImpl;

  factory _FoodModel.fromJson(Map<String, dynamic> json) =
      _$FoodModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'imageUrl')
  String? get imageUrl;
  @override
  double get protein;
  @override
  double get calories;
  @override
  double? get fat;
  @override
  double? get carbohydrates;
  @override
  String? get reason;

  /// Create a copy of FoodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodModelImplCopyWith<_$FoodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiSupportModel _$AiSupportModelFromJson(Map<String, dynamic> json) {
  return _AiSupportModel.fromJson(json);
}

/// @nodoc
mixin _$AiSupportModel {
  @JsonKey(name: 'cooking_guide')
  String? get cookingGuide => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutrition_tips')
  String? get nutritionTips => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_plan')
  String? get mealPlan => throw _privateConstructorUsedError;

  /// Serializes this AiSupportModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiSupportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiSupportModelCopyWith<AiSupportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiSupportModelCopyWith<$Res> {
  factory $AiSupportModelCopyWith(
          AiSupportModel value, $Res Function(AiSupportModel) then) =
      _$AiSupportModelCopyWithImpl<$Res, AiSupportModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'cooking_guide') String? cookingGuide,
      @JsonKey(name: 'nutrition_tips') String? nutritionTips,
      @JsonKey(name: 'meal_plan') String? mealPlan});
}

/// @nodoc
class _$AiSupportModelCopyWithImpl<$Res, $Val extends AiSupportModel>
    implements $AiSupportModelCopyWith<$Res> {
  _$AiSupportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiSupportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cookingGuide = freezed,
    Object? nutritionTips = freezed,
    Object? mealPlan = freezed,
  }) {
    return _then(_value.copyWith(
      cookingGuide: freezed == cookingGuide
          ? _value.cookingGuide
          : cookingGuide // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionTips: freezed == nutritionTips
          ? _value.nutritionTips
          : nutritionTips // ignore: cast_nullable_to_non_nullable
              as String?,
      mealPlan: freezed == mealPlan
          ? _value.mealPlan
          : mealPlan // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiSupportModelImplCopyWith<$Res>
    implements $AiSupportModelCopyWith<$Res> {
  factory _$$AiSupportModelImplCopyWith(_$AiSupportModelImpl value,
          $Res Function(_$AiSupportModelImpl) then) =
      __$$AiSupportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'cooking_guide') String? cookingGuide,
      @JsonKey(name: 'nutrition_tips') String? nutritionTips,
      @JsonKey(name: 'meal_plan') String? mealPlan});
}

/// @nodoc
class __$$AiSupportModelImplCopyWithImpl<$Res>
    extends _$AiSupportModelCopyWithImpl<$Res, _$AiSupportModelImpl>
    implements _$$AiSupportModelImplCopyWith<$Res> {
  __$$AiSupportModelImplCopyWithImpl(
      _$AiSupportModelImpl _value, $Res Function(_$AiSupportModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiSupportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cookingGuide = freezed,
    Object? nutritionTips = freezed,
    Object? mealPlan = freezed,
  }) {
    return _then(_$AiSupportModelImpl(
      cookingGuide: freezed == cookingGuide
          ? _value.cookingGuide
          : cookingGuide // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionTips: freezed == nutritionTips
          ? _value.nutritionTips
          : nutritionTips // ignore: cast_nullable_to_non_nullable
              as String?,
      mealPlan: freezed == mealPlan
          ? _value.mealPlan
          : mealPlan // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiSupportModelImpl implements _AiSupportModel {
  const _$AiSupportModelImpl(
      {@JsonKey(name: 'cooking_guide') this.cookingGuide,
      @JsonKey(name: 'nutrition_tips') this.nutritionTips,
      @JsonKey(name: 'meal_plan') this.mealPlan});

  factory _$AiSupportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiSupportModelImplFromJson(json);

  @override
  @JsonKey(name: 'cooking_guide')
  final String? cookingGuide;
  @override
  @JsonKey(name: 'nutrition_tips')
  final String? nutritionTips;
  @override
  @JsonKey(name: 'meal_plan')
  final String? mealPlan;

  @override
  String toString() {
    return 'AiSupportModel(cookingGuide: $cookingGuide, nutritionTips: $nutritionTips, mealPlan: $mealPlan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiSupportModelImpl &&
            (identical(other.cookingGuide, cookingGuide) ||
                other.cookingGuide == cookingGuide) &&
            (identical(other.nutritionTips, nutritionTips) ||
                other.nutritionTips == nutritionTips) &&
            (identical(other.mealPlan, mealPlan) ||
                other.mealPlan == mealPlan));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, cookingGuide, nutritionTips, mealPlan);

  /// Create a copy of AiSupportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiSupportModelImplCopyWith<_$AiSupportModelImpl> get copyWith =>
      __$$AiSupportModelImplCopyWithImpl<_$AiSupportModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiSupportModelImplToJson(
      this,
    );
  }
}

abstract class _AiSupportModel implements AiSupportModel {
  const factory _AiSupportModel(
          {@JsonKey(name: 'cooking_guide') final String? cookingGuide,
          @JsonKey(name: 'nutrition_tips') final String? nutritionTips,
          @JsonKey(name: 'meal_plan') final String? mealPlan}) =
      _$AiSupportModelImpl;

  factory _AiSupportModel.fromJson(Map<String, dynamic> json) =
      _$AiSupportModelImpl.fromJson;

  @override
  @JsonKey(name: 'cooking_guide')
  String? get cookingGuide;
  @override
  @JsonKey(name: 'nutrition_tips')
  String? get nutritionTips;
  @override
  @JsonKey(name: 'meal_plan')
  String? get mealPlan;

  /// Create a copy of AiSupportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiSupportModelImplCopyWith<_$AiSupportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecommendationResponse _$RecommendationResponseFromJson(
    Map<String, dynamic> json) {
  return _RecommendationResponse.fromJson(json);
}

/// @nodoc
mixin _$RecommendationResponse {
  bool get success => throw _privateConstructorUsedError;
  bool get cached => throw _privateConstructorUsedError;
  RecommendationData get data => throw _privateConstructorUsedError;

  /// Serializes this RecommendationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationResponseCopyWith<RecommendationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationResponseCopyWith<$Res> {
  factory $RecommendationResponseCopyWith(RecommendationResponse value,
          $Res Function(RecommendationResponse) then) =
      _$RecommendationResponseCopyWithImpl<$Res, RecommendationResponse>;
  @useResult
  $Res call({bool success, bool cached, RecommendationData data});

  $RecommendationDataCopyWith<$Res> get data;
}

/// @nodoc
class _$RecommendationResponseCopyWithImpl<$Res,
        $Val extends RecommendationResponse>
    implements $RecommendationResponseCopyWith<$Res> {
  _$RecommendationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? cached = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      cached: null == cached
          ? _value.cached
          : cached // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as RecommendationData,
    ) as $Val);
  }

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationDataCopyWith<$Res> get data {
    return $RecommendationDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendationResponseImplCopyWith<$Res>
    implements $RecommendationResponseCopyWith<$Res> {
  factory _$$RecommendationResponseImplCopyWith(
          _$RecommendationResponseImpl value,
          $Res Function(_$RecommendationResponseImpl) then) =
      __$$RecommendationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, bool cached, RecommendationData data});

  @override
  $RecommendationDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$RecommendationResponseImplCopyWithImpl<$Res>
    extends _$RecommendationResponseCopyWithImpl<$Res,
        _$RecommendationResponseImpl>
    implements _$$RecommendationResponseImplCopyWith<$Res> {
  __$$RecommendationResponseImplCopyWithImpl(
      _$RecommendationResponseImpl _value,
      $Res Function(_$RecommendationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? cached = null,
    Object? data = null,
  }) {
    return _then(_$RecommendationResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      cached: null == cached
          ? _value.cached
          : cached // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as RecommendationData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationResponseImpl implements _RecommendationResponse {
  const _$RecommendationResponseImpl(
      {required this.success, required this.cached, required this.data});

  factory _$RecommendationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final bool cached;
  @override
  final RecommendationData data;

  @override
  String toString() {
    return 'RecommendationResponse(success: $success, cached: $cached, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.cached, cached) || other.cached == cached) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, cached, data);

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationResponseImplCopyWith<_$RecommendationResponseImpl>
      get copyWith => __$$RecommendationResponseImplCopyWithImpl<
          _$RecommendationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationResponseImplToJson(
      this,
    );
  }
}

abstract class _RecommendationResponse implements RecommendationResponse {
  const factory _RecommendationResponse(
      {required final bool success,
      required final bool cached,
      required final RecommendationData data}) = _$RecommendationResponseImpl;

  factory _RecommendationResponse.fromJson(Map<String, dynamic> json) =
      _$RecommendationResponseImpl.fromJson;

  @override
  bool get success;
  @override
  bool get cached;
  @override
  RecommendationData get data;

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationResponseImplCopyWith<_$RecommendationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RecommendationData _$RecommendationDataFromJson(Map<String, dynamic> json) {
  return _RecommendationData.fromJson(json);
}

/// @nodoc
mixin _$RecommendationData {
  @JsonKey(name: 'prediction_summary')
  PredictionSummary get predictionSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'recommended_foods')
  List<FoodModel> get recommendedFoods => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_support')
  AiSupportModel? get aiSupport => throw _privateConstructorUsedError;

  /// Serializes this RecommendationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationDataCopyWith<RecommendationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationDataCopyWith<$Res> {
  factory $RecommendationDataCopyWith(
          RecommendationData value, $Res Function(RecommendationData) then) =
      _$RecommendationDataCopyWithImpl<$Res, RecommendationData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'prediction_summary') PredictionSummary predictionSummary,
      @JsonKey(name: 'recommended_foods') List<FoodModel> recommendedFoods,
      @JsonKey(name: 'ai_support') AiSupportModel? aiSupport});

  $PredictionSummaryCopyWith<$Res> get predictionSummary;
  $AiSupportModelCopyWith<$Res>? get aiSupport;
}

/// @nodoc
class _$RecommendationDataCopyWithImpl<$Res, $Val extends RecommendationData>
    implements $RecommendationDataCopyWith<$Res> {
  _$RecommendationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictionSummary = null,
    Object? recommendedFoods = null,
    Object? aiSupport = freezed,
  }) {
    return _then(_value.copyWith(
      predictionSummary: null == predictionSummary
          ? _value.predictionSummary
          : predictionSummary // ignore: cast_nullable_to_non_nullable
              as PredictionSummary,
      recommendedFoods: null == recommendedFoods
          ? _value.recommendedFoods
          : recommendedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodModel>,
      aiSupport: freezed == aiSupport
          ? _value.aiSupport
          : aiSupport // ignore: cast_nullable_to_non_nullable
              as AiSupportModel?,
    ) as $Val);
  }

  /// Create a copy of RecommendationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PredictionSummaryCopyWith<$Res> get predictionSummary {
    return $PredictionSummaryCopyWith<$Res>(_value.predictionSummary, (value) {
      return _then(_value.copyWith(predictionSummary: value) as $Val);
    });
  }

  /// Create a copy of RecommendationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AiSupportModelCopyWith<$Res>? get aiSupport {
    if (_value.aiSupport == null) {
      return null;
    }

    return $AiSupportModelCopyWith<$Res>(_value.aiSupport!, (value) {
      return _then(_value.copyWith(aiSupport: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendationDataImplCopyWith<$Res>
    implements $RecommendationDataCopyWith<$Res> {
  factory _$$RecommendationDataImplCopyWith(_$RecommendationDataImpl value,
          $Res Function(_$RecommendationDataImpl) then) =
      __$$RecommendationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'prediction_summary') PredictionSummary predictionSummary,
      @JsonKey(name: 'recommended_foods') List<FoodModel> recommendedFoods,
      @JsonKey(name: 'ai_support') AiSupportModel? aiSupport});

  @override
  $PredictionSummaryCopyWith<$Res> get predictionSummary;
  @override
  $AiSupportModelCopyWith<$Res>? get aiSupport;
}

/// @nodoc
class __$$RecommendationDataImplCopyWithImpl<$Res>
    extends _$RecommendationDataCopyWithImpl<$Res, _$RecommendationDataImpl>
    implements _$$RecommendationDataImplCopyWith<$Res> {
  __$$RecommendationDataImplCopyWithImpl(_$RecommendationDataImpl _value,
      $Res Function(_$RecommendationDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictionSummary = null,
    Object? recommendedFoods = null,
    Object? aiSupport = freezed,
  }) {
    return _then(_$RecommendationDataImpl(
      predictionSummary: null == predictionSummary
          ? _value.predictionSummary
          : predictionSummary // ignore: cast_nullable_to_non_nullable
              as PredictionSummary,
      recommendedFoods: null == recommendedFoods
          ? _value._recommendedFoods
          : recommendedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodModel>,
      aiSupport: freezed == aiSupport
          ? _value.aiSupport
          : aiSupport // ignore: cast_nullable_to_non_nullable
              as AiSupportModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationDataImpl implements _RecommendationData {
  const _$RecommendationDataImpl(
      {@JsonKey(name: 'prediction_summary') required this.predictionSummary,
      @JsonKey(name: 'recommended_foods')
      required final List<FoodModel> recommendedFoods,
      @JsonKey(name: 'ai_support') this.aiSupport})
      : _recommendedFoods = recommendedFoods;

  factory _$RecommendationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationDataImplFromJson(json);

  @override
  @JsonKey(name: 'prediction_summary')
  final PredictionSummary predictionSummary;
  final List<FoodModel> _recommendedFoods;
  @override
  @JsonKey(name: 'recommended_foods')
  List<FoodModel> get recommendedFoods {
    if (_recommendedFoods is EqualUnmodifiableListView)
      return _recommendedFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedFoods);
  }

  @override
  @JsonKey(name: 'ai_support')
  final AiSupportModel? aiSupport;

  @override
  String toString() {
    return 'RecommendationData(predictionSummary: $predictionSummary, recommendedFoods: $recommendedFoods, aiSupport: $aiSupport)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationDataImpl &&
            (identical(other.predictionSummary, predictionSummary) ||
                other.predictionSummary == predictionSummary) &&
            const DeepCollectionEquality()
                .equals(other._recommendedFoods, _recommendedFoods) &&
            (identical(other.aiSupport, aiSupport) ||
                other.aiSupport == aiSupport));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, predictionSummary,
      const DeepCollectionEquality().hash(_recommendedFoods), aiSupport);

  /// Create a copy of RecommendationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationDataImplCopyWith<_$RecommendationDataImpl> get copyWith =>
      __$$RecommendationDataImplCopyWithImpl<_$RecommendationDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationDataImplToJson(
      this,
    );
  }
}

abstract class _RecommendationData implements RecommendationData {
  const factory _RecommendationData(
          {@JsonKey(name: 'prediction_summary')
          required final PredictionSummary predictionSummary,
          @JsonKey(name: 'recommended_foods')
          required final List<FoodModel> recommendedFoods,
          @JsonKey(name: 'ai_support') final AiSupportModel? aiSupport}) =
      _$RecommendationDataImpl;

  factory _RecommendationData.fromJson(Map<String, dynamic> json) =
      _$RecommendationDataImpl.fromJson;

  @override
  @JsonKey(name: 'prediction_summary')
  PredictionSummary get predictionSummary;
  @override
  @JsonKey(name: 'recommended_foods')
  List<FoodModel> get recommendedFoods;
  @override
  @JsonKey(name: 'ai_support')
  AiSupportModel? get aiSupport;

  /// Create a copy of RecommendationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationDataImplCopyWith<_$RecommendationDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PredictionSummary _$PredictionSummaryFromJson(Map<String, dynamic> json) {
  return _PredictionSummary.fromJson(json);
}

/// @nodoc
mixin _$PredictionSummary {
  @JsonKey(name: 'risk_label')
  String get riskLabel => throw _privateConstructorUsedError;
  double get probability => throw _privateConstructorUsedError;

  /// Serializes this PredictionSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PredictionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictionSummaryCopyWith<PredictionSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictionSummaryCopyWith<$Res> {
  factory $PredictionSummaryCopyWith(
          PredictionSummary value, $Res Function(PredictionSummary) then) =
      _$PredictionSummaryCopyWithImpl<$Res, PredictionSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_label') String riskLabel, double probability});
}

/// @nodoc
class _$PredictionSummaryCopyWithImpl<$Res, $Val extends PredictionSummary>
    implements $PredictionSummaryCopyWith<$Res> {
  _$PredictionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PredictionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskLabel = null,
    Object? probability = null,
  }) {
    return _then(_value.copyWith(
      riskLabel: null == riskLabel
          ? _value.riskLabel
          : riskLabel // ignore: cast_nullable_to_non_nullable
              as String,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PredictionSummaryImplCopyWith<$Res>
    implements $PredictionSummaryCopyWith<$Res> {
  factory _$$PredictionSummaryImplCopyWith(_$PredictionSummaryImpl value,
          $Res Function(_$PredictionSummaryImpl) then) =
      __$$PredictionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_label') String riskLabel, double probability});
}

/// @nodoc
class __$$PredictionSummaryImplCopyWithImpl<$Res>
    extends _$PredictionSummaryCopyWithImpl<$Res, _$PredictionSummaryImpl>
    implements _$$PredictionSummaryImplCopyWith<$Res> {
  __$$PredictionSummaryImplCopyWithImpl(_$PredictionSummaryImpl _value,
      $Res Function(_$PredictionSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of PredictionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskLabel = null,
    Object? probability = null,
  }) {
    return _then(_$PredictionSummaryImpl(
      riskLabel: null == riskLabel
          ? _value.riskLabel
          : riskLabel // ignore: cast_nullable_to_non_nullable
              as String,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictionSummaryImpl implements _PredictionSummary {
  const _$PredictionSummaryImpl(
      {@JsonKey(name: 'risk_label') required this.riskLabel,
      required this.probability});

  factory _$PredictionSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictionSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'risk_label')
  final String riskLabel;
  @override
  final double probability;

  @override
  String toString() {
    return 'PredictionSummary(riskLabel: $riskLabel, probability: $probability)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictionSummaryImpl &&
            (identical(other.riskLabel, riskLabel) ||
                other.riskLabel == riskLabel) &&
            (identical(other.probability, probability) ||
                other.probability == probability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, riskLabel, probability);

  /// Create a copy of PredictionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictionSummaryImplCopyWith<_$PredictionSummaryImpl> get copyWith =>
      __$$PredictionSummaryImplCopyWithImpl<_$PredictionSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictionSummaryImplToJson(
      this,
    );
  }
}

abstract class _PredictionSummary implements PredictionSummary {
  const factory _PredictionSummary(
      {@JsonKey(name: 'risk_label') required final String riskLabel,
      required final double probability}) = _$PredictionSummaryImpl;

  factory _PredictionSummary.fromJson(Map<String, dynamic> json) =
      _$PredictionSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'risk_label')
  String get riskLabel;
  @override
  double get probability;

  /// Create a copy of PredictionSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictionSummaryImplCopyWith<_$PredictionSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StuntingHistoryItem _$StuntingHistoryItemFromJson(Map<String, dynamic> json) {
  return _StuntingHistoryItem.fromJson(json);
}

/// @nodoc
mixin _$StuntingHistoryItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get riskLevel => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;

  /// Serializes this StuntingHistoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StuntingHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StuntingHistoryItemCopyWith<StuntingHistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StuntingHistoryItemCopyWith<$Res> {
  factory $StuntingHistoryItemCopyWith(
          StuntingHistoryItem value, $Res Function(StuntingHistoryItem) then) =
      _$StuntingHistoryItemCopyWithImpl<$Res, StuntingHistoryItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'date') String date,
      String status,
      int riskLevel,
      double score});
}

/// @nodoc
class _$StuntingHistoryItemCopyWithImpl<$Res, $Val extends StuntingHistoryItem>
    implements $StuntingHistoryItemCopyWith<$Res> {
  _$StuntingHistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StuntingHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? status = null,
    Object? riskLevel = null,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StuntingHistoryItemImplCopyWith<$Res>
    implements $StuntingHistoryItemCopyWith<$Res> {
  factory _$$StuntingHistoryItemImplCopyWith(_$StuntingHistoryItemImpl value,
          $Res Function(_$StuntingHistoryItemImpl) then) =
      __$$StuntingHistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'date') String date,
      String status,
      int riskLevel,
      double score});
}

/// @nodoc
class __$$StuntingHistoryItemImplCopyWithImpl<$Res>
    extends _$StuntingHistoryItemCopyWithImpl<$Res, _$StuntingHistoryItemImpl>
    implements _$$StuntingHistoryItemImplCopyWith<$Res> {
  __$$StuntingHistoryItemImplCopyWithImpl(_$StuntingHistoryItemImpl _value,
      $Res Function(_$StuntingHistoryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of StuntingHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? status = null,
    Object? riskLevel = null,
    Object? score = null,
  }) {
    return _then(_$StuntingHistoryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StuntingHistoryItemImpl implements _StuntingHistoryItem {
  const _$StuntingHistoryItemImpl(
      {required this.id,
      @JsonKey(name: 'date') required this.date,
      required this.status,
      required this.riskLevel,
      required this.score});

  factory _$StuntingHistoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StuntingHistoryItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'date')
  final String date;
  @override
  final String status;
  @override
  final int riskLevel;
  @override
  final double score;

  @override
  String toString() {
    return 'StuntingHistoryItem(id: $id, date: $date, status: $status, riskLevel: $riskLevel, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StuntingHistoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, date, status, riskLevel, score);

  /// Create a copy of StuntingHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StuntingHistoryItemImplCopyWith<_$StuntingHistoryItemImpl> get copyWith =>
      __$$StuntingHistoryItemImplCopyWithImpl<_$StuntingHistoryItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StuntingHistoryItemImplToJson(
      this,
    );
  }
}

abstract class _StuntingHistoryItem implements StuntingHistoryItem {
  const factory _StuntingHistoryItem(
      {required final int id,
      @JsonKey(name: 'date') required final String date,
      required final String status,
      required final int riskLevel,
      required final double score}) = _$StuntingHistoryItemImpl;

  factory _StuntingHistoryItem.fromJson(Map<String, dynamic> json) =
      _$StuntingHistoryItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  String get status;
  @override
  int get riskLevel;
  @override
  double get score;

  /// Create a copy of StuntingHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StuntingHistoryItemImplCopyWith<_$StuntingHistoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
