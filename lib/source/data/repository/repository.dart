import 'package:flutter_location/source/network/network.dart';

class MyReposity {
  final MyNetwork? myNetwork;

  MyReposity({required this.myNetwork});

  Future login(username, password, device_uuid) async {
    var body = {
      'barcode': "$username",
      'password': "$password",
      'device_uuid': "$device_uuid"
      // 'device_uuid': '06f2a2278d890a7d'
    };
    final json = await myNetwork!.login(body);
    return json;
  }

  Future logout(body) async {
    var json = await myNetwork!.logout(body);
    return json;
  }

  Future getRadius() async {
    var json = await myNetwork!.getRadius();
    return json;
  }

  // POST ABSEN
  Future getTaskByLokasi(id_lokasi) async {
    var json = await myNetwork!.getTaskByLokasi(id_lokasi);
    return json;
  }

  Future gantiPassword(body) async {
    var json = await myNetwork!.gantiPassword(body);
    return json;
  }

  Future postAbsenLokasi(body) async {
    var json = await myNetwork!.postAbsenLokasi(body);
    return json;
  }

  // HISTORY SATPAM

  Future getHistory(tgl_awal, tgl_akhir) async {
    var json = await myNetwork!.getHistory(tgl_awal, tgl_akhir);
    return json;
  }

  Future getHistorybarcode(barcode, tgl_awal, tgl_akhir) async {
    var json = await myNetwork!.getHistoryBarcode(barcode, tgl_awal, tgl_akhir);
    return json;
  }

  Future postHistoryLokasiSecurity(body) async {
    var json = await myNetwork!.postHistoryLokasiSecurity(body);
    return json;
  }

  // CHECKPOINT
  Future checkpoint() async {
    var json = await myNetwork!.checkpoint();
    return json;
  }

  Future addCheckpoint(body) async {
    var json = await myNetwork!.addCheckpoint(body);
    return json;
  }

  Future updateCheckpoint(body) async {
    var json = await myNetwork!.updateCheckpoint(body);
    return json;
  }

  // TASK
  Future addTask(body) async {
    var json = myNetwork!.addTask(body);
    return json;
  }

  Future editTask(body) async {
    var json = myNetwork!.editTask(body);
    return json;
  }

  //SUB TASK
  Future addSubTask(body) async {
    var json = myNetwork!.addSubTask(body);
    return json;
  }

  Future editSubTask(body) async {
    var json = myNetwork!.editSubTask(body);
    return json;
  }
}
