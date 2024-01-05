import 'package:bbb/pages/homeMesero/home_Mesero.dart';
import 'package:bbb/pages/homeMesero/tomar_mesa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  void onMesaSelected(int index, bool mesaDisponible) {
    if (mesaDisponible) {
    // Si la mesa no está disponible, muestra el diálogo de confirmación
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmación"),
          content: const Text("¿Deseas seguir editando el pedido?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Sí"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeMesero2()),
                  );
setState(() {
      selectedMesa = index;
    });
    globals.mesaOrden = index;
                  
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                // Si el usuario elige "No", simplemente cierra el diálogo
                Navigator.pop(context); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    ); }
    else {
    setState(() {
      selectedMesa = index;
    });
    globals.mesaOrden = index;
    }
  }

  Stream<List<Map<String, dynamic>>> getMesasData() {
    return FirebaseFirestore.instance
        .collection('tables')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  // Método para construir un botón de mesa
  Widget buildMesaButton(String imageUrl, String mesaName, int index,  bool mesaDisponible,
      {Color color = Colors.green}) {
    return ElevatedButton(
      onPressed: () => onMesaSelected(index, mesaDisponible),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          selectedMesa == index ? const Color(0xFF6C6969) : color,
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
      body: Stack(
        children: [
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
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Color de fondo del Text
                  borderRadius:
                      BorderRadius.circular(20.0), // Esquinas redondeadas
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
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: getMesasData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se esperan los datos
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Muestra un mensaje de error si algo sale mal
                  } else {
                    return Wrap(
                      spacing: 10, // espacio horizontal entre las mesas
                      runSpacing: 10, // espacio vertical entre las mesas
                      children: snapshot.data!.map((mesaData) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 30) /
                              2, // ancho de cada mesa
                          child: buildMesaButton(
                            'lib/img/mesas.png',
                            "MESA ${mesaData['id_tab']}",
                            mesaData['num'],
                            mesaData['est_tab'] != true,
                            color: mesaData['est_tab'] != true
                                ? Colors.red
                                : Colors.green,
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
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
              const SizedBox(height: 10),
              ElevatedButton(
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
            ]),
          ),
        ],
      ),
    );
  }
}
