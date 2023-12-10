import 'package:flutter/material.dart';
import 'package:bbb/constants/colors.dart';
import 'package:bbb/models/pizza.dart';

class FoodImg extends StatelessWidget {
  final Pizza? food;
  FoodImg({this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    color: kBackground,
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: const EdgeInsets.all(15),
                width: 220,
                height: 220,
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset:const  Offset(-1, 10),
                    blurRadius: 10,
                  )
                ]),
                child: Image.network(
                  food!.imgUrl!,
                  fit: BoxFit.cover,
                )),
          )
        ],
      ),
    );
  }
}
