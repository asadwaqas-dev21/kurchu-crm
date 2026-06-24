// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_up_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FollowUpEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowUpEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FollowUpEvent()';
}


}

/// @nodoc
class $FollowUpEventCopyWith<$Res>  {
$FollowUpEventCopyWith(FollowUpEvent _, $Res Function(FollowUpEvent) __);
}


/// Adds pattern-matching-related methods to [FollowUpEvent].
extension FollowUpEventPatterns on FollowUpEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( FetchFollowUps value)?  fetchFollowUps,TResult Function( AddFollowUp value)?  addFollowUp,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case FetchFollowUps() when fetchFollowUps != null:
return fetchFollowUps(_that);case AddFollowUp() when addFollowUp != null:
return addFollowUp(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( FetchFollowUps value)  fetchFollowUps,required TResult Function( AddFollowUp value)  addFollowUp,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case FetchFollowUps():
return fetchFollowUps(_that);case AddFollowUp():
return addFollowUp(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( FetchFollowUps value)?  fetchFollowUps,TResult? Function( AddFollowUp value)?  addFollowUp,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case FetchFollowUps() when fetchFollowUps != null:
return fetchFollowUps(_that);case AddFollowUp() when addFollowUp != null:
return addFollowUp(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( bool? isCompleted)?  fetchFollowUps,TResult Function( Map<String, dynamic> data)?  addFollowUp,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case FetchFollowUps() when fetchFollowUps != null:
return fetchFollowUps(_that.isCompleted);case AddFollowUp() when addFollowUp != null:
return addFollowUp(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( bool? isCompleted)  fetchFollowUps,required TResult Function( Map<String, dynamic> data)  addFollowUp,}) {final _that = this;
switch (_that) {
case _Started():
return started();case FetchFollowUps():
return fetchFollowUps(_that.isCompleted);case AddFollowUp():
return addFollowUp(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( bool? isCompleted)?  fetchFollowUps,TResult? Function( Map<String, dynamic> data)?  addFollowUp,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case FetchFollowUps() when fetchFollowUps != null:
return fetchFollowUps(_that.isCompleted);case AddFollowUp() when addFollowUp != null:
return addFollowUp(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements FollowUpEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FollowUpEvent.started()';
}


}




/// @nodoc


class FetchFollowUps implements FollowUpEvent {
  const FetchFollowUps({this.isCompleted});
  

 final  bool? isCompleted;

/// Create a copy of FollowUpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchFollowUpsCopyWith<FetchFollowUps> get copyWith => _$FetchFollowUpsCopyWithImpl<FetchFollowUps>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchFollowUps&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,isCompleted);

@override
String toString() {
  return 'FollowUpEvent.fetchFollowUps(isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $FetchFollowUpsCopyWith<$Res> implements $FollowUpEventCopyWith<$Res> {
  factory $FetchFollowUpsCopyWith(FetchFollowUps value, $Res Function(FetchFollowUps) _then) = _$FetchFollowUpsCopyWithImpl;
@useResult
$Res call({
 bool? isCompleted
});




}
/// @nodoc
class _$FetchFollowUpsCopyWithImpl<$Res>
    implements $FetchFollowUpsCopyWith<$Res> {
  _$FetchFollowUpsCopyWithImpl(this._self, this._then);

  final FetchFollowUps _self;
  final $Res Function(FetchFollowUps) _then;

/// Create a copy of FollowUpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isCompleted = freezed,}) {
  return _then(FetchFollowUps(
isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc


class AddFollowUp implements FollowUpEvent {
  const AddFollowUp( Map<String, dynamic> data): _data = data;
  

 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of FollowUpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddFollowUpCopyWith<AddFollowUp> get copyWith => _$AddFollowUpCopyWithImpl<AddFollowUp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddFollowUp&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'FollowUpEvent.addFollowUp(data: $data)';
}


}

/// @nodoc
abstract mixin class $AddFollowUpCopyWith<$Res> implements $FollowUpEventCopyWith<$Res> {
  factory $AddFollowUpCopyWith(AddFollowUp value, $Res Function(AddFollowUp) _then) = _$AddFollowUpCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class _$AddFollowUpCopyWithImpl<$Res>
    implements $AddFollowUpCopyWith<$Res> {
  _$AddFollowUpCopyWithImpl(this._self, this._then);

  final AddFollowUp _self;
  final $Res Function(AddFollowUp) _then;

/// Create a copy of FollowUpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(AddFollowUp(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
