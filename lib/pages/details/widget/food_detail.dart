import 'package:flutter/material.dart';
import 'package:bbb/pages/details/widget/food_quantity.dart';
import 'package:bbb/constants/colors.dart';
import 'package:bbb/models/producto.dart';

class FoodDetail extends StatelessWidget {
  final Pizza? food;
  FoodDetail({this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25),
        color: kBackground,
        child: Column(
          children: [
            Text(
              food!.name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
         const   SizedBox(
              height: 15,
            ),
            //aqui estaba el row
            
         const   SizedBox(
              height: 39,
            ),
            FoodQuantity(food: food),
       const        SizedBox(
              height: 39,
            ),
       const  Row(
              children: [
                Text(
                  'Ingredientes',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                )
              ],
            ),
       const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                        padding: const  EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          children: [
                            Image.network(food!.ingredients![index].values.first,
                                width: 52),
                            Text(food!.ingredients![index].keys.first),
                          ],
                        ),
                      ),
                  separatorBuilder: (_, index) => const SizedBox(
                        width: 15,
                      ),
                  itemCount: food!.ingredients!.length),
            ),
            const  SizedBox(height: 30),
           const  Row(
              children: [
                Text(
                  'Más información',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
         const   SizedBox(height: 10),
            Text(
              food!.about!,
              style: const TextStyle(fontSize: 16, wordSpacing: 1.2, height: 1.5),
            ),
          const  SizedBox(height: 20),
          ],
        ));
  }

  _buildIconText(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
