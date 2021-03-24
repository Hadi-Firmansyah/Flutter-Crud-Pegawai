import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webservice/providers/employee_provider.dart';
import './employee_add.dart';
import 'employee_edit.dart';

class Employee extends StatelessWidget {
  //DUMMY DATA YANG AKAN DITAMPILKAN SEBELUM MELAKUKAN HIT KE API
  //ADAPUN FORMAT DATANYA MENGIKUTI STRUKTU YANG SUDAH DITETAPKAN PADA EMPLOYEEMODEL
  final data = [
    EmployeeModel(
      id: "1",
      employeeName: "Hadi Firmansyah",
      employeeSalary: "320800",
      employeeAge: "61",
      profileImage: "",
    ),
    EmployeeModel(
      id: "2",
      employeeName: "Anugrah Sandi",
      employeeSalary: "40000",
      employeeAge: "25",
      profileImage: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DW Employee CRUD'),
      ),
     //FITUR DIMANA KETIKA PAGE DITARIK DARI ATAS KE BAWAH, MAKA AKAN MEMICU FUNGSI UNTUK MENGAMBIL DATA KE API
body: RefreshIndicator(
  //ADAPUN FUNGSI YANG DIJALANKAN ADALAH getEmployee() DARI EMPLOYEE_PROVIDER
  onRefresh: () =>
      Provider.of<EmployeeProvider>(context, listen: false).getEmployee(),
  color: Colors.red,
  child: Container(
    margin: EdgeInsets.all(10),
    //KETIKA PAGE INI DIAKSES MAKA AKAN MEMINTA DATA KE API
    child: FutureBuilder(
      //DENGAN MENJALANKAN FUNGSI YANG SAMA
      future: Provider.of<EmployeeProvider>(context, listen: false)
          .getEmployee(),
      builder: (context, snapshot) {
        //JIKA PROSES REQUEST MASIH BERLANGSUNG
        if (snapshot.connectionState == ConnectionState.waiting) {
          //MAKA KITA TAMPILKAN INDIKATOR LOADING
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //SELAIN ITU KITA RENDER ATAU TAMPILKAN DATANYA
        //ADAPUN UNTUK MENGAMBIL DATA DARI STATE DI PROVIDER
        //MAKA KITA GUNAKAN CONSUMER
        return Consumer<EmployeeProvider>(
          builder: (context, data, _) {
            //KEMUDIAN LOOPING DATANYA DENGNA LISTVIEW BUILDER
            return ListView.builder(
  itemCount: data.dataEmployee.length,
  itemBuilder: (context, i) {
    //WRAP DENGAN INKWELL UNTUK MENGGUNAKAN ATTRIBUTE ONTAPNYA
    return InkWell(
      onTap: () {
        //DIMANA KETIKA DI-TAP MAKA AKAN DIARAHKAN
        Navigator.of(context).push(
          //KE CLASS EMPLOYEEEDIT DENGAN MENGIRIMKAN ID EMPLOYEE
          MaterialPageRoute(
            builder: (context) => EmployeeEdit(id: data.dataEmployee[i].id,),
          ),
        );
      },
      child: Dismissible(
  key: UniqueKey(), //GENERATE UNIQUE KEY UTK MASING-MASING ITEM
  direction: DismissDirection.endToStart, //ATUR ARAH DISMISSNYA
  //BUAT KONFIRMASI KETIKA USER INGIN MENGHAPUS DATA
  confirmDismiss: (DismissDirection direction) async {
    //TAMPILKAN DIALOG KONFIRMASI
    final bool res = await showDialog(context: context, builder: (BuildContext context) {
      //DENGAN MENGGUNAKAN ALERT DIALOG
      return AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Kamu Yakin?'),
        actions: <Widget>[
          //KITA SET DUA BUAH TOMBOL UNTUK HAPUS DAN CANCEL DENGAN VALUE BOOLEAN
          FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text('HAPUS'),),
          FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text('BATALKAN'),)
        ],
      );
    });
    return res;
  },
  onDismissed: (value) {
    //KETIKA VALUENYA TRUE, MAKA FUNGSI INI AKAN DIJALANKAN, UNTUK MENGHAPUS DATA
    Provider.of<EmployeeProvider>(context, listen: false).deleteEmployee(data.dataEmployee[i].id);
  },
  child: Card(
    elevation: 8,
    child: ListTile(
      title: Text(
        data.dataEmployee[i].employeeName,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
          'Umur: ${data.dataEmployee[i].employeeAge}'),
      trailing: Text(
          "\$${data.dataEmployee[i].employeeSalary}"),
    ),
  ),
),
    );
  },
);
          },
        );
      },
    ),
  ),
),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          child: Text('+'),
          onPressed: () {
            //BUAT NAVIGASI UNTUK BERPINDAH KE HALAMAN EMPLOYEEADD
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => EmployeeAdd()));
          },
        ),
    );
  }
}