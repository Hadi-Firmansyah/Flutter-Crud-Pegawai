import 'package:flutter/material.dart';
import './pages/employee.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webservice/providers/employee_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EmployeeProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Employee(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
