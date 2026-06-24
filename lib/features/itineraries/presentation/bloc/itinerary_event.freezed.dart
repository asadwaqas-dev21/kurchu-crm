// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ItineraryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItineraryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ItineraryEvent()';
}


}

/// @nodoc
class $ItineraryEventCopyWith<$Res>  {
$ItineraryEventCopyWith(ItineraryEvent _, $Res Function(ItineraryEvent) __);
}


/// Adds pattern-matching-related methods to [ItineraryEvent].
extension ItineraryEventPatterns on ItineraryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( FetchItineraries value)?  fetchItineraries,TResult Function( AddItinerary value)?  addItinerary,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case FetchItineraries() when fetchItineraries != null:
return fetchItineraries(_that);case AddItinerary() when addItinerary != null:
return addItinerary(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( FetchItineraries value)  fetchItineraries,required TResult Function( AddItinerary value)  addItinerary,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case FetchItineraries():
return fetchItineraries(_that);case AddItinerary():
return addItinerary(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( FetchItineraries value)?  fetchItineraries,TResult? Function( AddItinerary value)?  addItinerary,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case FetchItineraries() when fetchItineraries != null:
return fetchItineraries(_that);case AddItinerary() when addItinerary != null:
return addItinerary(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String? leadId,  String? bookingId)?  fetchItineraries,TResult Function( Map<String, dynamic> data)?  addItinerary,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case FetchItineraries() when fetchItineraries != null:
return fetchItineraries(_that.leadId,_that.bookingId);case AddItinerary() when addItinerary != null:
return addItinerary(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String? leadId,  String? bookingId)  fetchItineraries,required TResult Function( Map<String, dynamic> data)  addItinerary,}) {final _that = this;
switch (_that) {
case _Started():
return started();case FetchItineraries():
return fetchItineraries(_that.leadId,_that.bookingId);case AddItinerary():
return addItinerary(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String? leadId,  String? bookingId)?  fetchItineraries,TResult? Function( Map<String, dynamic> data)?  addItinerary,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case FetchItineraries() when fetchItineraries != null:
return fetchItineraries(_that.leadId,_that.bookingId);case AddItinerary() when addItinerary != null:
return addItinerary(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ItineraryEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ItineraryEvent.started()';
}


}




/// @nodoc


class FetchItineraries implements ItineraryEvent {
  const FetchItineraries({this.leadId, this.bookingId});
  

 final  String? leadId;
 final  String? bookingId;

/// Create a copy of ItineraryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchItinerariesCopyWith<FetchItineraries> get copyWith => _$FetchItinerariesCopyWithImpl<FetchItineraries>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchItineraries&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId));
}


@override
int get hashCode => Object.hash(runtimeType,leadId,bookingId);

@override
String toString() {
  return 'ItineraryEvent.fetchItineraries(leadId: $leadId, bookingId: $bookingId)';
}


}

/// @nodoc
abstract mixin class $FetchItinerariesCopyWith<$Res> implements $ItineraryEventCopyWith<$Res> {
  factory $FetchItinerariesCopyWith(FetchItineraries value, $Res Function(FetchItineraries) _then) = _$FetchItinerariesCopyWithImpl;
@useResult
$Res call({
 String? leadId, String? bookingId
});




}
/// @nodoc
class _$FetchItinerariesCopyWithImpl<$Res>
    implements $FetchItinerariesCopyWith<$Res> {
  _$FetchItinerariesCopyWithImpl(this._self, this._then);

  final FetchItineraries _self;
  final $Res Function(FetchItineraries) _then;

/// Create a copy of ItineraryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? leadId = freezed,Object? bookingId = freezed,}) {
  return _then(FetchItineraries(
leadId: freezed == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String?,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AddItinerary implements ItineraryEvent {
  const AddItinerary( Map<String, dynamic> data): _data = data;
  

 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of ItineraryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddItineraryCopyWith<AddItinerary> get copyWith => _$AddItineraryCopyWithImpl<AddItinerary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItinerary&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ItineraryEvent.addItinerary(data: $data)';
}


}

/// @nodoc
abstract mixin class $AddItineraryCopyWith<$Res> implements $ItineraryEventCopyWith<$Res> {
  factory $AddItineraryCopyWith(AddItinerary value, $Res Function(AddItinerary) _then) = _$AddItineraryCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class _$AddItineraryCopyWithImpl<$Res>
    implements $AddItineraryCopyWith<$Res> {
  _$AddItineraryCopyWithImpl(this._self, this._then);

  final AddItinerary _self;
  final $Res Function(AddItinerary) _then;

/// Create a copy of ItineraryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(AddItinerary(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
