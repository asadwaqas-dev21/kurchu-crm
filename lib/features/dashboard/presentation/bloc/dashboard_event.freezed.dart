// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardEvent()';
}


}

/// @nodoc
class $DashboardEventCopyWith<$Res>  {
$DashboardEventCopyWith(DashboardEvent _, $Res Function(DashboardEvent) __);
}


/// Adds pattern-matching-related methods to [DashboardEvent].
extension DashboardEventPatterns on DashboardEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MetricsFetched value)?  metricsFetched,TResult Function( AlertsFetched value)?  alertsFetched,TResult Function( RefreshRequested value)?  refreshRequested,TResult Function( AlertMarkedAsRead value)?  alertMarkedAsRead,TResult Function( WebSocketConnected value)?  webSocketConnected,TResult Function( MetricsUpdatedFromWebSocket value)?  metricsUpdatedFromWebSocket,TResult Function( AlertReceivedFromWebSocket value)?  alertReceivedFromWebSocket,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MetricsFetched() when metricsFetched != null:
return metricsFetched(_that);case AlertsFetched() when alertsFetched != null:
return alertsFetched(_that);case RefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case AlertMarkedAsRead() when alertMarkedAsRead != null:
return alertMarkedAsRead(_that);case WebSocketConnected() when webSocketConnected != null:
return webSocketConnected(_that);case MetricsUpdatedFromWebSocket() when metricsUpdatedFromWebSocket != null:
return metricsUpdatedFromWebSocket(_that);case AlertReceivedFromWebSocket() when alertReceivedFromWebSocket != null:
return alertReceivedFromWebSocket(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MetricsFetched value)  metricsFetched,required TResult Function( AlertsFetched value)  alertsFetched,required TResult Function( RefreshRequested value)  refreshRequested,required TResult Function( AlertMarkedAsRead value)  alertMarkedAsRead,required TResult Function( WebSocketConnected value)  webSocketConnected,required TResult Function( MetricsUpdatedFromWebSocket value)  metricsUpdatedFromWebSocket,required TResult Function( AlertReceivedFromWebSocket value)  alertReceivedFromWebSocket,}){
final _that = this;
switch (_that) {
case MetricsFetched():
return metricsFetched(_that);case AlertsFetched():
return alertsFetched(_that);case RefreshRequested():
return refreshRequested(_that);case AlertMarkedAsRead():
return alertMarkedAsRead(_that);case WebSocketConnected():
return webSocketConnected(_that);case MetricsUpdatedFromWebSocket():
return metricsUpdatedFromWebSocket(_that);case AlertReceivedFromWebSocket():
return alertReceivedFromWebSocket(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MetricsFetched value)?  metricsFetched,TResult? Function( AlertsFetched value)?  alertsFetched,TResult? Function( RefreshRequested value)?  refreshRequested,TResult? Function( AlertMarkedAsRead value)?  alertMarkedAsRead,TResult? Function( WebSocketConnected value)?  webSocketConnected,TResult? Function( MetricsUpdatedFromWebSocket value)?  metricsUpdatedFromWebSocket,TResult? Function( AlertReceivedFromWebSocket value)?  alertReceivedFromWebSocket,}){
final _that = this;
switch (_that) {
case MetricsFetched() when metricsFetched != null:
return metricsFetched(_that);case AlertsFetched() when alertsFetched != null:
return alertsFetched(_that);case RefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case AlertMarkedAsRead() when alertMarkedAsRead != null:
return alertMarkedAsRead(_that);case WebSocketConnected() when webSocketConnected != null:
return webSocketConnected(_that);case MetricsUpdatedFromWebSocket() when metricsUpdatedFromWebSocket != null:
return metricsUpdatedFromWebSocket(_that);case AlertReceivedFromWebSocket() when alertReceivedFromWebSocket != null:
return alertReceivedFromWebSocket(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  metricsFetched,TResult Function()?  alertsFetched,TResult Function()?  refreshRequested,TResult Function( String alertId)?  alertMarkedAsRead,TResult Function()?  webSocketConnected,TResult Function( Map<String, dynamic> data)?  metricsUpdatedFromWebSocket,TResult Function( Map<String, dynamic> data)?  alertReceivedFromWebSocket,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MetricsFetched() when metricsFetched != null:
return metricsFetched();case AlertsFetched() when alertsFetched != null:
return alertsFetched();case RefreshRequested() when refreshRequested != null:
return refreshRequested();case AlertMarkedAsRead() when alertMarkedAsRead != null:
return alertMarkedAsRead(_that.alertId);case WebSocketConnected() when webSocketConnected != null:
return webSocketConnected();case MetricsUpdatedFromWebSocket() when metricsUpdatedFromWebSocket != null:
return metricsUpdatedFromWebSocket(_that.data);case AlertReceivedFromWebSocket() when alertReceivedFromWebSocket != null:
return alertReceivedFromWebSocket(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  metricsFetched,required TResult Function()  alertsFetched,required TResult Function()  refreshRequested,required TResult Function( String alertId)  alertMarkedAsRead,required TResult Function()  webSocketConnected,required TResult Function( Map<String, dynamic> data)  metricsUpdatedFromWebSocket,required TResult Function( Map<String, dynamic> data)  alertReceivedFromWebSocket,}) {final _that = this;
switch (_that) {
case MetricsFetched():
return metricsFetched();case AlertsFetched():
return alertsFetched();case RefreshRequested():
return refreshRequested();case AlertMarkedAsRead():
return alertMarkedAsRead(_that.alertId);case WebSocketConnected():
return webSocketConnected();case MetricsUpdatedFromWebSocket():
return metricsUpdatedFromWebSocket(_that.data);case AlertReceivedFromWebSocket():
return alertReceivedFromWebSocket(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  metricsFetched,TResult? Function()?  alertsFetched,TResult? Function()?  refreshRequested,TResult? Function( String alertId)?  alertMarkedAsRead,TResult? Function()?  webSocketConnected,TResult? Function( Map<String, dynamic> data)?  metricsUpdatedFromWebSocket,TResult? Function( Map<String, dynamic> data)?  alertReceivedFromWebSocket,}) {final _that = this;
switch (_that) {
case MetricsFetched() when metricsFetched != null:
return metricsFetched();case AlertsFetched() when alertsFetched != null:
return alertsFetched();case RefreshRequested() when refreshRequested != null:
return refreshRequested();case AlertMarkedAsRead() when alertMarkedAsRead != null:
return alertMarkedAsRead(_that.alertId);case WebSocketConnected() when webSocketConnected != null:
return webSocketConnected();case MetricsUpdatedFromWebSocket() when metricsUpdatedFromWebSocket != null:
return metricsUpdatedFromWebSocket(_that.data);case AlertReceivedFromWebSocket() when alertReceivedFromWebSocket != null:
return alertReceivedFromWebSocket(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class MetricsFetched implements DashboardEvent {
  const MetricsFetched();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetricsFetched);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardEvent.metricsFetched()';
}


}




/// @nodoc


class AlertsFetched implements DashboardEvent {
  const AlertsFetched();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertsFetched);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardEvent.alertsFetched()';
}


}




/// @nodoc


class RefreshRequested implements DashboardEvent {
  const RefreshRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardEvent.refreshRequested()';
}


}




/// @nodoc


class AlertMarkedAsRead implements DashboardEvent {
  const AlertMarkedAsRead(this.alertId);
  

 final  String alertId;

/// Create a copy of DashboardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertMarkedAsReadCopyWith<AlertMarkedAsRead> get copyWith => _$AlertMarkedAsReadCopyWithImpl<AlertMarkedAsRead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertMarkedAsRead&&(identical(other.alertId, alertId) || other.alertId == alertId));
}


@override
int get hashCode => Object.hash(runtimeType,alertId);

@override
String toString() {
  return 'DashboardEvent.alertMarkedAsRead(alertId: $alertId)';
}


}

