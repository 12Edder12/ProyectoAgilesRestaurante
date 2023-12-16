import 'package:bbb/pages/homeMesero/home_Mesero.dart';
import 'package:bbb/pages/homeMesero/tomar_mesa.dart';
import 'package:flutter/material.dart';
import 'package:bbb/constants/globals.dart' as globals;

class Mesas extends StatefulWidget {
  const Mesas({super.key});

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
    globals.mesaOrden = index;
  }

  // Método para construir un botón de mesa
  Widget buildMesaButton(String imageUrl, String mesaName, int index) {
    return ElevatedButton(
      onPressed: () => onMesaSelected(index),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          selectedMesa == index
              ? const Color(0xFF6C6969)
              : const Color(0xFFEE8F1B),
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
        width: 100,
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
      body: Stack(children: [
        Opacity(
          opacity: 0.2,
          child: Image.asset(
            "lib/img/xd.jpeg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 5,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Color de fondo del Text
                  borderRadius: BorderRadius.circular(20.0), // Esquinas redondeadas
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "PIZZERIA GÜERRIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black, // Color del texto
                      fontSize: 42,
                      fontFamily: AutofillHints.countryName,
                    ),
                  ),
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
                        padding: const EdgeInsets.all(10),
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
                        padding: const EdgeInsets.all(10),
                        child: buildMesaButton(
                          'lib/img/mesas.png',
                          "MESA 4",
                          4,
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
                          "MESA 5",
                          5,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeMesero2()));
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
                      height: 45,
                      color: Colors.transparent,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25.0,
                            ),
                            child: Text(
                              'ASIGNAR MESA',
                              style: TextStyle(
                                fontSize: 22,
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
                        MaterialPageRoute(
                            builder: (context) => const TomarMesa()),
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
                      height: 45,
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                      ),
                      color: Colors.transparent,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: Text(
                              'ATRÁS',
                              style: TextStyle(
                                fontSize: 22,
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
      ]),
    );
  }
}
