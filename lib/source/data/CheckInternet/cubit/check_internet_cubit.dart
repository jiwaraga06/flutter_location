import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'check_internet_state.dart';

class CheckInternetCubit extends Cubit<CheckInternetState> {
  CheckInternetCubit() : super(CheckInternetInitial());

  void checkInternet() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      print('Status Koneksi: $result');
      if (result == ConnectivityResult.none) {
        emit(CheckInternetStatus(status: false, valStatus: 'None'));
      } else if (result == ConnectivityResult.mobile) {
        emit(CheckInternetStatus(status: true, valStatus: 'Mobile'));
      } else if (result == ConnectivityResult.wifi) {
        emit(CheckInternetStatus(status: true, valStatus: 'Wifi'));
      }
    });
  }
}
