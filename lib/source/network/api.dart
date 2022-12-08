String baseUrl = "https://satu.sipatex.co.id:2087";

class MyApi {
  static token() {
    return "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoxLCJuYW1hIjoicm9vdCIsImVtYWlsIjoicm9vdEBsb2NhbGhvc3QifSwiaWF0IjoxNTkyMjM1MzE2fQ.KHYQ0M1vcLGSjJZF-zvTM5V44hM0B8TqlTD0Uwdh9rY";
  }

  static apilogin() {
    return "$baseUrl/api/v1/mobile-app/secsms/login";
  }

  static logout() {
    return "$baseUrl/api/v1/mobile-app/secsms/logout";
  }

  static gantiPassword() {
    return "$baseUrl/api/v1/mobile-app/secsms/change_password";
  }

  static historyAbsenBarcode(barcode, tgl_awal, tgl_akhir) {
    return '$baseUrl/api/v1/mobile-app/secsms/absen?barcode=$barcode&from=$tgl_awal&to=$tgl_akhir';
  }

  static historyAbsen(tgl_awal, tgl_akhir) {
    return '$baseUrl/api/v1/mobile-app/secsms/absen?from=$tgl_awal&to=$tgl_akhir';
  }

  static radius() {
    return '$baseUrl/api/v1/mobile-app/secsms/radius';
  }

  static getTaskByLokasi(id_lokasi) {
    return '$baseUrl/api/v1/mobile-app/secsms/checkpoint/task?id_lokasi=$id_lokasi';
  }

  static postAbsenLokasi() {
    return '$baseUrl/api/v1/mobile-app/secsms/absen/store';
  }

  static postHistoryLokasiSecurity() {
    return '$baseUrl/api/v1/mobile-app/secsms/history_lokasi_security';
  }

  // LOKASI
  static checkpoint() {
    return '$baseUrl/api/v1/mobile-app/secsms/checkpoint/';
  }

  static addCheckpoint() {
    return '$baseUrl/api/v1/mobile-app/secsms/checkpoint/store';
  }

  static updateCheckpoint() {
    return '$baseUrl/api/v1/mobile-app/secsms/checkpoint/update';
  }

  // TASK
  static addTask() {
    return '$baseUrl/api/v1/mobile-app/secsms/task/store';
  }

  static editTask() {
    return '$baseUrl/api/v1/mobile-app/secsms/task/update';
  }

  // SUB TASK
  static addSubTask() {
    return '$baseUrl/api/v1/mobile-app/secsms/subtask/store';
  }

  static editSubTask() {
    return '$baseUrl/api/v1/mobile-app/secsms/subtask/update';
  }
}