/// @nodoc
abstract mixin class $AlertMarkedAsReadCopyWith<$Res> implements $DashboardEventCopyWith<$Res> {
  factory $AlertMarkedAsReadCopyWith(AlertMarkedAsRead value, $Res Function(AlertMarkedAsRead) _then) = _$AlertMarkedAsReadCopyWithImpl;
@useResult
$Res call({
 String alertId
});




}
/// @nodoc
class _$AlertMarkedAsReadCopyWithImpl<$Res>
    implements $AlertMarkedAsReadCopyWith<$Res> {
  _$AlertMarkedAsReadCopyWithImpl(this._self, this._then);

  final AlertMarkedAsRead _self;
  final $Res Function(AlertMarkedAsRead) _then;

/// Create a copy of DashboardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? alertId = null,}) {
  return _then(AlertMarkedAsRead(
null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WebSocketConnected implements DashboardEvent {
  const WebSocketConnected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebSocketConnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardEvent.webSocketConnected()';
}


}




/// @nodoc


class MetricsUpdatedFromWebSocket implements DashboardEvent {
  const MetricsUpdatedFromWebSocket( Map<String, dynamic> data): _data = data;
  

 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of DashboardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetricsUpdatedFromWebSocketCopyWith<MetricsUpdatedFromWebSocket> get copyWith => _$MetricsUpdatedFromWebSocketCopyWithImpl<MetricsUpdatedFromWebSocket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetricsUpdatedFromWebSocket&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'DashboardEvent.metricsUpdatedFromWebSocket(data: $data)';
}


}

/// @nodoc
abstract mixin class $MetricsUpdatedFromWebSocketCopyWith<$Res> implements $DashboardEventCopyWith<$Res> {
  factory $MetricsUpdatedFromWebSocketCopyWith(MetricsUpdatedFromWebSocket value, $Res Function(MetricsUpdatedFromWebSocket) _then) = _$MetricsUpdatedFromWebSocketCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class _$MetricsUpdatedFromWebSocketCopyWithImpl<$Res>
    implements $MetricsUpdatedFromWebSocketCopyWith<$Res> {
  _$MetricsUpdatedFromWebSocketCopyWithImpl(this._self, this._then);

  final MetricsUpdatedFromWebSocket _self;
  final $Res Function(MetricsUpdatedFromWebSocket) _then;

/// Create a copy of DashboardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(MetricsUpdatedFromWebSocket(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc


class AlertReceivedFromWebSocket implements DashboardEvent {
  const AlertReceivedFromWebSocket( Map<String, dynamic> data): _data = data;
  

 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of DashboardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertReceivedFromWebSocketCopyWith<AlertReceivedFromWebSocket> get copyWith => _$AlertReceivedFromWebSocketCopyWithImpl<AlertReceivedFromWebSocket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertReceivedFromWebSocket&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'DashboardEvent.alertReceivedFromWebSocket(data: $data)';
}


}

/// @nodoc
abstract mixin class $AlertReceivedFromWebSocketCopyWith<$Res> implements $DashboardEventCopyWith<$Res> {
  factory $AlertReceivedFromWebSocketCopyWith(AlertReceivedFromWebSocket value, $Res Function(AlertReceivedFromWebSocket) _then) = _$AlertReceivedFromWebSocketCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class _$AlertReceivedFromWebSocketCopyWithImpl<$Res>
    implements $AlertReceivedFromWebSocketCopyWith<$Res> {
  _$AlertReceivedFromWebSocketCopyWithImpl(this._self, this._then);

  final AlertReceivedFromWebSocket _self;
  final $Res Function(AlertReceivedFromWebSocket) _then;

/// Create a copy of DashboardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(AlertReceivedFromWebSocket(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
