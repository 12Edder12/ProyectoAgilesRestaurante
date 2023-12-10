import 'package:bbb/pages/homeMesero/home_Mesero.dart';
import 'package:bbb/pages/homeMesero/tomar_mesa.dart';
import 'package:flutter/material.dart';

class Mesas extends StatefulWidget {

  @override
  _MesasState createState() => _MesasState();
}

class _MesasState extends State<Mesas> {
  int selectedMesa = 0;

  // Método para manejar el cambio de la mesa seleccionada
  void onMesaSelected(int index) {
    setState(() {
      selectedMesa = index;
    });
  print('Mesa seleccionada: $index');
    
  }

  // Método para construir un botón de mesa
  Widget buildMesaButton(String imageUrl, String mesaName, int index) {
    return ElevatedButton(
      onPressed: () => onMesaSelected(index),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          selectedMesa == index ? const Color(0xFF730A0A) : const Color(0x00EB8F1E),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.white,
              width: 5.0,
            ),
          ),
        ),
      ),
      child: SizedBox(
        width: 110,
        height: 150,
        child: Column(
          children: <Widget>[
            Image.asset(
              imageUrl,
              height: 90,
            ),
            Text(
              mesaName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 40,
          right: 8,
          left: 8,
          bottom: 15,
        ),
        color: const Color(0xFFCB0101),
        child: Column(
          children: <Widget>[
            const Text(
              "PIZZERIA GÜERRIN",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: buildMesaButton(
                         'lib/img/mesas.png',
                        "MESA 1",
                        1,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding:const EdgeInsets.all(10),
                      child: buildMesaButton(
                         'lib/img/mesas.png',
                        "MESA 2",
                        2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: buildMesaButton(
                        'lib/img/mesas.png',
                        "MESA 3",
                        3,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding:const EdgeInsets.all(10),
                      child: buildMesaButton(
                         'lib/img/mesas.png',
                        "MESA 4",
                        4,
                      ),
                    ),
                  ],
                ),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: buildMesaButton(
                        'lib/img/mesas.png',
                        "MESA 5",
                        5,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding:const EdgeInsets.all(10),
                      child: buildMesaButton(
                        'lib/img/mesas.png',
                        "MESA 6",
                        6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: (){
                        Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context)=> const HomeMesero2()) ) ; 
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                   foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    color: Colors.transparent,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(
                            left: 25.0,
                          ),
                          child: Text(
                            'ASIGNAR MESA',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón "ATRAS"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TomarMesa()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                   foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    color: Colors.transparent,
                    child:const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25.0,
                          ),
                          child: Text(
                            'ATRAS',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
