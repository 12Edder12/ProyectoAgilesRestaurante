import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/constants/colors.dart';
import 'package:Pizzeria_Guerrin/models/producto.dart';

class FoodQuantity extends StatefulWidget {
  final Pizza? food;
  const FoodQuantity({
    super.key,
    this.food,
  });

  @override
  _FoodQuantityState createState() => _FoodQuantityState();
}

class _FoodQuantityState extends State<FoodQuantity> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        height: 40,
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(-0.3, 0),
              child: Container(
                height: double.maxFinite,
                width: 197, // Aumenta este valor según sea necesario
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(children: [
               const   SizedBox(
                    width: 15,
                  ),
                const  Text(
                    '\$',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.food!.price!.toString(),
                    style:const  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
            Align(
              alignment:  const Alignment(0.1, 0),
              child: Container(
                height: double.maxFinite,
                width: 100,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                            widget.food?.setQuantity(quantity);
                          }
                        });
                      },
                      child: const Text(
                        '-',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration:  const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Text(
                        quantity.toString(),
                        style:  const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (quantity < 10) {
                            quantity++;
                            widget.food?.setQuantity(quantity);
                          }
                        });
                      },
                      child:  const Text(
                        '+',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
