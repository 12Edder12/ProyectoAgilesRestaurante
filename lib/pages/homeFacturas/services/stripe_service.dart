import 'dart:convert';

import 'package:Pizzeria_Guerrin/constants/globals.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  String secretKey =
      "sk_test_51OVR6tILXmRhmPFRXetwJXugUYnsAGU1zJqHRDKoQ4sHI2HmaevTrx0YF3pJpagk5rjGToC7fLIk20gzfrlGtbNi00EeE6PjQ9";
  String publishableKey =
      "pk_test_51OVR6tILXmRhmPFR0a3rWTTW4SUX1YFLkjaD6XWmeglplW5kcR49Vr6SutZLVF7tUgwtkqv3cup9pGJeDmABtFKW00iNQTABD6";

  static Future<dynamic> createCheckoutSession(
      List<dynamic> productItems, totalAmount) async {
    try {
      final url = Uri.parse('https://api.stripe.com/v1/checkout/sessions');

      String lineItems = "";
      int index = 0;

      productItems.forEach((val) {
        print('Item actual: $val');
  
  // Imprimir el tipo de dato de cada valor en el mapa
  print('Tipo de dato de productName: ${val["productName"].runtimeType}');
  print('Tipo de dato de productPrice: ${val["productPrice"].runtimeType}');
  print('Tipo de dato de qty: ${val["qty"].runtimeType}');
        var productPrice = (val["productPrice"] * 100).round().toString();
        lineItems +=
            "&line_items[$index][price_data][product_data][name]=${val["productName"]}";
        lineItems +=
            "&line_items[$index][price_data][unit_amount]=$productPrice";
        lineItems += "&line_items[$index][price_data][currency]=USD";
        lineItems += "&line_items[$index][quantity]=${val["qty"].toString()}";

        index++;
      });

      final response = await http.post(
        url,
        body:
            'success_url=https://checkout.stripe.dev/success&cancel_url=https://checkout.stripe.dev/cancel&mode=payment$lineItems',
        headers: {
          'Authorization':
              'Bearer sk_test_51OVR6tILXmRhmPFRXetwJXugUYnsAGU1zJqHRDKoQ4sHI2HmaevTrx0YF3pJpagk5rjGToC7fLIk20gzfrlGtbNi00EeE6PjQ9',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      return json.decode(response.body)["id"];
    } catch (e) {
      print('Ocurrió un error durante la creación de la sesión de pago: $e');
      return null;
    }
  }


  Future<dynamic> stripePaymentCheckout(
    productItems,
    subTotal,
    context,
    mounted, {
    onSucces,
    onCancel,
    onError,
  }) async {
    final String sessionId =
        await createCheckoutSession(productItems, subTotal);

    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey:
          "pk_test_51OVR6tILXmRhmPFR0a3rWTTW4SUX1YFLkjaD6XWmeglplW5kcR49Vr6SutZLVF7tUgwtkqv3cup9pGJeDmABtFKW00iNQTABD6",
      successUrl: 'https://checkout.stripe.dev/success',
      canceledUrl: 'https://checkout.stripe.dev/cancel',
    );

    if (mounted) {
      final text = result.when(
          redirected: () => 'Redireccionando a Stripe',
          success: () {
            getPaymentIntentId(sessionId);
            onSucces();
          },
          canceled: () => onCancel(),
          error: (e) => onError(e));

      return text;
    }
  }

  Future<Map<String, dynamic>> getSessionDetails(String sessionId) async {
    // Obtener los detalles de la sesión del checkout de Stripe
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/checkout/sessions/$sessionId'),
      headers: {
        'Authorization':
            'Bearer sk_test_51OVR6tILXmRhmPFRXetwJXugUYnsAGU1zJqHRDKoQ4sHI2HmaevTrx0YF3pJpagk5rjGToC7fLIk20gzfrlGtbNi00EeE6PjQ9',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.statusCode == 200) {
      var sessionDetails = json.decode(response.body);
      print(
          '---------------Detalles de la sesión: $sessionDetails'); // Imprimir los detalles de la sesión
      return sessionDetails;
    } else {
      throw Exception(
          '*****************************************Failed to retrieve session details');
    }
  }

  void getPaymentIntentId(String sessionId) async {
  Map<String, dynamic> sessionDetails = await getSessionDetails(sessionId);
   idStripe.value = sessionDetails['payment_intent'];
}
  
}
 
