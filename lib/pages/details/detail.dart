import 'package:flutter/material.dart';
import 'package:bbb/pages/details/widget/food_detail.dart';
import 'package:bbb/pages/details/widget/food_image.dart';
import 'package:bbb/constants/colors.dart';
import 'package:bbb/models/pizza.dart';
import 'package:bbb/models/pedido.dart';
import 'package:bbb/pages/components/custom_app_bar.dart';
import 'package:bbb/constants/globals.dart' as globals;

class DetailPage extends StatefulWidget {
  final Pizza food;
  const DetailPage({
    Key? key,
    required this.food,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(
              leftIcon: Icons.arrow_back,
              leftCallback: () => Navigator.pop(context),
            ),
            FoodImg(
              food: widget.food,
            ),
            FoodDetail(
              food: widget.food,
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 56,
        child: RawMaterialButton(
          onPressed: () {
            setState(() {
              bool found = false;

              // Itera sobre la lista de pedidos
              for (Pedido pedido in globals.pedidos) {
                // Si encuentras un pedido con la misma comida, actualiza la cantidad
                if (pedido.food.name == widget.food.name) {
                  if (pedido.quantity! + widget.food.quantity! <= 10) {
                    pedido.quantity = pedido.quantity! + widget.food.quantity!;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                        content: Text('La cantidad máxima de comida es de 10'),
                      ),
                    );
                    return;
                  }
                  found = true;
                  break;
                }
              }

              // Si no encontraste un pedido con la misma comida, agrega un nuevo pedido
              if (!found) {
                if (widget.food.quantity! <= 10) {
                  globals.pedidos.add(Pedido(
                      food: widget.food, quantity: widget.food.quantity));
                  // Incrementa el contador de pedidos solo cuando se agrega un nuevo pedido
                  globals.orderCount++;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const  SnackBar(
                      content: Text('La cantidad máxima de comida es de 10'),
                    ),
                  );
                }
              }
            });
          },
          fillColor: kPrimaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.restaurant_menu,
                color: Colors.black,
                size: 30,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Text(
                  globals.orderCount.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
