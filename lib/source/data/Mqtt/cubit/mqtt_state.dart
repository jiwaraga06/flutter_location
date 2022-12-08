part of 'mqtt_cubit.dart';

@immutable
abstract class MqttState {}

class MqttInitial extends MqttState {}
class MqttMessageLoad extends MqttState {
  final String? message;

  MqttMessageLoad({this.message});
}
