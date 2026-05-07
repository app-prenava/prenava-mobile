// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stunting_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StuntingQuestion {

 String get key; String get label; String get type; bool get required; List<StuntingOption>? get options; double? get min; double? get max; String? get unit;
/// Create a copy of StuntingQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StuntingQuestionCopyWith<StuntingQuestion> get copyWith => _$StuntingQuestionCopyWithImpl<StuntingQuestion>(this as StuntingQuestion, _$identity);

  /// Serializes this StuntingQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StuntingQuestion&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,type,required,const DeepCollectionEquality().hash(options),min,max,unit);

@override
String toString() {
  return 'StuntingQuestion(key: $key, label: $label, type: $type, required: $required, options: $options, min: $min, max: $max, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $StuntingQuestionCopyWith<$Res>  {
  factory $StuntingQuestionCopyWith(StuntingQuestion value, $Res Function(StuntingQuestion) _then) = _$StuntingQuestionCopyWithImpl;
@useResult
$Res call({
 String key, String label, String type, bool required, List<StuntingOption>? options, double? min, double? max, String? unit
});




}
/// @nodoc
class _$StuntingQuestionCopyWithImpl<$Res>
    implements $StuntingQuestionCopyWith<$Res> {
  _$StuntingQuestionCopyWithImpl(this._self, this._then);

  final StuntingQuestion _self;
  final $Res Function(StuntingQuestion) _then;

/// Create a copy of StuntingQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? type = null,Object? required = null,Object? options = freezed,Object? min = freezed,Object? max = freezed,Object? unit = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<StuntingOption>?,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StuntingQuestion].
extension StuntingQuestionPatterns on StuntingQuestion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StuntingQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StuntingQuestion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StuntingQuestion value)  $default,){
final _that = this;
switch (_that) {
case _StuntingQuestion():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StuntingQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _StuntingQuestion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label,  String type,  bool required,  List<StuntingOption>? options,  double? min,  double? max,  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StuntingQuestion() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.required,_that.options,_that.min,_that.max,_that.unit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label,  String type,  bool required,  List<StuntingOption>? options,  double? min,  double? max,  String? unit)  $default,) {final _that = this;
switch (_that) {
case _StuntingQuestion():
return $default(_that.key,_that.label,_that.type,_that.required,_that.options,_that.min,_that.max,_that.unit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label,  String type,  bool required,  List<StuntingOption>? options,  double? min,  double? max,  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _StuntingQuestion() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.required,_that.options,_that.min,_that.max,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StuntingQuestion implements StuntingQuestion {
  const _StuntingQuestion({required this.key, required this.label, required this.type, required this.required, final  List<StuntingOption>? options, this.min, this.max, this.unit}): _options = options;
  factory _StuntingQuestion.fromJson(Map<String, dynamic> json) => _$StuntingQuestionFromJson(json);

@override final  String key;
@override final  String label;
@override final  String type;
@override final  bool required;
 final  List<StuntingOption>? _options;
@override List<StuntingOption>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  double? min;
@override final  double? max;
@override final  String? unit;

/// Create a copy of StuntingQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StuntingQuestionCopyWith<_StuntingQuestion> get copyWith => __$StuntingQuestionCopyWithImpl<_StuntingQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StuntingQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StuntingQuestion&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,type,required,const DeepCollectionEquality().hash(_options),min,max,unit);

@override
String toString() {
  return 'StuntingQuestion(key: $key, label: $label, type: $type, required: $required, options: $options, min: $min, max: $max, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$StuntingQuestionCopyWith<$Res> implements $StuntingQuestionCopyWith<$Res> {
  factory _$StuntingQuestionCopyWith(_StuntingQuestion value, $Res Function(_StuntingQuestion) _then) = __$StuntingQuestionCopyWithImpl;
@override @useResult
$Res call({
 String key, String label, String type, bool required, List<StuntingOption>? options, double? min, double? max, String? unit
});




}
/// @nodoc
class __$StuntingQuestionCopyWithImpl<$Res>
    implements _$StuntingQuestionCopyWith<$Res> {
  __$StuntingQuestionCopyWithImpl(this._self, this._then);

  final _StuntingQuestion _self;
  final $Res Function(_StuntingQuestion) _then;

/// Create a copy of StuntingQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? type = null,Object? required = null,Object? options = freezed,Object? min = freezed,Object? max = freezed,Object? unit = freezed,}) {
  return _then(_StuntingQuestion(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<StuntingOption>?,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StuntingOption {

 dynamic get value; String get label;
/// Create a copy of StuntingOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StuntingOptionCopyWith<StuntingOption> get copyWith => _$StuntingOptionCopyWithImpl<StuntingOption>(this as StuntingOption, _$identity);

  /// Serializes this StuntingOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StuntingOption&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value),label);

@override
String toString() {
  return 'StuntingOption(value: $value, label: $label)';
}


}

/// @nodoc
abstract mixin class $StuntingOptionCopyWith<$Res>  {
  factory $StuntingOptionCopyWith(StuntingOption value, $Res Function(StuntingOption) _then) = _$StuntingOptionCopyWithImpl;
@useResult
$Res call({
 dynamic value, String label
});




}
/// @nodoc
class _$StuntingOptionCopyWithImpl<$Res>
    implements $StuntingOptionCopyWith<$Res> {
  _$StuntingOptionCopyWithImpl(this._self, this._then);

  final StuntingOption _self;
  final $Res Function(StuntingOption) _then;

/// Create a copy of StuntingOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,Object? label = null,}) {
  return _then(_self.copyWith(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StuntingOption].
extension StuntingOptionPatterns on StuntingOption {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StuntingOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StuntingOption() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StuntingOption value)  $default,){
final _that = this;
switch (_that) {
case _StuntingOption():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StuntingOption value)?  $default,){
final _that = this;
switch (_that) {
case _StuntingOption() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( dynamic value,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StuntingOption() when $default != null:
return $default(_that.value,_that.label);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( dynamic value,  String label)  $default,) {final _that = this;
switch (_that) {
case _StuntingOption():
return $default(_that.value,_that.label);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( dynamic value,  String label)?  $default,) {final _that = this;
switch (_that) {
case _StuntingOption() when $default != null:
return $default(_that.value,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StuntingOption implements StuntingOption {
  const _StuntingOption({required this.value, required this.label});
  factory _StuntingOption.fromJson(Map<String, dynamic> json) => _$StuntingOptionFromJson(json);

@override final  dynamic value;
@override final  String label;

/// Create a copy of StuntingOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StuntingOptionCopyWith<_StuntingOption> get copyWith => __$StuntingOptionCopyWithImpl<_StuntingOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StuntingOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StuntingOption&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value),label);

@override
String toString() {
  return 'StuntingOption(value: $value, label: $label)';
}


}

/// @nodoc
abstract mixin class _$StuntingOptionCopyWith<$Res> implements $StuntingOptionCopyWith<$Res> {
  factory _$StuntingOptionCopyWith(_StuntingOption value, $Res Function(_StuntingOption) _then) = __$StuntingOptionCopyWithImpl;
@override @useResult
$Res call({
 dynamic value, String label
});




}
/// @nodoc
class __$StuntingOptionCopyWithImpl<$Res>
    implements _$StuntingOptionCopyWith<$Res> {
  __$StuntingOptionCopyWithImpl(this._self, this._then);

  final _StuntingOption _self;
  final $Res Function(_StuntingOption) _then;

/// Create a copy of StuntingOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = freezed,Object? label = null,}) {
  return _then(_StuntingOption(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ShapFactor {

 String get feature; String get impact; double get value; String? get message;
/// Create a copy of ShapFactor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapFactorCopyWith<ShapFactor> get copyWith => _$ShapFactorCopyWithImpl<ShapFactor>(this as ShapFactor, _$identity);

  /// Serializes this ShapFactor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapFactor&&(identical(other.feature, feature) || other.feature == feature)&&(identical(other.impact, impact) || other.impact == impact)&&(identical(other.value, value) || other.value == value)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feature,impact,value,message);

@override
String toString() {
  return 'ShapFactor(feature: $feature, impact: $impact, value: $value, message: $message)';
}


}

/// @nodoc
abstract mixin class $ShapFactorCopyWith<$Res>  {
  factory $ShapFactorCopyWith(ShapFactor value, $Res Function(ShapFactor) _then) = _$ShapFactorCopyWithImpl;
@useResult
$Res call({
 String feature, String impact, double value, String? message
});




}
/// @nodoc
class _$ShapFactorCopyWithImpl<$Res>
    implements $ShapFactorCopyWith<$Res> {
  _$ShapFactorCopyWithImpl(this._self, this._then);

  final ShapFactor _self;
  final $Res Function(ShapFactor) _then;

/// Create a copy of ShapFactor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feature = null,Object? impact = null,Object? value = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
feature: null == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String,impact: null == impact ? _self.impact : impact // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShapFactor].
extension ShapFactorPatterns on ShapFactor {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShapFactor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShapFactor() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShapFactor value)  $default,){
final _that = this;
switch (_that) {
case _ShapFactor():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShapFactor value)?  $default,){
final _that = this;
switch (_that) {
case _ShapFactor() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String feature,  String impact,  double value,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShapFactor() when $default != null:
return $default(_that.feature,_that.impact,_that.value,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String feature,  String impact,  double value,  String? message)  $default,) {final _that = this;
switch (_that) {
case _ShapFactor():
return $default(_that.feature,_that.impact,_that.value,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String feature,  String impact,  double value,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ShapFactor() when $default != null:
return $default(_that.feature,_that.impact,_that.value,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShapFactor implements ShapFactor {
  const _ShapFactor({required this.feature, required this.impact, required this.value, this.message});
  factory _ShapFactor.fromJson(Map<String, dynamic> json) => _$ShapFactorFromJson(json);

@override final  String feature;
@override final  String impact;
@override final  double value;
@override final  String? message;

/// Create a copy of ShapFactor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShapFactorCopyWith<_ShapFactor> get copyWith => __$ShapFactorCopyWithImpl<_ShapFactor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShapFactorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShapFactor&&(identical(other.feature, feature) || other.feature == feature)&&(identical(other.impact, impact) || other.impact == impact)&&(identical(other.value, value) || other.value == value)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feature,impact,value,message);

@override
String toString() {
  return 'ShapFactor(feature: $feature, impact: $impact, value: $value, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ShapFactorCopyWith<$Res> implements $ShapFactorCopyWith<$Res> {
  factory _$ShapFactorCopyWith(_ShapFactor value, $Res Function(_ShapFactor) _then) = __$ShapFactorCopyWithImpl;
@override @useResult
$Res call({
 String feature, String impact, double value, String? message
});




}
/// @nodoc
class __$ShapFactorCopyWithImpl<$Res>
    implements _$ShapFactorCopyWith<$Res> {
  __$ShapFactorCopyWithImpl(this._self, this._then);

  final _ShapFactor _self;
  final $Res Function(_ShapFactor) _then;

/// Create a copy of ShapFactor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feature = null,Object? impact = null,Object? value = null,Object? message = freezed,}) {
  return _then(_ShapFactor(
feature: null == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String,impact: null == impact ? _self.impact : impact // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ShapExplanation {

 String get method;@JsonKey(name: 'top_factors') List<ShapFactor> get topFactors;
/// Create a copy of ShapExplanation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapExplanationCopyWith<ShapExplanation> get copyWith => _$ShapExplanationCopyWithImpl<ShapExplanation>(this as ShapExplanation, _$identity);

  /// Serializes this ShapExplanation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapExplanation&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.topFactors, topFactors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,const DeepCollectionEquality().hash(topFactors));

@override
String toString() {
  return 'ShapExplanation(method: $method, topFactors: $topFactors)';
}


}

/// @nodoc
abstract mixin class $ShapExplanationCopyWith<$Res>  {
  factory $ShapExplanationCopyWith(ShapExplanation value, $Res Function(ShapExplanation) _then) = _$ShapExplanationCopyWithImpl;
@useResult
$Res call({
 String method,@JsonKey(name: 'top_factors') List<ShapFactor> topFactors
});




}
/// @nodoc
class _$ShapExplanationCopyWithImpl<$Res>
    implements $ShapExplanationCopyWith<$Res> {
  _$ShapExplanationCopyWithImpl(this._self, this._then);

  final ShapExplanation _self;
  final $Res Function(ShapExplanation) _then;

/// Create a copy of ShapExplanation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? topFactors = null,}) {
  return _then(_self.copyWith(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,topFactors: null == topFactors ? _self.topFactors : topFactors // ignore: cast_nullable_to_non_nullable
as List<ShapFactor>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShapExplanation].
extension ShapExplanationPatterns on ShapExplanation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShapExplanation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShapExplanation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShapExplanation value)  $default,){
final _that = this;
switch (_that) {
case _ShapExplanation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShapExplanation value)?  $default,){
final _that = this;
switch (_that) {
case _ShapExplanation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String method, @JsonKey(name: 'top_factors')  List<ShapFactor> topFactors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShapExplanation() when $default != null:
return $default(_that.method,_that.topFactors);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String method, @JsonKey(name: 'top_factors')  List<ShapFactor> topFactors)  $default,) {final _that = this;
switch (_that) {
case _ShapExplanation():
return $default(_that.method,_that.topFactors);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String method, @JsonKey(name: 'top_factors')  List<ShapFactor> topFactors)?  $default,) {final _that = this;
switch (_that) {
case _ShapExplanation() when $default != null:
return $default(_that.method,_that.topFactors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShapExplanation implements ShapExplanation {
  const _ShapExplanation({required this.method, @JsonKey(name: 'top_factors') required final  List<ShapFactor> topFactors}): _topFactors = topFactors;
  factory _ShapExplanation.fromJson(Map<String, dynamic> json) => _$ShapExplanationFromJson(json);

@override final  String method;
 final  List<ShapFactor> _topFactors;
@override@JsonKey(name: 'top_factors') List<ShapFactor> get topFactors {
  if (_topFactors is EqualUnmodifiableListView) return _topFactors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topFactors);
}


/// Create a copy of ShapExplanation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShapExplanationCopyWith<_ShapExplanation> get copyWith => __$ShapExplanationCopyWithImpl<_ShapExplanation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShapExplanationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShapExplanation&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._topFactors, _topFactors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,const DeepCollectionEquality().hash(_topFactors));

@override
String toString() {
  return 'ShapExplanation(method: $method, topFactors: $topFactors)';
}


}

/// @nodoc
abstract mixin class _$ShapExplanationCopyWith<$Res> implements $ShapExplanationCopyWith<$Res> {
  factory _$ShapExplanationCopyWith(_ShapExplanation value, $Res Function(_ShapExplanation) _then) = __$ShapExplanationCopyWithImpl;
@override @useResult
$Res call({
 String method,@JsonKey(name: 'top_factors') List<ShapFactor> topFactors
});




}
/// @nodoc
class __$ShapExplanationCopyWithImpl<$Res>
    implements _$ShapExplanationCopyWith<$Res> {
  __$ShapExplanationCopyWithImpl(this._self, this._then);

  final _ShapExplanation _self;
  final $Res Function(_ShapExplanation) _then;

/// Create a copy of ShapExplanation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? topFactors = null,}) {
  return _then(_ShapExplanation(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,topFactors: null == topFactors ? _self._topFactors : topFactors // ignore: cast_nullable_to_non_nullable
as List<ShapFactor>,
  ));
}


}


/// @nodoc
mixin _$PredictionResult {

 int get id;@JsonKey(name: 'risk_label') String get riskLabel; double get probability;@JsonKey(name: 'prediction') int get predictionValue; ShapExplanation? get explanation;@JsonKey(name: 'model_version') String? get modelVersion;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictionResultCopyWith<PredictionResult> get copyWith => _$PredictionResultCopyWithImpl<PredictionResult>(this as PredictionResult, _$identity);

  /// Serializes this PredictionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PredictionResult&&(identical(other.id, id) || other.id == id)&&(identical(other.riskLabel, riskLabel) || other.riskLabel == riskLabel)&&(identical(other.probability, probability) || other.probability == probability)&&(identical(other.predictionValue, predictionValue) || other.predictionValue == predictionValue)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,riskLabel,probability,predictionValue,explanation,modelVersion,createdAt);

@override
String toString() {
  return 'PredictionResult(id: $id, riskLabel: $riskLabel, probability: $probability, predictionValue: $predictionValue, explanation: $explanation, modelVersion: $modelVersion, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PredictionResultCopyWith<$Res>  {
  factory $PredictionResultCopyWith(PredictionResult value, $Res Function(PredictionResult) _then) = _$PredictionResultCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'risk_label') String riskLabel, double probability,@JsonKey(name: 'prediction') int predictionValue, ShapExplanation? explanation,@JsonKey(name: 'model_version') String? modelVersion,@JsonKey(name: 'created_at') String? createdAt
});


$ShapExplanationCopyWith<$Res>? get explanation;

}
/// @nodoc
class _$PredictionResultCopyWithImpl<$Res>
    implements $PredictionResultCopyWith<$Res> {
  _$PredictionResultCopyWithImpl(this._self, this._then);

  final PredictionResult _self;
  final $Res Function(PredictionResult) _then;

/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? riskLabel = null,Object? probability = null,Object? predictionValue = null,Object? explanation = freezed,Object? modelVersion = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,riskLabel: null == riskLabel ? _self.riskLabel : riskLabel // ignore: cast_nullable_to_non_nullable
as String,probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,predictionValue: null == predictionValue ? _self.predictionValue : predictionValue // ignore: cast_nullable_to_non_nullable
as int,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as ShapExplanation?,modelVersion: freezed == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapExplanationCopyWith<$Res>? get explanation {
    if (_self.explanation == null) {
    return null;
  }

  return $ShapExplanationCopyWith<$Res>(_self.explanation!, (value) {
    return _then(_self.copyWith(explanation: value));
  });
}
}


/// Adds pattern-matching-related methods to [PredictionResult].
extension PredictionResultPatterns on PredictionResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PredictionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PredictionResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PredictionResult value)  $default,){
final _that = this;
switch (_that) {
case _PredictionResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PredictionResult value)?  $default,){
final _that = this;
switch (_that) {
case _PredictionResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'risk_label')  String riskLabel,  double probability, @JsonKey(name: 'prediction')  int predictionValue,  ShapExplanation? explanation, @JsonKey(name: 'model_version')  String? modelVersion, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PredictionResult() when $default != null:
return $default(_that.id,_that.riskLabel,_that.probability,_that.predictionValue,_that.explanation,_that.modelVersion,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'risk_label')  String riskLabel,  double probability, @JsonKey(name: 'prediction')  int predictionValue,  ShapExplanation? explanation, @JsonKey(name: 'model_version')  String? modelVersion, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PredictionResult():
return $default(_that.id,_that.riskLabel,_that.probability,_that.predictionValue,_that.explanation,_that.modelVersion,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'risk_label')  String riskLabel,  double probability, @JsonKey(name: 'prediction')  int predictionValue,  ShapExplanation? explanation, @JsonKey(name: 'model_version')  String? modelVersion, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PredictionResult() when $default != null:
return $default(_that.id,_that.riskLabel,_that.probability,_that.predictionValue,_that.explanation,_that.modelVersion,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PredictionResult implements PredictionResult {
  const _PredictionResult({required this.id, @JsonKey(name: 'risk_label') required this.riskLabel, required this.probability, @JsonKey(name: 'prediction') required this.predictionValue, this.explanation, @JsonKey(name: 'model_version') this.modelVersion, @JsonKey(name: 'created_at') this.createdAt});
  factory _PredictionResult.fromJson(Map<String, dynamic> json) => _$PredictionResultFromJson(json);

@override final  int id;
@override@JsonKey(name: 'risk_label') final  String riskLabel;
@override final  double probability;
@override@JsonKey(name: 'prediction') final  int predictionValue;
@override final  ShapExplanation? explanation;
@override@JsonKey(name: 'model_version') final  String? modelVersion;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictionResultCopyWith<_PredictionResult> get copyWith => __$PredictionResultCopyWithImpl<_PredictionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PredictionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PredictionResult&&(identical(other.id, id) || other.id == id)&&(identical(other.riskLabel, riskLabel) || other.riskLabel == riskLabel)&&(identical(other.probability, probability) || other.probability == probability)&&(identical(other.predictionValue, predictionValue) || other.predictionValue == predictionValue)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,riskLabel,probability,predictionValue,explanation,modelVersion,createdAt);

@override
String toString() {
  return 'PredictionResult(id: $id, riskLabel: $riskLabel, probability: $probability, predictionValue: $predictionValue, explanation: $explanation, modelVersion: $modelVersion, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PredictionResultCopyWith<$Res> implements $PredictionResultCopyWith<$Res> {
  factory _$PredictionResultCopyWith(_PredictionResult value, $Res Function(_PredictionResult) _then) = __$PredictionResultCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'risk_label') String riskLabel, double probability,@JsonKey(name: 'prediction') int predictionValue, ShapExplanation? explanation,@JsonKey(name: 'model_version') String? modelVersion,@JsonKey(name: 'created_at') String? createdAt
});


@override $ShapExplanationCopyWith<$Res>? get explanation;

}
/// @nodoc
class __$PredictionResultCopyWithImpl<$Res>
    implements _$PredictionResultCopyWith<$Res> {
  __$PredictionResultCopyWithImpl(this._self, this._then);

  final _PredictionResult _self;
  final $Res Function(_PredictionResult) _then;

/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? riskLabel = null,Object? probability = null,Object? predictionValue = null,Object? explanation = freezed,Object? modelVersion = freezed,Object? createdAt = freezed,}) {
  return _then(_PredictionResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,riskLabel: null == riskLabel ? _self.riskLabel : riskLabel // ignore: cast_nullable_to_non_nullable
as String,probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,predictionValue: null == predictionValue ? _self.predictionValue : predictionValue // ignore: cast_nullable_to_non_nullable
as int,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as ShapExplanation?,modelVersion: freezed == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PredictionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapExplanationCopyWith<$Res>? get explanation {
    if (_self.explanation == null) {
    return null;
  }

  return $ShapExplanationCopyWith<$Res>(_self.explanation!, (value) {
    return _then(_self.copyWith(explanation: value));
  });
}
}


/// @nodoc
mixin _$FoodModel {

 int get id; String get name;@JsonKey(name: 'image_url') String? get imageUrl; double get protein; double get calories; double? get fat; double? get carbohydrates; String? get reason;
/// Create a copy of FoodModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodModelCopyWith<FoodModel> get copyWith => _$FoodModelCopyWithImpl<FoodModel>(this as FoodModel, _$identity);

  /// Serializes this FoodModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.carbohydrates, carbohydrates) || other.carbohydrates == carbohydrates)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,protein,calories,fat,carbohydrates,reason);

@override
String toString() {
  return 'FoodModel(id: $id, name: $name, imageUrl: $imageUrl, protein: $protein, calories: $calories, fat: $fat, carbohydrates: $carbohydrates, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $FoodModelCopyWith<$Res>  {
  factory $FoodModelCopyWith(FoodModel value, $Res Function(FoodModel) _then) = _$FoodModelCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'image_url') String? imageUrl, double protein, double calories, double? fat, double? carbohydrates, String? reason
});




}
/// @nodoc
class _$FoodModelCopyWithImpl<$Res>
    implements $FoodModelCopyWith<$Res> {
  _$FoodModelCopyWithImpl(this._self, this._then);

  final FoodModel _self;
  final $Res Function(FoodModel) _then;

/// Create a copy of FoodModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? protein = null,Object? calories = null,Object? fat = freezed,Object? carbohydrates = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,fat: freezed == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double?,carbohydrates: freezed == carbohydrates ? _self.carbohydrates : carbohydrates // ignore: cast_nullable_to_non_nullable
as double?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodModel].
extension FoodModelPatterns on FoodModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodModel value)  $default,){
final _that = this;
switch (_that) {
case _FoodModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodModel value)?  $default,){
final _that = this;
switch (_that) {
case _FoodModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double protein,  double calories,  double? fat,  double? carbohydrates,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodModel() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.protein,_that.calories,_that.fat,_that.carbohydrates,_that.reason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double protein,  double calories,  double? fat,  double? carbohydrates,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _FoodModel():
return $default(_that.id,_that.name,_that.imageUrl,_that.protein,_that.calories,_that.fat,_that.carbohydrates,_that.reason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double protein,  double calories,  double? fat,  double? carbohydrates,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _FoodModel() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.protein,_that.calories,_that.fat,_that.carbohydrates,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodModel implements FoodModel {
  const _FoodModel({required this.id, required this.name, @JsonKey(name: 'image_url') this.imageUrl, required this.protein, required this.calories, this.fat, this.carbohydrates, this.reason});
  factory _FoodModel.fromJson(Map<String, dynamic> json) => _$FoodModelFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override final  double protein;
@override final  double calories;
@override final  double? fat;
@override final  double? carbohydrates;
@override final  String? reason;

/// Create a copy of FoodModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodModelCopyWith<_FoodModel> get copyWith => __$FoodModelCopyWithImpl<_FoodModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.carbohydrates, carbohydrates) || other.carbohydrates == carbohydrates)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,protein,calories,fat,carbohydrates,reason);

@override
String toString() {
  return 'FoodModel(id: $id, name: $name, imageUrl: $imageUrl, protein: $protein, calories: $calories, fat: $fat, carbohydrates: $carbohydrates, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$FoodModelCopyWith<$Res> implements $FoodModelCopyWith<$Res> {
  factory _$FoodModelCopyWith(_FoodModel value, $Res Function(_FoodModel) _then) = __$FoodModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'image_url') String? imageUrl, double protein, double calories, double? fat, double? carbohydrates, String? reason
});




}
/// @nodoc
class __$FoodModelCopyWithImpl<$Res>
    implements _$FoodModelCopyWith<$Res> {
  __$FoodModelCopyWithImpl(this._self, this._then);

  final _FoodModel _self;
  final $Res Function(_FoodModel) _then;

/// Create a copy of FoodModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? protein = null,Object? calories = null,Object? fat = freezed,Object? carbohydrates = freezed,Object? reason = freezed,}) {
  return _then(_FoodModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,fat: freezed == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double?,carbohydrates: freezed == carbohydrates ? _self.carbohydrates : carbohydrates // ignore: cast_nullable_to_non_nullable
as double?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AiSupportModel {

@JsonKey(name: 'cooking_guide') String? get cookingGuide;@JsonKey(name: 'nutrition_tips') String? get nutritionTips;@JsonKey(name: 'meal_plan') String? get mealPlan;
/// Create a copy of AiSupportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSupportModelCopyWith<AiSupportModel> get copyWith => _$AiSupportModelCopyWithImpl<AiSupportModel>(this as AiSupportModel, _$identity);

  /// Serializes this AiSupportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSupportModel&&(identical(other.cookingGuide, cookingGuide) || other.cookingGuide == cookingGuide)&&(identical(other.nutritionTips, nutritionTips) || other.nutritionTips == nutritionTips)&&(identical(other.mealPlan, mealPlan) || other.mealPlan == mealPlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cookingGuide,nutritionTips,mealPlan);

@override
String toString() {
  return 'AiSupportModel(cookingGuide: $cookingGuide, nutritionTips: $nutritionTips, mealPlan: $mealPlan)';
}


}

/// @nodoc
abstract mixin class $AiSupportModelCopyWith<$Res>  {
  factory $AiSupportModelCopyWith(AiSupportModel value, $Res Function(AiSupportModel) _then) = _$AiSupportModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'cooking_guide') String? cookingGuide,@JsonKey(name: 'nutrition_tips') String? nutritionTips,@JsonKey(name: 'meal_plan') String? mealPlan
});




}
/// @nodoc
class _$AiSupportModelCopyWithImpl<$Res>
    implements $AiSupportModelCopyWith<$Res> {
  _$AiSupportModelCopyWithImpl(this._self, this._then);

  final AiSupportModel _self;
  final $Res Function(AiSupportModel) _then;

/// Create a copy of AiSupportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cookingGuide = freezed,Object? nutritionTips = freezed,Object? mealPlan = freezed,}) {
  return _then(_self.copyWith(
cookingGuide: freezed == cookingGuide ? _self.cookingGuide : cookingGuide // ignore: cast_nullable_to_non_nullable
as String?,nutritionTips: freezed == nutritionTips ? _self.nutritionTips : nutritionTips // ignore: cast_nullable_to_non_nullable
as String?,mealPlan: freezed == mealPlan ? _self.mealPlan : mealPlan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSupportModel].
extension AiSupportModelPatterns on AiSupportModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSupportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSupportModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSupportModel value)  $default,){
final _that = this;
switch (_that) {
case _AiSupportModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSupportModel value)?  $default,){
final _that = this;
switch (_that) {
case _AiSupportModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'cooking_guide')  String? cookingGuide, @JsonKey(name: 'nutrition_tips')  String? nutritionTips, @JsonKey(name: 'meal_plan')  String? mealPlan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiSupportModel() when $default != null:
return $default(_that.cookingGuide,_that.nutritionTips,_that.mealPlan);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'cooking_guide')  String? cookingGuide, @JsonKey(name: 'nutrition_tips')  String? nutritionTips, @JsonKey(name: 'meal_plan')  String? mealPlan)  $default,) {final _that = this;
switch (_that) {
case _AiSupportModel():
return $default(_that.cookingGuide,_that.nutritionTips,_that.mealPlan);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'cooking_guide')  String? cookingGuide, @JsonKey(name: 'nutrition_tips')  String? nutritionTips, @JsonKey(name: 'meal_plan')  String? mealPlan)?  $default,) {final _that = this;
switch (_that) {
case _AiSupportModel() when $default != null:
return $default(_that.cookingGuide,_that.nutritionTips,_that.mealPlan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiSupportModel implements AiSupportModel {
  const _AiSupportModel({@JsonKey(name: 'cooking_guide') this.cookingGuide, @JsonKey(name: 'nutrition_tips') this.nutritionTips, @JsonKey(name: 'meal_plan') this.mealPlan});
  factory _AiSupportModel.fromJson(Map<String, dynamic> json) => _$AiSupportModelFromJson(json);

@override@JsonKey(name: 'cooking_guide') final  String? cookingGuide;
@override@JsonKey(name: 'nutrition_tips') final  String? nutritionTips;
@override@JsonKey(name: 'meal_plan') final  String? mealPlan;

/// Create a copy of AiSupportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSupportModelCopyWith<_AiSupportModel> get copyWith => __$AiSupportModelCopyWithImpl<_AiSupportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiSupportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSupportModel&&(identical(other.cookingGuide, cookingGuide) || other.cookingGuide == cookingGuide)&&(identical(other.nutritionTips, nutritionTips) || other.nutritionTips == nutritionTips)&&(identical(other.mealPlan, mealPlan) || other.mealPlan == mealPlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cookingGuide,nutritionTips,mealPlan);

@override
String toString() {
  return 'AiSupportModel(cookingGuide: $cookingGuide, nutritionTips: $nutritionTips, mealPlan: $mealPlan)';
}


}

/// @nodoc
abstract mixin class _$AiSupportModelCopyWith<$Res> implements $AiSupportModelCopyWith<$Res> {
  factory _$AiSupportModelCopyWith(_AiSupportModel value, $Res Function(_AiSupportModel) _then) = __$AiSupportModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'cooking_guide') String? cookingGuide,@JsonKey(name: 'nutrition_tips') String? nutritionTips,@JsonKey(name: 'meal_plan') String? mealPlan
});




}
/// @nodoc
class __$AiSupportModelCopyWithImpl<$Res>
    implements _$AiSupportModelCopyWith<$Res> {
  __$AiSupportModelCopyWithImpl(this._self, this._then);

  final _AiSupportModel _self;
  final $Res Function(_AiSupportModel) _then;

/// Create a copy of AiSupportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cookingGuide = freezed,Object? nutritionTips = freezed,Object? mealPlan = freezed,}) {
  return _then(_AiSupportModel(
cookingGuide: freezed == cookingGuide ? _self.cookingGuide : cookingGuide // ignore: cast_nullable_to_non_nullable
as String?,nutritionTips: freezed == nutritionTips ? _self.nutritionTips : nutritionTips // ignore: cast_nullable_to_non_nullable
as String?,mealPlan: freezed == mealPlan ? _self.mealPlan : mealPlan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RecommendationResponse {

 bool get success; bool get cached; RecommendationData get data;
/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationResponseCopyWith<RecommendationResponse> get copyWith => _$RecommendationResponseCopyWithImpl<RecommendationResponse>(this as RecommendationResponse, _$identity);

  /// Serializes this RecommendationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.cached, cached) || other.cached == cached)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,cached,data);

@override
String toString() {
  return 'RecommendationResponse(success: $success, cached: $cached, data: $data)';
}


}

/// @nodoc
abstract mixin class $RecommendationResponseCopyWith<$Res>  {
  factory $RecommendationResponseCopyWith(RecommendationResponse value, $Res Function(RecommendationResponse) _then) = _$RecommendationResponseCopyWithImpl;
@useResult
$Res call({
 bool success, bool cached, RecommendationData data
});


$RecommendationDataCopyWith<$Res> get data;

}
/// @nodoc
class _$RecommendationResponseCopyWithImpl<$Res>
    implements $RecommendationResponseCopyWith<$Res> {
  _$RecommendationResponseCopyWithImpl(this._self, this._then);

  final RecommendationResponse _self;
  final $Res Function(RecommendationResponse) _then;

/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? cached = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RecommendationData,
  ));
}
/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecommendationDataCopyWith<$Res> get data {
  
  return $RecommendationDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecommendationResponse].
extension RecommendationResponsePatterns on RecommendationResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationResponse value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  bool cached,  RecommendationData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationResponse() when $default != null:
return $default(_that.success,_that.cached,_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  bool cached,  RecommendationData data)  $default,) {final _that = this;
switch (_that) {
case _RecommendationResponse():
return $default(_that.success,_that.cached,_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  bool cached,  RecommendationData data)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationResponse() when $default != null:
return $default(_that.success,_that.cached,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecommendationResponse implements RecommendationResponse {
  const _RecommendationResponse({required this.success, required this.cached, required this.data});
  factory _RecommendationResponse.fromJson(Map<String, dynamic> json) => _$RecommendationResponseFromJson(json);

@override final  bool success;
@override final  bool cached;
@override final  RecommendationData data;

/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationResponseCopyWith<_RecommendationResponse> get copyWith => __$RecommendationResponseCopyWithImpl<_RecommendationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.cached, cached) || other.cached == cached)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,cached,data);

@override
String toString() {
  return 'RecommendationResponse(success: $success, cached: $cached, data: $data)';
}


}

/// @nodoc
abstract mixin class _$RecommendationResponseCopyWith<$Res> implements $RecommendationResponseCopyWith<$Res> {
  factory _$RecommendationResponseCopyWith(_RecommendationResponse value, $Res Function(_RecommendationResponse) _then) = __$RecommendationResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, bool cached, RecommendationData data
});


@override $RecommendationDataCopyWith<$Res> get data;

}
/// @nodoc
class __$RecommendationResponseCopyWithImpl<$Res>
    implements _$RecommendationResponseCopyWith<$Res> {
  __$RecommendationResponseCopyWithImpl(this._self, this._then);

  final _RecommendationResponse _self;
  final $Res Function(_RecommendationResponse) _then;

/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? cached = null,Object? data = null,}) {
  return _then(_RecommendationResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RecommendationData,
  ));
}

/// Create a copy of RecommendationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecommendationDataCopyWith<$Res> get data {
  
  return $RecommendationDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$RecommendationData {

@JsonKey(name: 'prediction_summary') PredictionSummary get predictionSummary;@JsonKey(name: 'recommended_foods') List<FoodModel> get recommendedFoods;@JsonKey(name: 'ai_support') AiSupportModel? get aiSupport;
/// Create a copy of RecommendationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationDataCopyWith<RecommendationData> get copyWith => _$RecommendationDataCopyWithImpl<RecommendationData>(this as RecommendationData, _$identity);

  /// Serializes this RecommendationData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationData&&(identical(other.predictionSummary, predictionSummary) || other.predictionSummary == predictionSummary)&&const DeepCollectionEquality().equals(other.recommendedFoods, recommendedFoods)&&(identical(other.aiSupport, aiSupport) || other.aiSupport == aiSupport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,predictionSummary,const DeepCollectionEquality().hash(recommendedFoods),aiSupport);

@override
String toString() {
  return 'RecommendationData(predictionSummary: $predictionSummary, recommendedFoods: $recommendedFoods, aiSupport: $aiSupport)';
}


}

/// @nodoc
abstract mixin class $RecommendationDataCopyWith<$Res>  {
  factory $RecommendationDataCopyWith(RecommendationData value, $Res Function(RecommendationData) _then) = _$RecommendationDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'prediction_summary') PredictionSummary predictionSummary,@JsonKey(name: 'recommended_foods') List<FoodModel> recommendedFoods,@JsonKey(name: 'ai_support') AiSupportModel? aiSupport
});


$PredictionSummaryCopyWith<$Res> get predictionSummary;$AiSupportModelCopyWith<$Res>? get aiSupport;

}
/// @nodoc
class _$RecommendationDataCopyWithImpl<$Res>
    implements $RecommendationDataCopyWith<$Res> {
  _$RecommendationDataCopyWithImpl(this._self, this._then);

  final RecommendationData _self;
  final $Res Function(RecommendationData) _then;

/// Create a copy of RecommendationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? predictionSummary = null,Object? recommendedFoods = null,Object? aiSupport = freezed,}) {
  return _then(_self.copyWith(
predictionSummary: null == predictionSummary ? _self.predictionSummary : predictionSummary // ignore: cast_nullable_to_non_nullable
as PredictionSummary,recommendedFoods: null == recommendedFoods ? _self.recommendedFoods : recommendedFoods // ignore: cast_nullable_to_non_nullable
as List<FoodModel>,aiSupport: freezed == aiSupport ? _self.aiSupport : aiSupport // ignore: cast_nullable_to_non_nullable
as AiSupportModel?,
  ));
}
/// Create a copy of RecommendationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PredictionSummaryCopyWith<$Res> get predictionSummary {
  
  return $PredictionSummaryCopyWith<$Res>(_self.predictionSummary, (value) {
    return _then(_self.copyWith(predictionSummary: value));
  });
}/// Create a copy of RecommendationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiSupportModelCopyWith<$Res>? get aiSupport {
    if (_self.aiSupport == null) {
    return null;
  }

  return $AiSupportModelCopyWith<$Res>(_self.aiSupport!, (value) {
    return _then(_self.copyWith(aiSupport: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecommendationData].
extension RecommendationDataPatterns on RecommendationData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationData value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationData value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'prediction_summary')  PredictionSummary predictionSummary, @JsonKey(name: 'recommended_foods')  List<FoodModel> recommendedFoods, @JsonKey(name: 'ai_support')  AiSupportModel? aiSupport)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationData() when $default != null:
return $default(_that.predictionSummary,_that.recommendedFoods,_that.aiSupport);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'prediction_summary')  PredictionSummary predictionSummary, @JsonKey(name: 'recommended_foods')  List<FoodModel> recommendedFoods, @JsonKey(name: 'ai_support')  AiSupportModel? aiSupport)  $default,) {final _that = this;
switch (_that) {
case _RecommendationData():
return $default(_that.predictionSummary,_that.recommendedFoods,_that.aiSupport);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'prediction_summary')  PredictionSummary predictionSummary, @JsonKey(name: 'recommended_foods')  List<FoodModel> recommendedFoods, @JsonKey(name: 'ai_support')  AiSupportModel? aiSupport)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationData() when $default != null:
return $default(_that.predictionSummary,_that.recommendedFoods,_that.aiSupport);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecommendationData implements RecommendationData {
  const _RecommendationData({@JsonKey(name: 'prediction_summary') required this.predictionSummary, @JsonKey(name: 'recommended_foods') required final  List<FoodModel> recommendedFoods, @JsonKey(name: 'ai_support') this.aiSupport}): _recommendedFoods = recommendedFoods;
  factory _RecommendationData.fromJson(Map<String, dynamic> json) => _$RecommendationDataFromJson(json);

@override@JsonKey(name: 'prediction_summary') final  PredictionSummary predictionSummary;
 final  List<FoodModel> _recommendedFoods;
@override@JsonKey(name: 'recommended_foods') List<FoodModel> get recommendedFoods {
  if (_recommendedFoods is EqualUnmodifiableListView) return _recommendedFoods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendedFoods);
}

@override@JsonKey(name: 'ai_support') final  AiSupportModel? aiSupport;

/// Create a copy of RecommendationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationDataCopyWith<_RecommendationData> get copyWith => __$RecommendationDataCopyWithImpl<_RecommendationData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendationDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationData&&(identical(other.predictionSummary, predictionSummary) || other.predictionSummary == predictionSummary)&&const DeepCollectionEquality().equals(other._recommendedFoods, _recommendedFoods)&&(identical(other.aiSupport, aiSupport) || other.aiSupport == aiSupport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,predictionSummary,const DeepCollectionEquality().hash(_recommendedFoods),aiSupport);

@override
String toString() {
  return 'RecommendationData(predictionSummary: $predictionSummary, recommendedFoods: $recommendedFoods, aiSupport: $aiSupport)';
}


}

/// @nodoc
abstract mixin class _$RecommendationDataCopyWith<$Res> implements $RecommendationDataCopyWith<$Res> {
  factory _$RecommendationDataCopyWith(_RecommendationData value, $Res Function(_RecommendationData) _then) = __$RecommendationDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'prediction_summary') PredictionSummary predictionSummary,@JsonKey(name: 'recommended_foods') List<FoodModel> recommendedFoods,@JsonKey(name: 'ai_support') AiSupportModel? aiSupport
});


@override $PredictionSummaryCopyWith<$Res> get predictionSummary;@override $AiSupportModelCopyWith<$Res>? get aiSupport;

}
/// @nodoc
class __$RecommendationDataCopyWithImpl<$Res>
    implements _$RecommendationDataCopyWith<$Res> {
  __$RecommendationDataCopyWithImpl(this._self, this._then);

  final _RecommendationData _self;
  final $Res Function(_RecommendationData) _then;

/// Create a copy of RecommendationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? predictionSummary = null,Object? recommendedFoods = null,Object? aiSupport = freezed,}) {
  return _then(_RecommendationData(
predictionSummary: null == predictionSummary ? _self.predictionSummary : predictionSummary // ignore: cast_nullable_to_non_nullable
as PredictionSummary,recommendedFoods: null == recommendedFoods ? _self._recommendedFoods : recommendedFoods // ignore: cast_nullable_to_non_nullable
as List<FoodModel>,aiSupport: freezed == aiSupport ? _self.aiSupport : aiSupport // ignore: cast_nullable_to_non_nullable
as AiSupportModel?,
  ));
}

