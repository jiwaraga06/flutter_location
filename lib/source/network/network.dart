import 'dart:convert';

import 'package:flutter_location/source/network/api.dart';
import 'package:http/http.dart' as http;

class MyNetwork {
  Future login(body) async {
    try {
      var url = Uri.parse(MyApi.apilogin());
      var response = await http.post(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
        },
        body: body,
      );
      return response;
    } catch (e) {
      print("ERROR network login: $e");
    }
  }

  Future logout(body) async {
    try {
      var url = Uri.parse(MyApi.logout());
      var response = await http.post(url, headers: {'Authorization': MyApi.token(), 'Accept': 'application/json'}, body: body);
      return response;
    } catch (e) {
      print('ERROR NETWORK LOGOUT: $e');
    }
  }

  Future gantiPassword(body) async {
    try {
      var url = Uri.parse(MyApi.gantiPassword());
      var response = await http.post(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
          // 'Content-Type': 'application/json',
        },
        body: body,
      );
      return response;
    } catch (e) {
      print('ERROR NETWORK ganti_pass : $e');
    }
  }

// ABSEN LOKASI
  Future getRadius() async {
    try {
      var url = Uri.parse(MyApi.radius());
      var response = await http.get(url, headers: {
        'Authorization': MyApi.token(),
      });
      return response;
    } catch (e) {
      print('ERROR NETWROK RADIUS: $e');
    }
  }

  Future getTaskByLokasi(id_lokasi) async {
    try {
      var url = Uri.parse(MyApi.getTaskByLokasi(id_lokasi));
      var response = await http.get(url, headers: {
        'Authorization': MyApi.token(),
      });
      return response;
    } catch (e) {
      print('ERROR NETWROK GET_TASK_BY_LOKASI: \n $e');
    }
  }

  Future postHistoryLokasiSecurity(body) async {
    try {
      var url = Uri.parse(MyApi.postHistoryLokasiSecurity());
      var response = await http.post(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      return response;
    } catch (e) {
      print('ERROR NETWORK HISTORY LOKASI SECURITY: \N$e');
    }
  }

  Future postAbsenLokasi(body) async {
    try {
      var url = Uri.parse(MyApi.postAbsenLokasi());
      var response = await http.post(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      return response;
    } catch (e) {
      print('ERROR NETWORK POST ABSEN: $e');
    }
  }

  //  HISTORY SATPAM

  Future getHistory(tgl_awal, tgl_akhir) async {
    try {
      var url = Uri.parse(MyApi.historyAbsen(tgl_awal, tgl_akhir));
      var response = await http.get(url, headers: {
        'Authorization': MyApi.token(),
      });
      return response;
    } catch (e) {
      print('ERROR NETWROK HISTORY: $e');
    }
  }

  Future getHistoryBarcode(barcode, tgl_awal, tgl_akhir) async {
    try {
      var url = Uri.parse(MyApi.historyAbsenBarcode(barcode, tgl_awal, tgl_akhir));
      var response = await http.get(url, headers: {
        'Authorization': MyApi.token(),
      });
      return response;
    } catch (e) {
      print('ERROR NETWROK HISTORY: $e');
    }
  }

  // CHECKPOINT
  Future checkpoint() async {
    try {
      var url = Uri.parse(MyApi.checkpoint());
      var response = await http.get(url, headers: {'Authorization': MyApi.token()});
      return response;
    } catch (e) {
      print('ERROR NETWORK CHECKPOINT: $e');
    }
  }

  Future addCheckpoint(body) async {
    try {
      var url = Uri.parse(MyApi.addCheckpoint());
      var response = await http.post(url, headers: {'Authorization': MyApi.token(), 'Accept': 'application/json'}, body: body);
      return response;
    } catch (e) {
      print('ERROR NETWORK ADD LOKASI: $e');
    }
  }

  Future updateCheckpoint(body) async {
    try {
      var url = Uri.parse(MyApi.updateCheckpoint());
      var response = await http.put(url, headers: {'Authorization': MyApi.token(), 'Accept': 'application/json'}, body: body);
      return response;
    } catch (e) {
      print('ERROR NETWORK UPDATE LOKASI: $e');
    }
  }

  // TASK
  Future addTask(body) async {
    try {
      var url = Uri.parse(MyApi.addTask());
      var response = await http.post(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
        },
        body: body,
      );
      return response;
    } catch (e) {
      print('ERROR NETWORK ADD_TASK: $e');
    }
  }

  Future editTask(body) async {
    try {
      var url = Uri.parse(MyApi.editTask());
      var response = await http.put(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
        },
        body: body,
      );
      return response;
    } catch (e) {
      print('ERROR NETWORK EDIT_TASK: $e');
    }
  }

  // SUB TASK
  Future addSubTask(body) async {
    try {
      var url = Uri.parse(MyApi.addSubTask());
      var response = await http.post(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
        },
        body: body,
      );
      return response;
    } catch (e) {
      print('ERROR NETWORK ADD SUB TASK: \N $e');
    }
  }

  Future editSubTask(body) async {
    try {
      var url = Uri.parse(MyApi.editSubTask());
      var response = await http.put(
        url,
        headers: {
          'Authorization': MyApi.token(),
          'Accept': 'application/json',
        },
        body: body,
      );
      return response;
    } catch (e) {
      print('ERROR NETWORK EDIT SUB TASK: \N $e');
    }
  }
}
