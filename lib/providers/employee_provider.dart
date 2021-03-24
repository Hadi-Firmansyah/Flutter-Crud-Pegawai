import 'package:flutter_webservice/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeProvider extends ChangeNotifier {
  //DEFINISIKAN PRIVATE VARIABLE DENGAN TYPE List dan VALUENYA MENGGUNAKAN FORMAT EMPLOYEEMODEL
  //DEFAULTNYA KITA BUAT KOSONG
  List<EmployeeModel> _data = [];
  //KARENA PRIVATE VARIABLE TIDAK BISA DIAKSES OLEH CLASS/FILE LAINNYA, MAKA DIPERLUKAN GETTER YANG BISA DIAKSES SECARA PUBLIC, ADAPUN VALUENYA DIAMBIL DARI _DATA
  List<EmployeeModel> get dataEmployee => _data;

  //BUAT FUNGSI UNTUK MELAKUKAN REQUEST DATA KE SERVER / API
  Future<List<EmployeeModel>> getEmployee() async {
    final url = 'http://employee-crud-flutter.daengweb.id/index.php';
    final response = await http.get(url); //LAKUKAN REQUEST DATA

    //JIKA STATUSNYA BERHASIL ATAU = 200
    if (response.statusCode == 200) {
      //MAKA KITA FORMAT DATANYA MENJADI MAP DENGNA KEY STRING DAN VALUE DYNAMIC
      final result = json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      //KEMUDIAN MAPPING DATANYA UNTUK KEMUDIAN DIUBAH FORMATNYA SESUAI DENGAN EMPLOYEEMODEL DAN DIPASSING KE DALAM VARIABLE _DATA
      _data = result.map<EmployeeModel>((json) => EmployeeModel.fromJson(json)).toList();
      return _data;
    } else {
      throw Exception();
    }
  }
  Future<bool> storeEmployee(String name, String salary, String age) async {
  final url = 'http://employee-crud-flutter.daengweb.id/add.php';
  //KIRIM REQUEST KE SERVER DENGAN MENGIRIMKAN DATA YANG AKAN DITAMBAHKAN PADA BODY
  final response = await http.post(url, body: {
    'employee_name': name,
    'employee_salary': salary,
    'employee_age': age
  });

  //DECODE RESPONSE YANG DITERIMA
  final result = json.decode(response.body);
  //LAKUKAN PENGECEKAN, JIKA STATUS CODENYA 200 DAN STATUS SUCCESS
  if (response.statusCode == 200 && result['status'] == 'success') {
    notifyListeners(); //MAKA INFORMASIKAN PADA LISTENERS BAHWA ADA DATA BARU
    return true;
  }
  return false;
}
Future<EmployeeModel> findEmployee(String id) async {
  return _data.firstWhere((i) => i.id == id); //JADI KITA CARI DATA BERDASARKAN ID DAN DATA PERTAMA AKAN DISELECT
}

//JADI KITA MINTA DATA YANG AKAN DIUPDATE
Future<bool> updateEmployee(id, name, salary, age) async {
  final url = 'http://employee-crud-flutter.daengweb.id/update.php';
  //DAN MELAKUKAN REQUEST UNTUK UPDATE DATA PADA URL DIATAS
  //DENGAN MENGIRIMKAN DATA YANG AKAN DI-UPDATE
  final response = await http.post(url, body: {
    'id': id,
    'employee_name': name,
    'employee_salary': salary,
    'employee_age': age
  });

  final result = json.decode(response.body); //DECODE RESPONSE-NYA
  //LAKUKAN PENGECEKAN, JIKA STATUSNYA 200 DAN BERHASIL
  if (response.statusCode == 200 && result['status'] == 'success') {
    notifyListeners(); //MAKA INFORMASIKAN KE WIDGET BAHWA TERJADI PERUBAHAN PADA STATE
    return true;
  }
  return false;
}
Future<void> deleteEmployee(String id) async {
  final url = 'http://employee-crud-flutter.daengweb.id/delete.php';
  await http.get(url + '?id=$id');
}
}
