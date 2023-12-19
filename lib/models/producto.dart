import 'package:cloud_firestore/cloud_firestore.dart';

class Pizza {
  String? id; 
  String? imgUrl;
  String? desc;
  String? name;
  num? score;
  num? price;
  num? quantity;
  List<Map<String, String>>? ingredients;
  String? about;
  Pizza(
      { this.id, 
      this.imgUrl,
      this.name,
      this.price,
      this.quantity,
      this.ingredients,
      this.about});
////////////////Lista de ingredientes de las pizzas////////////////////

static List<Map<String, String>> ingredienteMargarita(){
  return [
    {'Mozzarella': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fmozzarela.png?alt=media&token=4def7b79-2477-46a7-a826-1c60433cbf25'},
    {'Albahaca ': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Falbahaca.png?alt=media&token=47538398-380f-4a14-bbcb-1e0b21d08234'},
  ];
}

static List<Map<String, String>> ingredientePepperoni() {
  return [
    {'Mozzarella': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fmozzarela.png?alt=media&token=4def7b79-2477-46a7-a826-1c60433cbf25'},
    {'Pepperoni': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fpeppe.png?alt=media&token=5869e658-792a-43df-84fd-f434212e841c'},
  ];
}

static List<Map<String, String>> ingredienteVegetariana() {
  return [
    {'Mozzarella': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fmozzarela.png?alt=media&token=4def7b79-2477-46a7-a826-1c60433cbf25'},
    {'Champiñones': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fchampi.png?alt=media&token=30b3a811-8f87-4d9b-a79a-0186decdd214'},
    {'Pimientos': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fpimientos.png?alt=media&token=478f2d71-5213-4fbc-8ed1-21c5741f0db4'},
    {'Cebollas': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fcebolla.png?alt=media&token=ef002275-e662-4dab-9e3c-22b4095e4f20'},
    {'Espinacas': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fespinacas.png?alt=media&token=22564162-72ae-4e07-811b-d7182c4916a4'},
  ];
}

static List<Map<String, String>> ingredienteBBQPollo() {
  return [
    {'Mozzarella': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fmozzarela.png?alt=media&token=4def7b79-2477-46a7-a826-1c60433cbf25'},
    {'Pollo a la parrilla': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2FpolloParilla.png?alt=media&token=5ac1ad2d-ff3e-419a-b387-a68ae2c17d3d'},
    {'Cebollas caramelizadas': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2FcebollaCaramelizada.png?alt=media&token=96ba688e-a9a2-412c-a7e4-04c9ddae3a43'},
  ];
}

static List<Map<String, String>> ingredienteHawaiana() {
  return [
    {'Mozzarella': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fmozzarela.png?alt=media&token=4def7b79-2477-46a7-a826-1c60433cbf25'},
    {'Jamón': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fjamon.png?alt=media&token=7d1f6156-312c-4574-bedb-ff4dd84e57ec'},
    {'Piña': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fpinia.png?alt=media&token=ed5173fb-9813-44ef-88a0-65e6421d2412'},
  ];
}

static List<Map<String, String>> ingredienteCuatroQuesos() {
  return [
    {'Mozzarella': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fmozzarela.png?alt=media&token=4def7b79-2477-46a7-a826-1c60433cbf25'},
    {'Queso cheddar': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fcheda.png?alt=media&token=70d7a1b6-19bb-4a7e-ae01-7964e1d6b101'},
    {'Queso de cabra': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fcabrapng.png?alt=media&token=bf4e98ce-5b4e-4420-b2a0-15fbe5f481f8'},
    {'Queso azul': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2FquesoAzul.png?alt=media&token=9fa5f9f1-158a-448c-aecf-1c1ad5ed7746'},
  ];
}

static List<Map<String, String>> ingredienteMexicana() {
  return [
    {'Mozzarella': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fmozzarela.png?alt=media&token=4def7b79-2477-46a7-a826-1c60433cbf25'},
    {'Carne molida': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fcarne_molida.png?alt=media&token=e89b2505-ba6d-41a8-b1bd-aee7431ca8f0'},
    {'Jalapeños': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fjalapenios.png?alt=media&token=d89c0bc4-5881-44a4-aa5d-2566f9ea2c5b'},
    {'Guacamole': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fguacamole.png?alt=media&token=8527289e-8c19-4d9f-a333-b8b3f5a6d71e'},
  ];
}

static List<Map<String, String>> ingredientePolloPesto() {
  return [
    {'Pesto': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fpesto.png?alt=media&token=5ed25fdc-e5bb-4ad3-93cf-94ccdc3f89ff'},
    {'Mozzarella': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2Fmozzarela.png?alt=media&token=4def7b79-2477-46a7-a826-1c60433cbf25'},
    {'Pollo a la parrilla': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2FpolloParilla.png?alt=media&token=5ac1ad2d-ff3e-419a-b387-a68ae2c17d3d'},
    {'Tomates cherry': 'https://firebasestorage.googleapis.com/v0/b/edder3-fd79d.appspot.com/o/Ingredientes%20Pizzas%2FTomates_cherry.png?alt=media&token=a431909c-3739-4d91-bcf3-384d21735e9d'},
  ];
}


static Future<List<Pizza>> generateRecommendFoods() async {
  List<Pizza> pizzas = [];

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('productos').get();
  
  querySnapshot.docs.forEach((doc) {
    if (!doc.id.startsWith('bebida')) {
      // Crear una lista de ingredientes por defecto
      List<Map<String, String>> ingredients;

      // Si el id del documento es 1, usar iMargarita como los ingredientes
      switch (doc.id) {
        case 'pizza1':
          ingredients = ingredienteMargarita();
          break;
        case 'pizza2':
          ingredients = ingredientePepperoni();
          break;
        case 'pizza3':
          ingredients = ingredienteVegetariana();
          break;
        case 'pizza4':
          ingredients = ingredienteBBQPollo();
          break;
        case 'pizza5':
          ingredients = ingredienteHawaiana();
          break;
        case 'pizza6':
          ingredients = ingredienteMexicana();
          break;
        case 'pizza7':
          ingredients = ingredientePolloPesto();
          break;
        case 'pizza8':
          ingredients = ingredienteCuatroQuesos();
          break;
        default:
          ingredients = [];
      }

      pizzas.add(Pizza(
        id: doc.id,
        imgUrl: doc['img'],
        name: doc['nombre'],
        price: doc['precio'],
        quantity: 1,
        ingredients: ingredients,
        about: doc['about'],
      ));
    }
  });

  return pizzas;
}

static Future<List<Pizza>> getPizzasByIds() async {
  List<String> ids = ['pizza2', 'pizza4', 'pizza6', 'pizza8'];
  List<Pizza> pizzas = [];

  for (String id in ids) {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('productos').doc(id).get();
    if (doc.exists) {
      List<Map<String, String>> ingredients;

      switch (doc.id) {
        case 'pizza2':
          ingredients = ingredientePepperoni();
          break;
        case 'pizza4':
          ingredients = ingredienteBBQPollo();
          break;
        case 'pizza6':
          ingredients = ingredienteMexicana();
          break;
        case 'pizza8':
          ingredients = ingredienteCuatroQuesos();
          break;
        default:
          ingredients = [];
      }

      pizzas.add(Pizza(
        id: doc.id,
        imgUrl: doc['img'],
        name: doc['nombre'],
        price: doc['precio'],
        quantity: 1,
        ingredients: ingredients,
        about: doc['about'],
      ));
    }
  }

  return pizzas;
}

static Future<List<Pizza>> getBebidas() async {
  List<String> ids = ['bebida1', 'bebida2', 'bebida3'];
  List<Pizza> bebidas= [];

  for (String id in ids) {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('productos').doc(id).get();
    if (doc.exists) {
      bebidas.add(Pizza(
        id: doc.id,
        imgUrl: doc['img'],
        name: doc['nombre'],
        price: doc['precio'],
        quantity: 1,
        ingredients: [],
        about: doc['about'],
      ));
    }
  }

  return bebidas;
}


  void setQuantity(int quantity) {
  this.quantity = quantity;
  } 
}
