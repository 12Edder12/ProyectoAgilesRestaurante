import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class DetallePedidos extends StatelessWidget {
  final int numero;
  final Map<String, dynamic>? paymenItem;

  const DetallePedidos({Key? key, required this.numero, this.paymenItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de pedidos para la mesa $numero'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Aquí va el contenido para la mesa $numero'),
            ElevatedButton(
              onPressed: makePayment,
              child: Text('Realizar pago'),
            ),
          ],
        ),
      ),
    );
  }

  void makePayment() async {
    try {
      var paymentIntent = await createPaymentItem();

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);

  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        merchantDisplayName: "Nueva empresa",
        googlePay: gpay
    )
);

      displayPaymentSheet();
    } catch (e) {
      throw Exception('---------Error al crear el pago: $e');
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Done");
    } catch (e) {
      throw Exception('Error al mostrar el pago: $e');
    }
  }

  createPaymentItem() async {
    try {
      Map<String, dynamic> body = {
        "amount": "2000",
        "currency": "USD",
        'payment_method_types[]': 'card'
      };

      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51OVR6tILXmRhmPFRXetwJXugUYnsAGU1zJqHRDKoQ4sHI2HmaevTrx0YF3pJpagk5rjGToC7fLIk20gzfrlGtbNi00EeE6PjQ9",
            "Content-Type": "application/x-www-form-urlencoded"
          });

// Imprime la respuesta de la API
      print('*******************************Response status: ${response.statusCode}');
      print('--------------------------------------------------Response body: ${response.body}');
      return json.decode(response.body);
    } catch (e) {
      throw Exception('Error al crear el pago: $e');
    }
  }
}
