import 'package:flutter_webservice/pages/employee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';

class EmployeeEdit extends StatefulWidget {
  final String id; //INISIASI VARIABLE ID;
  EmployeeEdit({this.id}); //BUAT CONSTRUCT UNTUK MEMINTA DATA ID

  @override
  _EmployeeEditState createState() => _EmployeeEditState();
}

class _EmployeeEditState extends State<EmployeeEdit> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _age = TextEditingController();
  bool _isLoading = false;

  final snackbarKey = GlobalKey<ScaffoldState>();

  FocusNode salaryNode = FocusNode();
  FocusNode ageNode = FocusNode();

  //KETIKA CLASS INI AKAN DI-RENDER, MAKA AKAN MENJALANKAN FUNGSI BERIKUT
  @override
  void initState() {
    //BUAT DELAY
    Future.delayed(Duration.zero, () {
      //MENJALANKAN FUNGSI FINDEMPLOYEE UNTUK MENCARI DATA EMPLOYEE BERDASARKAN IDNYA
      //CARA MENGAKSES ID DARI CONSTRUCTOR PADA STATEFUL WIDGET ADALAH 
     //WIDGET DOT DAN DIIKUTI DENGAN VARIABLE YANG INGIN DIAKSES
      Provider.of<EmployeeProvider>(context, listen: false).findEmployee(widget.id).then((response) {
        //JIKA DITEMUKAN, MAKA DATA TERUS KITA MASUKKAN KE DALAM VARIABLE CONTROLLER UNTUK TEKS FIELD
        _name.text = response.employeeName;
        _salary.text = response.employeeSalary;
        _age.text = response.employeeAge;
      });
    });
    super.initState();
  }

  void submit(BuildContext context) {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      //ADAPUN UNTUK PROSES UPDATE, JALANKAN FUNGSI UPDATEEMPLOYEE() DENGNA MENGIRIMKAN DATA YANG SAMA KETIKA ADD DATA, HANYA SAJA DITAMBAHKAN DENGAN ID PEGAWAI
      Provider.of<EmployeeProvider>(context, listen: false)
          .updateEmployee(widget.id, _name.text, _salary.text, _age.text)
          .then((res) {
        if (res) {
         Navigator.of(context).pushAndRemoveUntil(
         MaterialPageRoute(builder: (context) => Employee()), (route) => false);
        } else {
          var snackbar = SnackBar(content: Text('Ops, Error. Hubungi Admin'),);
          snackbarKey.currentState.showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackbarKey,
      appBar: AppBar(
        title: Text('Edit Employee'),
        actions: <Widget>[
          FlatButton(
            child: _isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
            onPressed: () => submit(context),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _name,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
                hintText: 'Nama Lengkap',
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(salaryNode);
              },
            ),
            TextField(
              controller: _salary,
              focusNode: salaryNode,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
                hintText: 'Gaji',
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(ageNode);
              },
            ),
            TextField(
              controller: _age,
              focusNode: ageNode,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
                hintText: 'Umur',
              ),
            ),
          ],
        ),
      ),
    );
  }
}