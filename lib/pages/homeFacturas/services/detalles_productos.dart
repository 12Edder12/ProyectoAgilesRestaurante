import 'package:cloud_firestore/cloud_firestore.dart';

Future<double> obtenerTotalPorMesa(int numeroMesa) async {
  var pedidosRef = FirebaseFirestore.instance.collection('pedidos');
  var productosRef = FirebaseFirestore.instance.collection('productos');

  Map<String, dynamic> resultado = {
    'productos': [],
    'total': 0.0,
  };

  try {
    var pedidos = await pedidosRef
        .where('num_mesa', isEqualTo: numeroMesa)
        .where('pagado', isEqualTo: false)
        .get();

    // Mapa para realizar un seguimiento de la cantidad de cada producto
    Map<String, double> cantidadProductos = {};

    for (var pedido in pedidos.docs) {
      var detallePedido = pedido.data()['detalle_pedido'];

      for (String idProducto in detallePedido.keys) {
        var cantidad = detallePedido[idProducto]['cantidad'];

        // Verifica si el producto ya está en el mapa
        if (cantidadProductos.containsKey(idProducto)) {
          // Si existe, suma la cantidad
          cantidadProductos[idProducto] = (cantidadProductos[idProducto] ?? 0) + cantidad;

        } else {
          // Si no existe, agrega el producto al mapa
          cantidadProductos[idProducto] = cantidad.toDouble();
        }
      }
    }

    // Ahora, construye la lista de productos con las cantidades sumadas
    for (String idProducto in cantidadProductos.keys) {
      var producto = await productosRef.doc(idProducto).get();
      var precio = producto.data()?['precio'];
      var nombreProducto = producto.data()?['nombre'];

      double totalProducto = precio.toDouble() * cantidadProductos[idProducto];
      resultado['total'] += totalProducto;

      resultado['productos'].add({
        'nombre': nombreProducto,
        'cantidad': cantidadProductos[idProducto],
        'precioUnitario': precio, // Agrega el precio unitario del producto
        'totalProducto': totalProducto,
      });
    }
  } catch (e) {
    print('Ocurrió un error: $e');
  }

  return double.parse(resultado['total'].toStringAsFixed(2));
}

Future<Map<String, dynamic>> obtenerPedidosPorMesa(int numeroMesa) async {
  var pedidosRef = FirebaseFirestore.instance.collection('pedidos');
  var productosRef = FirebaseFirestore.instance.collection('productos');

  Map<String, dynamic> resultado = {
    'productos': [],
    'total': 0.0,
  };

  try {
    var pedidos = await pedidosRef
        .where('num_mesa', isEqualTo: numeroMesa)
        .where('pagado', isEqualTo: false)
        .get();

    // Mapa para realizar un seguimiento de la cantidad de cada producto
    Map<String, double> cantidadProductos = {};

    for (var pedido in pedidos.docs) {
      var detallePedido = pedido.data()['detalle_pedido'];

      for (String idProducto in detallePedido.keys) {
        var cantidad = detallePedido[idProducto]['cantidad'];

        // Verifica si el producto ya está en el mapa
        if (cantidadProductos.containsKey(idProducto)) {
          // Si existe, suma la cantidad
      cantidadProductos[idProducto] = (cantidadProductos[idProducto] ?? 0) + cantidad;

        } else {
          // Si no existe, agrega el producto al mapa
          cantidadProductos[idProducto] = cantidad.toDouble();
        }
      }
    }

    // Ahora, construye la lista de productos con las cantidades sumadas
    for (String idProducto in cantidadProductos.keys) {
      var producto = await productosRef.doc(idProducto).get();
      var precio = producto.data()?['precio'];
      String nombreProducto = producto.data()?['nombre'];

      double totalProducto = precio.toDouble() * cantidadProductos[idProducto];
      resultado['total'] += totalProducto;

      resultado['productos'].add({
        'nombre': nombreProducto,
        'cantidad': cantidadProductos[idProducto],
        'precio': precio,
        'totalProducto': totalProducto,
      });
    }
  } catch (e) {
    print('Ocurrió un error: $e');
  }

  return resultado;
}