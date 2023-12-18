import 'pizza.dart';

class Restaurant {
  String name;
  String label;
  String logoUrl;
  String desc;
  Map<String, List<Pizza>> menu;
  Restaurant({
    required this.name,
    required this.label,
    required this.logoUrl,
    required this.desc,
    required this.menu,
  });

  static Future<Restaurant> generateRestaurant() async {
  List<Pizza> recommendedPizzas = await Pizza.generateRecommendFoods();
  List<Pizza> popularPizzas = await Pizza.getPizzasByIds();
  List<Pizza> getBebidas = await Pizza.getBebidas();

  return Restaurant(
    name: 'Pizzeria Guerrin',
    label: 'Restaurante',
    logoUrl: 'lib/img/res_logo.png',
    desc: '"La mejor pizza en todo Ambato"',
    menu: {
      'Recomendados': popularPizzas,
      'Todos':  recommendedPizzas,
      'Bebidas': getBebidas
    },
  );
}
}