/// Create a copy of RecommendationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PredictionSummaryCopyWith<$Res> get predictionSummary {
  
  return $PredictionSummaryCopyWith<$Res>(_self.predictionSummary, (value) {
    return _then(_self.copyWith(predictionSummary: value));
  });
}/// Create a copy of RecommendationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiSupportModelCopyWith<$Res>? get aiSupport {
    if (_self.aiSupport == null) {
    return null;
  }

  return $AiSupportModelCopyWith<$Res>(_self.aiSupport!, (value) {
    return _then(_self.copyWith(aiSupport: value));
  });
}
}


/// @nodoc
mixin _$PredictionSummary {

@JsonKey(name: 'risk_label') String get riskLabel; double get probability;
/// Create a copy of PredictionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictionSummaryCopyWith<PredictionSummary> get copyWith => _$PredictionSummaryCopyWithImpl<PredictionSummary>(this as PredictionSummary, _$identity);

  /// Serializes this PredictionSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PredictionSummary&&(identical(other.riskLabel, riskLabel) || other.riskLabel == riskLabel)&&(identical(other.probability, probability) || other.probability == probability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,riskLabel,probability);

@override
String toString() {
  return 'PredictionSummary(riskLabel: $riskLabel, probability: $probability)';
}


}

/// @nodoc
abstract mixin class $PredictionSummaryCopyWith<$Res>  {
  factory $PredictionSummaryCopyWith(PredictionSummary value, $Res Function(PredictionSummary) _then) = _$PredictionSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'risk_label') String riskLabel, double probability
});




}
/// @nodoc
class _$PredictionSummaryCopyWithImpl<$Res>
    implements $PredictionSummaryCopyWith<$Res> {
  _$PredictionSummaryCopyWithImpl(this._self, this._then);

  final PredictionSummary _self;
  final $Res Function(PredictionSummary) _then;

/// Create a copy of PredictionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? riskLabel = null,Object? probability = null,}) {
  return _then(_self.copyWith(
riskLabel: null == riskLabel ? _self.riskLabel : riskLabel // ignore: cast_nullable_to_non_nullable
as String,probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PredictionSummary].
extension PredictionSummaryPatterns on PredictionSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PredictionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PredictionSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PredictionSummary value)  $default,){
final _that = this;
switch (_that) {
case _PredictionSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PredictionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PredictionSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'risk_label')  String riskLabel,  double probability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PredictionSummary() when $default != null:
return $default(_that.riskLabel,_that.probability);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'risk_label')  String riskLabel,  double probability)  $default,) {final _that = this;
switch (_that) {
case _PredictionSummary():
return $default(_that.riskLabel,_that.probability);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'risk_label')  String riskLabel,  double probability)?  $default,) {final _that = this;
switch (_that) {
case _PredictionSummary() when $default != null:
return $default(_that.riskLabel,_that.probability);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PredictionSummary implements PredictionSummary {
  const _PredictionSummary({@JsonKey(name: 'risk_label') required this.riskLabel, required this.probability});
  factory _PredictionSummary.fromJson(Map<String, dynamic> json) => _$PredictionSummaryFromJson(json);

@override@JsonKey(name: 'risk_label') final  String riskLabel;
@override final  double probability;

/// Create a copy of PredictionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictionSummaryCopyWith<_PredictionSummary> get copyWith => __$PredictionSummaryCopyWithImpl<_PredictionSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PredictionSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PredictionSummary&&(identical(other.riskLabel, riskLabel) || other.riskLabel == riskLabel)&&(identical(other.probability, probability) || other.probability == probability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,riskLabel,probability);

@override
String toString() {
  return 'PredictionSummary(riskLabel: $riskLabel, probability: $probability)';
}


}

/// @nodoc
abstract mixin class _$PredictionSummaryCopyWith<$Res> implements $PredictionSummaryCopyWith<$Res> {
  factory _$PredictionSummaryCopyWith(_PredictionSummary value, $Res Function(_PredictionSummary) _then) = __$PredictionSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'risk_label') String riskLabel, double probability
});




}
/// @nodoc
class __$PredictionSummaryCopyWithImpl<$Res>
    implements _$PredictionSummaryCopyWith<$Res> {
  __$PredictionSummaryCopyWithImpl(this._self, this._then);

  final _PredictionSummary _self;
  final $Res Function(_PredictionSummary) _then;

/// Create a copy of PredictionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? riskLabel = null,Object? probability = null,}) {
  return _then(_PredictionSummary(
riskLabel: null == riskLabel ? _self.riskLabel : riskLabel // ignore: cast_nullable_to_non_nullable
as String,probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$StuntingHistoryItem {

 int get id;@JsonKey(name: 'risk_label') String get riskLabel; double get probability;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of StuntingHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StuntingHistoryItemCopyWith<StuntingHistoryItem> get copyWith => _$StuntingHistoryItemCopyWithImpl<StuntingHistoryItem>(this as StuntingHistoryItem, _$identity);

  /// Serializes this StuntingHistoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StuntingHistoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.riskLabel, riskLabel) || other.riskLabel == riskLabel)&&(identical(other.probability, probability) || other.probability == probability)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,riskLabel,probability,createdAt);

@override
String toString() {
  return 'StuntingHistoryItem(id: $id, riskLabel: $riskLabel, probability: $probability, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StuntingHistoryItemCopyWith<$Res>  {
  factory $StuntingHistoryItemCopyWith(StuntingHistoryItem value, $Res Function(StuntingHistoryItem) _then) = _$StuntingHistoryItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'risk_label') String riskLabel, double probability,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$StuntingHistoryItemCopyWithImpl<$Res>
    implements $StuntingHistoryItemCopyWith<$Res> {
  _$StuntingHistoryItemCopyWithImpl(this._self, this._then);

  final StuntingHistoryItem _self;
  final $Res Function(StuntingHistoryItem) _then;

/// Create a copy of StuntingHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? riskLabel = null,Object? probability = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,riskLabel: null == riskLabel ? _self.riskLabel : riskLabel // ignore: cast_nullable_to_non_nullable
as String,probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StuntingHistoryItem].
extension StuntingHistoryItemPatterns on StuntingHistoryItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StuntingHistoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StuntingHistoryItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StuntingHistoryItem value)  $default,){
final _that = this;
switch (_that) {
case _StuntingHistoryItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StuntingHistoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _StuntingHistoryItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'risk_label')  String riskLabel,  double probability, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StuntingHistoryItem() when $default != null:
return $default(_that.id,_that.riskLabel,_that.probability,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'risk_label')  String riskLabel,  double probability, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _StuntingHistoryItem():
return $default(_that.id,_that.riskLabel,_that.probability,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'risk_label')  String riskLabel,  double probability, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StuntingHistoryItem() when $default != null:
return $default(_that.id,_that.riskLabel,_that.probability,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StuntingHistoryItem implements StuntingHistoryItem {
  const _StuntingHistoryItem({required this.id, @JsonKey(name: 'risk_label') required this.riskLabel, required this.probability, @JsonKey(name: 'created_at') required this.createdAt});
  factory _StuntingHistoryItem.fromJson(Map<String, dynamic> json) => _$StuntingHistoryItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'risk_label') final  String riskLabel;
@override final  double probability;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of StuntingHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StuntingHistoryItemCopyWith<_StuntingHistoryItem> get copyWith => __$StuntingHistoryItemCopyWithImpl<_StuntingHistoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StuntingHistoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StuntingHistoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.riskLabel, riskLabel) || other.riskLabel == riskLabel)&&(identical(other.probability, probability) || other.probability == probability)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,riskLabel,probability,createdAt);

@override
String toString() {
  return 'StuntingHistoryItem(id: $id, riskLabel: $riskLabel, probability: $probability, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StuntingHistoryItemCopyWith<$Res> implements $StuntingHistoryItemCopyWith<$Res> {
  factory _$StuntingHistoryItemCopyWith(_StuntingHistoryItem value, $Res Function(_StuntingHistoryItem) _then) = __$StuntingHistoryItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'risk_label') String riskLabel, double probability,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$StuntingHistoryItemCopyWithImpl<$Res>
    implements _$StuntingHistoryItemCopyWith<$Res> {
  __$StuntingHistoryItemCopyWithImpl(this._self, this._then);

  final _StuntingHistoryItem _self;
  final $Res Function(_StuntingHistoryItem) _then;

/// Create a copy of StuntingHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? riskLabel = null,Object? probability = null,Object? createdAt = null,}) {
  return _then(_StuntingHistoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,riskLabel: null == riskLabel ? _self.riskLabel : riskLabel // ignore: cast_nullable_to_non_nullable
as String,probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
