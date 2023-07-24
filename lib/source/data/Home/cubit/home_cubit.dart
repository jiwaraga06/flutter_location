import 'package:bloc/bloc.dart';
import 'package:flutter_location/source/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MyReposity? myReposity;
  HomeCubit({required this.myReposity}) : super(HomeInitial());

  // STATUS SAJA
  //SOCKet IO CLIENT
  IO.Socket socket = IO.io('https://api2.sipatex.co.id:2053', <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false
  });

  void connectSocket() {
    socket.connect();
    socket.on('connecting', (data) {
      emit(HomeLoaded(status: 'connecting', statusCode: 0));
      print("connecting home");
      print(data);
    });
    socket.on('connect', (data) {
      emit(HomeLoaded(status: 'connected', statusCode: 1));
      print("connect home");
      print(data);
    });
    socket.on('connect_error', (data) {
      emit(HomeLoaded(status: 'connect error', statusCode: 2));
      print("connect error home");
      print(data);
    });
    socket.on('disconnect', (data) {
      emit(HomeLoaded(status: 'disconnect', statusCode: 3));
      print("disconnect home");
      print(data);
    });
    socket.on('error', (data) {
      emit(HomeLoaded(status: 'error', statusCode: 4));
      print("error home");
      print(data);
    });
  }
}
