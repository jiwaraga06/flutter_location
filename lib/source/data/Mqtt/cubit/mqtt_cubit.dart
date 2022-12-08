import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mqtt_state.dart';

class MqttCubit extends Cubit<MqttState> {
  final MyReposity? myReposity;
  MqttCubit({required this.myReposity}) : super(MqttInitial());
  final builder = MqttClientPayloadBuilder();
  void onConnected() {
    print('connected');
  }

  void onDisconnected() {
    print('disconnected');
  }

  void onSubscribed(String topic) {
    // print('subscribed to $topic');
  }

  void onSubscribeFail(String topic) {
    // print('failed to subscribe to $topic');
  }

  void on() {
    print('disconnected');
  }

  void pong() {
    // print('ping response arrived');
  }

  Future<MqttServerClient> connect() async {
    int random = Random().nextInt(100000);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var name = '${pref.getString('nama')}_${random}';
    MqttServerClient client = MqttServerClient.withPort(
      'mq01.sipatex.co.id',
      name,
      8838,
    );
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    // client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.secure = true;

    final connMessage = MqttConnectMessage()
        .authenticateAs('it', 'it1234')
        .withWillTopic('Will Topics')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      // print('Received message: $message');
      // print('Received message pay: $payload from topic: ${c[0].topic}>');
    if(c[0].topic == '/2022/Majalaya/Security/News1'){
      var data = payload.toString();
      // print('Data: $data');
      emit(MqttMessageLoad(message: data));
    }
    });
    client.subscribe("/2022/Majalaya/Security/News1", MqttQos.atMostOnce);
    // builder.addString('Hello Tester');
    // client.publishMessage('/2022/Majalaya/Security/News1', MqttQos.atMostOnce, builder.payload!);
    return client;
  }

  Future<MqttServerClient> send(message) async {
    int random = Random().nextInt(100000);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var name = '${pref.getString('nama')}_${random}';
    MqttServerClient client = MqttServerClient.withPort(
      'mq01.sipatex.co.id',
      name,
      8838,
    );
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    // client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.secure = true;

    final connMessage = MqttConnectMessage()
        .authenticateAs('it', 'it1234')
        .withWillTopic('Will Topics')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      // print('Received message: $message');
      // print('Received message pay: $payload from topic: ${c[0].topic}>');
    });
    builder.addString('[${name}] $message');
    client.publishMessage('/2022/Majalaya/Security/News1', MqttQos.atMostOnce, builder.payload!, retain: true);
    return client;
  }
}
