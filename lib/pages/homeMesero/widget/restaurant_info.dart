import 'package:flutter/material.dart';
import 'package:bbb/models/restaurant.dart';

class RestaurantInfo extends StatelessWidget {
  final Future<Restaurant> restaurant = Restaurant.generateRestaurant();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Restaurant>(
      future: restaurant,
      builder: (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Mostrar un indicador de carga mientras se espera el resultado
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Mostrar un mensaje de error si el Future falla
        } else {
          Restaurant restaurant = snapshot.data!; // Acceder a los datos del Future una vez que se ha completado
          return Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                //Pagina principal, descripcion de la pizzeria
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style:
                            const  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      const  SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        restaurant.logoUrl,
                        width: 80,
                      ),
                    )
                  ],
                ),
              const  SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(restaurant.desc, style: const TextStyle(fontSize: 16)),
               const  Row(
                      children: [
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        }
      },
    );
  }
}
