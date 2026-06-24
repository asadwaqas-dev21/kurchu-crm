// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookingEvent()';
}


}

/// @nodoc
class $BookingEventCopyWith<$Res>  {
$BookingEventCopyWith(BookingEvent _, $Res Function(BookingEvent) __);
}


/// Adds pattern-matching-related methods to [BookingEvent].
extension BookingEventPatterns on BookingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( FetchBookings value)?  fetchBookings,TResult Function( AddBooking value)?  addBooking,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case FetchBookings() when fetchBookings != null:
return fetchBookings(_that);case AddBooking() when addBooking != null:
return addBooking(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( FetchBookings value)  fetchBookings,required TResult Function( AddBooking value)  addBooking,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case FetchBookings():
return fetchBookings(_that);case AddBooking():
return addBooking(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( FetchBookings value)?  fetchBookings,TResult? Function( AddBooking value)?  addBooking,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case FetchBookings() when fetchBookings != null:
return fetchBookings(_that);case AddBooking() when addBooking != null:
return addBooking(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String? status,  String? leadId)?  fetchBookings,TResult Function( Map<String, dynamic> data)?  addBooking,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case FetchBookings() when fetchBookings != null:
return fetchBookings(_that.status,_that.leadId);case AddBooking() when addBooking != null:
return addBooking(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String? status,  String? leadId)  fetchBookings,required TResult Function( Map<String, dynamic> data)  addBooking,}) {final _that = this;
switch (_that) {
case _Started():
return started();case FetchBookings():
return fetchBookings(_that.status,_that.leadId);case AddBooking():
return addBooking(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String? status,  String? leadId)?  fetchBookings,TResult? Function( Map<String, dynamic> data)?  addBooking,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case FetchBookings() when fetchBookings != null:
return fetchBookings(_that.status,_that.leadId);case AddBooking() when addBooking != null:
return addBooking(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements BookingEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookingEvent.started()';
}


}




/// @nodoc


class FetchBookings implements BookingEvent {
  const FetchBookings({this.status, this.leadId});
  

 final  String? status;
 final  String? leadId;

/// Create a copy of BookingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchBookingsCopyWith<FetchBookings> get copyWith => _$FetchBookingsCopyWithImpl<FetchBookings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchBookings&&(identical(other.status, status) || other.status == status)&&(identical(other.leadId, leadId) || other.leadId == leadId));
}


@override
int get hashCode => Object.hash(runtimeType,status,leadId);

@override
String toString() {
  return 'BookingEvent.fetchBookings(status: $status, leadId: $leadId)';
}


}

/// @nodoc
abstract mixin class $FetchBookingsCopyWith<$Res> implements $BookingEventCopyWith<$Res> {
  factory $FetchBookingsCopyWith(FetchBookings value, $Res Function(FetchBookings) _then) = _$FetchBookingsCopyWithImpl;
@useResult
$Res call({
 String? status, String? leadId
});




}
/// @nodoc
class _$FetchBookingsCopyWithImpl<$Res>
    implements $FetchBookingsCopyWith<$Res> {
  _$FetchBookingsCopyWithImpl(this._self, this._then);

  final FetchBookings _self;
  final $Res Function(FetchBookings) _then;

/// Create a copy of BookingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? leadId = freezed,}) {
  return _then(FetchBookings(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,leadId: freezed == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AddBooking implements BookingEvent {
  const AddBooking( Map<String, dynamic> data): _data = data;
  

 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of BookingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddBookingCopyWith<AddBooking> get copyWith => _$AddBookingCopyWithImpl<AddBooking>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddBooking&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'BookingEvent.addBooking(data: $data)';
}


}

/// @nodoc
abstract mixin class $AddBookingCopyWith<$Res> implements $BookingEventCopyWith<$Res> {
  factory $AddBookingCopyWith(AddBooking value, $Res Function(AddBooking) _then) = _$AddBookingCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class _$AddBookingCopyWithImpl<$Res>
    implements $AddBookingCopyWith<$Res> {
  _$AddBookingCopyWithImpl(this._self, this._then);

  final AddBooking _self;
  final $Res Function(AddBooking) _then;

/// Create a copy of BookingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(AddBooking(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
