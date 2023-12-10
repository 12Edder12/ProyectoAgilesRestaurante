import 'pizza.dart';

class Restaurant {
  String name;
  String label;
  String logoUrl;
  String desc;
  num score;
  Map<String, List<Pizza>> menu;
  Restaurant({
    required this.name,
    required this.label,
    required this.logoUrl,
    required this.desc,
    required this.score,
    required this.menu,
  });

  static Future<Restaurant> generateRestaurant() async {
  List<Pizza> recommendedPizzas = await Pizza.generateRecommendFoods();
  //List<Pizza> popularPizzas = await Pizza.generatePopularFood();

  return Restaurant(
    name: 'Pizzeria Guerrin',
    label: 'Restaurante',
    logoUrl: 'lib/img/res_logo.png',
    desc: '"La mejor pizza en todo Ambato"',
    score: 4.7,
    menu: {
      'Recomendados': recommendedPizzas,
      'Todos':  [],
    },
  );
}
}
