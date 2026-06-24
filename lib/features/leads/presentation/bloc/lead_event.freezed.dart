// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeadEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LeadEvent()';
}


}

/// @nodoc
class $LeadEventCopyWith<$Res>  {
$LeadEventCopyWith(LeadEvent _, $Res Function(LeadEvent) __);
}


/// Adds pattern-matching-related methods to [LeadEvent].
extension LeadEventPatterns on LeadEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( FetchLeads value)?  fetchLeads,TResult Function( AddLead value)?  addLead,TResult Function( UpdateLead value)?  updateLead,TResult Function( DeleteLead value)?  deleteLead,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case FetchLeads() when fetchLeads != null:
return fetchLeads(_that);case AddLead() when addLead != null:
return addLead(_that);case UpdateLead() when updateLead != null:
return updateLead(_that);case DeleteLead() when deleteLead != null:
return deleteLead(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( FetchLeads value)  fetchLeads,required TResult Function( AddLead value)  addLead,required TResult Function( UpdateLead value)  updateLead,required TResult Function( DeleteLead value)  deleteLead,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case FetchLeads():
return fetchLeads(_that);case AddLead():
return addLead(_that);case UpdateLead():
return updateLead(_that);case DeleteLead():
return deleteLead(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( FetchLeads value)?  fetchLeads,TResult? Function( AddLead value)?  addLead,TResult? Function( UpdateLead value)?  updateLead,TResult? Function( DeleteLead value)?  deleteLead,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case FetchLeads() when fetchLeads != null:
return fetchLeads(_that);case AddLead() when addLead != null:
return addLead(_that);case UpdateLead() when updateLead != null:
return updateLead(_that);case DeleteLead() when deleteLead != null:
return deleteLead(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String? stage,  String? assignedToId,  int skip,  int limit)?  fetchLeads,TResult Function( Map<String, dynamic> data)?  addLead,TResult Function( String id,  Map<String, dynamic> data)?  updateLead,TResult Function( String id)?  deleteLead,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case FetchLeads() when fetchLeads != null:
return fetchLeads(_that.stage,_that.assignedToId,_that.skip,_that.limit);case AddLead() when addLead != null:
return addLead(_that.data);case UpdateLead() when updateLead != null:
return updateLead(_that.id,_that.data);case DeleteLead() when deleteLead != null:
return deleteLead(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String? stage,  String? assignedToId,  int skip,  int limit)  fetchLeads,required TResult Function( Map<String, dynamic> data)  addLead,required TResult Function( String id,  Map<String, dynamic> data)  updateLead,required TResult Function( String id)  deleteLead,}) {final _that = this;
switch (_that) {
case _Started():
return started();case FetchLeads():
return fetchLeads(_that.stage,_that.assignedToId,_that.skip,_that.limit);case AddLead():
return addLead(_that.data);case UpdateLead():
return updateLead(_that.id,_that.data);case DeleteLead():
return deleteLead(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String? stage,  String? assignedToId,  int skip,  int limit)?  fetchLeads,TResult? Function( Map<String, dynamic> data)?  addLead,TResult? Function( String id,  Map<String, dynamic> data)?  updateLead,TResult? Function( String id)?  deleteLead,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case FetchLeads() when fetchLeads != null:
return fetchLeads(_that.stage,_that.assignedToId,_that.skip,_that.limit);case AddLead() when addLead != null:
return addLead(_that.data);case UpdateLead() when updateLead != null:
return updateLead(_that.id,_that.data);case DeleteLead() when deleteLead != null:
return deleteLead(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements LeadEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LeadEvent.started()';
}


}




/// @nodoc


class FetchLeads implements LeadEvent {
  const FetchLeads({this.stage, this.assignedToId, this.skip = 0, this.limit = 10});
  

 final  String? stage;
 final  String? assignedToId;
@JsonKey() final  int skip;
@JsonKey() final  int limit;

/// Create a copy of LeadEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchLeadsCopyWith<FetchLeads> get copyWith => _$FetchLeadsCopyWithImpl<FetchLeads>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchLeads&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.assignedToId, assignedToId) || other.assignedToId == assignedToId)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,stage,assignedToId,skip,limit);

@override
String toString() {
  return 'LeadEvent.fetchLeads(stage: $stage, assignedToId: $assignedToId, skip: $skip, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $FetchLeadsCopyWith<$Res> implements $LeadEventCopyWith<$Res> {
  factory $FetchLeadsCopyWith(FetchLeads value, $Res Function(FetchLeads) _then) = _$FetchLeadsCopyWithImpl;
@useResult
$Res call({
 String? stage, String? assignedToId, int skip, int limit
});




}
/// @nodoc
class _$FetchLeadsCopyWithImpl<$Res>
    implements $FetchLeadsCopyWith<$Res> {
  _$FetchLeadsCopyWithImpl(this._self, this._then);

  final FetchLeads _self;
  final $Res Function(FetchLeads) _then;

/// Create a copy of LeadEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stage = freezed,Object? assignedToId = freezed,Object? skip = null,Object? limit = null,}) {
  return _then(FetchLeads(
stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,assignedToId: freezed == assignedToId ? _self.assignedToId : assignedToId // ignore: cast_nullable_to_non_nullable
as String?,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class AddLead implements LeadEvent {
  const AddLead( Map<String, dynamic> data): _data = data;
  

 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of LeadEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddLeadCopyWith<AddLead> get copyWith => _$AddLeadCopyWithImpl<AddLead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddLead&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'LeadEvent.addLead(data: $data)';
}


}

/// @nodoc
abstract mixin class $AddLeadCopyWith<$Res> implements $LeadEventCopyWith<$Res> {
  factory $AddLeadCopyWith(AddLead value, $Res Function(AddLead) _then) = _$AddLeadCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class _$AddLeadCopyWithImpl<$Res>
    implements $AddLeadCopyWith<$Res> {
  _$AddLeadCopyWithImpl(this._self, this._then);

  final AddLead _self;
  final $Res Function(AddLead) _then;

/// Create a copy of LeadEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(AddLead(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc


class UpdateLead implements LeadEvent {
  const UpdateLead(this.id,  Map<String, dynamic> data): _data = data;
  

 final  String id;
 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of LeadEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateLeadCopyWith<UpdateLead> get copyWith => _$UpdateLeadCopyWithImpl<UpdateLead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateLead&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'LeadEvent.updateLead(id: $id, data: $data)';
}


}

/// @nodoc
abstract mixin class $UpdateLeadCopyWith<$Res> implements $LeadEventCopyWith<$Res> {
  factory $UpdateLeadCopyWith(UpdateLead value, $Res Function(UpdateLead) _then) = _$UpdateLeadCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, dynamic> data
});




}
/// @nodoc
class _$UpdateLeadCopyWithImpl<$Res>
    implements $UpdateLeadCopyWith<$Res> {
  _$UpdateLeadCopyWithImpl(this._self, this._then);

  final UpdateLead _self;
  final $Res Function(UpdateLead) _then;

/// Create a copy of LeadEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? data = null,}) {
  return _then(UpdateLead(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc


class DeleteLead implements LeadEvent {
  const DeleteLead(this.id);
  

 final  String id;

/// Create a copy of LeadEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteLeadCopyWith<DeleteLead> get copyWith => _$DeleteLeadCopyWithImpl<DeleteLead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteLead&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'LeadEvent.deleteLead(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeleteLeadCopyWith<$Res> implements $LeadEventCopyWith<$Res> {
  factory $DeleteLeadCopyWith(DeleteLead value, $Res Function(DeleteLead) _then) = _$DeleteLeadCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DeleteLeadCopyWithImpl<$Res>
    implements $DeleteLeadCopyWith<$Res> {
  _$DeleteLeadCopyWithImpl(this._self, this._then);

  final DeleteLead _self;
  final $Res Function(DeleteLead) _then;

/// Create a copy of LeadEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DeleteLead(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
