import 'package:bbb/services/auth/auth_service.dart';
import 'package:bbb/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:bbb/pages/homeMesero/widget/custom_dialog.dart';
import 'package:bbb/pages/homeMesero/widget/food_list.dart';
import 'package:bbb/pages/homeMesero/widget/food_list_view.dart';
import 'package:bbb/pages/homeMesero/widget/restaurant_info.dart';
import 'package:bbb/constants/colors.dart';
import 'package:bbb/constants/globals.dart' as globals;
import 'package:bbb/models/restaurant.dart';
import 'package:bbb/pages/components/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeMesero2 extends StatefulWidget {
  const HomeMesero2({Key? key}) : super(key: key);

  @override
  State<HomeMesero2> createState() => _HomeMesero2State();
}

class _HomeMesero2State extends State<HomeMesero2> {
  var selected = 0;
  final pageController = PageController();
  final Future<Restaurant> restaurant = Restaurant.generateRestaurant();

  Future<void> signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Restaurant>(
      future: restaurant,
      builder: (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Mostrar un indicador de carga mientras se espera el resultado
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Mostrar un mensaje de error si el Future falla
        } else {
          Restaurant restaurant = snapshot
              .data!; // Acceder a los datos del Future una vez que se ha completado
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home Mesero'),
              actions: [
                IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await signOut();
                    }),
              ],
            ),
            backgroundColor: kBackground,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RestaurantInfo(),
                FoodList(
                  selected: selected,
                  restaurant: restaurant,
                  callback: (int index) {
                    setState(() {
                      selected = index;
                    });
                    pageController.jumpToPage(index);
                  },
                ),
                Expanded(
                  child: FoodListView(
                    selected: selected,
                    callback: (int index) {
                      setState(() {
                        selected = index;
                      });
                    },
                    pageController: pageController,
                    restaurant: restaurant,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  height: 60,
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: restaurant.menu.length,
                    effect: CustomizableEffect(
                      dotDecoration: DotDecoration(
                        width: 8,
                        height: 8,
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      activeDotDecoration: DotDecoration(
                        width: 10,
                        height: 10,
                        color: kBackground,
                        borderRadius: BorderRadius.circular(10),
                        dotBorder: const DotBorder(
                          color: kPrimaryColor,
                          padding: 2,
                          width: 2,
                        ),
                      ),
                    ),
                    onDotClicked: (index) => pageController.jumpToPage(index),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (globals.pedidos.length > 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(pedidos: globals.pedidos);
                    },
                  );
                }
              },
              child: Icon(Icons.add),
              backgroundColor: kPrimaryColor,
            ),
          );
        }
      },
    );
  }
}
