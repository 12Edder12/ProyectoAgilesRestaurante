import 'package:flutter/material.dart';

import 'package:Pizzeria_Guerrin/models/producto.dart';

class FoodItem extends StatelessWidget {
  final Pizza food;
  const FoodItem({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
              padding:  const  EdgeInsets.all(5),
              width: 110,
              height: 110,
              child: Image.network(
                food.imgUrl.toString(),
                fit: BoxFit.fitHeight,
              )),
          Expanded(
            child: Container(
              padding:  const  EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        food.name.toString(),
                        style:  const  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.5),
                      ),
                      const  Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15,
                      )
                    ],
                  ),
                 
                const    SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                   const     Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        food.price.toString(),
                        style:  const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
