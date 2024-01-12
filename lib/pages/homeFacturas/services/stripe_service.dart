import 'dart:convert';

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
  
  ///productos
  static Future<List<dynamic>> getLineItems(String sessionId) async {
    final url = Uri.parse(
        'https://api.stripe.com/v1/checkout/sessions/$sessionId/line_items');
    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer sk_test_51OVR6tILXmRhmPFRXetwJXugUYnsAGU1zJqHRDKoQ4sHI2HmaevTrx0YF3pJpagk5rjGToC7fLIk20gzfrlGtbNi00EeE6PjQ9',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Line items: ${data['data']}'); // Imprimir los ítems de línea
      return data['data']; // Los ítems de línea están en el campo 'data'.
    } else {
      throw Exception('Failed to retrieve line items: ${response.body}');
    }
  }

Future<void> createInvoiceForSession(Map<String, dynamic> session) async {
 
    var customerId = session['customer'];
    List<dynamic> lineItems = await getLineItems(session['id']);
    // Crear los ítems de la factura
    for (var item in lineItems) {
      int amount = item['amount_total'];
      String currency = item['currency'] ?? 'usd';
    
      await http.post(
        Uri.parse('https://api.stripe.com/v1/invoiceitems'),
        headers: {
          'Authorization': 'Bearer sk_test_51OVR6tILXmRhmPFRXetwJXugUYnsAGU1zJqHRDKoQ4sHI2HmaevTrx0YF3pJpagk5rjGToC7fLIk20gzfrlGtbNi00EeE6PjQ9',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'customer': customerId,
          'amount': amount.toString(),
          'currency': currency,
        },
      );
    }
  
    // Crear la factura
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/invoices'),
      headers: {
        'Authorization':
            'Bearer sk_test_51OVR6tILXmRhmPFRXetwJXugUYnsAGU1zJqHRDKoQ4sHI2HmaevTrx0YF3pJpagk5rjGToC7fLIk20gzfrlGtbNi00EeE6PjQ9',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'customer': customerId,
        'auto_advance': 'true', // Para que la factura se pague automáticamente
        'collection_method': 'charge_automatically',
      },
    );

    if (response.statusCode == 200) {
      // Finalizar enviando la factura al cliente vía email
      var invoice = json.decode(response.body);
      sendInvoiceByEmail(invoice['id']);
    }
    
}

  // Función para enviar la factura por correo electrónico
Future<void> sendInvoiceByEmail(String invoiceId) async {
  final response = await http.post(
    Uri.parse('https://api.stripe.com/v1/invoices/$invoiceId/send'),
    headers: {
      'Authorization':
          'Bearer sk_test_51OVR6tILXmRhmPFRXetwJXugUYnsAGU1zJqHRDKoQ4sHI2HmaevTrx0YF3pJpagk5rjGToC7fLIk20gzfrlGtbNi00EeE6PjQ9',
      'Content-Type': 'application/x-www-form-urlencoded'
    },
  );

  if (response.statusCode == 200) {
    print('*****************************************La factura se envió correctamente al correo del cliente.');
  } else {
    print('**********************************Hubo un error al enviar la factura: ${response.body}');
  }
}
}
