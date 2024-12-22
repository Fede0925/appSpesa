import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp( HelloWorld() );
}


class Calcolatrice extends ChangeNotifier {
  var testi = <String>[];

  void setTesto(String v){
    testi.add(v);
    notifyListeners();
  }

  void remove(int i){
    testi.removeAt(i);
    notifyListeners();
  }
}


// ignore: use_key_in_widget_constructors
class HelloWorld extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return ChangeNotifierProvider(

      create: (context) => Calcolatrice(),

      child: MaterialApp(

        theme: ThemeData(

          primarySwatch: Colors.blue,

        ),

        home: SchermataPrincipale(),

      ),

    );

  }

}

// ignore: use_key_in_widget_constructors
class SchermataPrincipale extends StatefulWidget {
  @override
  State<SchermataPrincipale> createState() => _HomePageState();
}

var a = true;

  @override
class _HomePageState extends State<SchermataPrincipale>{
  @override
  Widget build(BuildContext context) {
    const listWTB = BorderSide(color: Colors.black87,width: 1);
    const listWLR = BorderSide(color: Colors.black87,width: 2.5);
    var statoApplicazione = context.watch<Calcolatrice>();
    final controllo = TextEditingController();
    //print("a: $a");
    void lettore() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList("lista", statoApplicazione.testi);
      //print(prefs.getStringList("lista"));
    }
    if(a){
      SharedPreferences.getInstance().then((sharedPreferences){
        final valore = sharedPreferences.getStringList("lista");
        setState(() {
          if(valore!=null){
            statoApplicazione.testi= valore;
          }
        });
      });
      a=false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(148, 0, 136, 255),
        title: const Text('Spesa',style:TextStyle(fontWeight: FontWeight.bold)),
        shape: LinearBorder.bottom(side: const BorderSide(width: 0.3, color: Color.fromARGB(255, 0, 0, 255))),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: TextField(controller: controllo)
              ),
              ),
              Container(padding: const EdgeInsets.all(5),
                child: ElevatedButton(onPressed: (){statoApplicazione.setTesto(controllo.text);lettore();}, style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 113, 190, 253)), child: const Text("Aggiungi",style: TextStyle(color: Colors.white),),),
              ),
            ],
          ),
          Expanded(
          child: SizedBox(
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: statoApplicazione.testi.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),child: GestureDetector(onTap: () {
                  statoApplicazione.remove(index);
                  lettore();
                }, child: Container(
                  decoration: const BoxDecoration(border: Border(top: listWTB, bottom: listWTB, left: listWLR, right: listWLR),borderRadius: BorderRadius.all(Radius.circular(11.5)),),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: AutoSizeText( statoApplicazione.testi[index],
                  style: const TextStyle(fontSize: 30),
                  maxFontSize: 30,
                ),
                ),
                ),
                );
              },
            ),
          ),
        ),
        ],
      )
    );

  }
}