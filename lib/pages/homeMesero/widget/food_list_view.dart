import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/pages/details/detail.dart';
import 'package:Pizzeria_Guerrin/pages/homeMesero/widget/food_item.dart';
import 'package:Pizzeria_Guerrin/models/restaurant.dart';

class FoodListView extends StatelessWidget {
  final int? selected;
  final Function? callback;
  final PageController? pageController;
  final Restaurant? restaurant;
  const FoodListView({
    super.key,
    this.selected,
    this.callback,
    this.pageController,
    this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final category = restaurant!.menu.keys.toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: PageView(
        controller: pageController,
        onPageChanged: (index) => callback!(index),
        children: category
            .map((e) => ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      food: restaurant!
                                          .menu[category[selected!]]![index],
                                    )));
                      },
                      child: FoodItem(
                        food: restaurant!.menu[category[selected!]]![index],
                      ),
                    ),
                separatorBuilder: (_, index) => const SizedBox(
                      height: 15,
                    ),
                itemCount: restaurant!.menu[category[selected!]]!.length))
            .toList(),
      ),
    );
  }
}
