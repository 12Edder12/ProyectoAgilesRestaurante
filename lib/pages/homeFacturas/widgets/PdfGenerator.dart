import 'dart:io';
import 'dart:typed_data';
import 'package:Pizzeria_Guerrin/pages/homeMesero/tomar_mesa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Pizzeria_Guerrin/constants/globals.dart';
import '../../../services/mobileFiles.dart';



class PdfGenerator {

  static Future<void> generatePDF(Future<Map<String, dynamic>> productosFuture, Future<double> totalesDeLaMesa) async {
    Map<String, dynamic> detallesPedido = await productosFuture;
    await initializeDateFormatting('es');
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM y', 'es').format(currentDate);
    String fechaNumerica = DateFormat('yyyyMMdd').format(currentDate);
    double totalFactura = 0;
    String IDFactura = "Factura: ${fechaNumerica}${numeroFactura}${clienteSeleccionado?['ced_cli']}001FP";
    String IDFactura1 = "${fechaNumerica}${numeroFactura}${clienteSeleccionado?['ced_cli']}001FP";
    double PreciosinIVA = 0;
    double iva = 0;
    double totalIva = 0;
    double ivapersonal = 0;

    // Crear el documento PDF
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();

    //NOMBRE DEL RESTAURANTE Y LOGO DEL MISMO
    page.graphics.drawString(
        "PIZZERIA GUERRIN",
        PdfStandardFont(PdfFontFamily.timesRoman, 50),
        bounds: const ui.Rect.fromLTWH(0, 0, 250, 0)
    );
    //LOGO DEL RESTAURANTE
    page.graphics.drawImage(
      PdfBitmap(await _readImageData('res_logo.png')),
     const  ui.Rect.fromLTWH(350,0,130,130)
    );
    //LINEA DIVISORA 1
    page.graphics.drawString(
      "----------------------------------------------------------------------------------------------------",
      PdfStandardFont(PdfFontFamily.timesRoman, 20),
      bounds:const  ui.Rect.fromLTWH(0, 130, 0, 0)
    );
    //INFORMACION DE LA FACTURA
    page.graphics.drawString(
      IDFactura,
      PdfStandardFont(PdfFontFamily.timesRoman, 15),
      bounds:const  ui.Rect.fromLTWH(0, 145, 0, 0)
    );


    page.graphics.drawString(
        "Fecha de Facturacion: $formattedDate",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: const ui.Rect.fromLTWH(0, 160, 0, 0)
    );

    
    if(datosFactura['met_pag']==0){
      page.graphics.drawString(
          "Metodo de pago: Pago en Efectivo",
          PdfStandardFont(PdfFontFamily.timesRoman, 15),
          bounds: const  ui.Rect.fromLTWH(0, 185, 0, 0)
      );
    }else{
      page.graphics.drawString(
          "Metodo de pago: Stripe",
          PdfStandardFont(PdfFontFamily.timesRoman, 15),
          bounds:const  ui.Rect.fromLTWH(0, 185, 0, 0)
      );
    }
    
    //INFORMACION DEL CLIENTE
    page.graphics.drawString(
        "Cedula/RUC: ${clienteSeleccionado?['ced_cli']}",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds:const  ui.Rect.fromLTWH(0, 200, 0, 0)
    );
    page.graphics.drawString(
        "Cliente: ${clienteSeleccionado?['nom_cli']} ${clienteSeleccionado?['ape_cli']}",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: const ui.Rect.fromLTWH(0, 215, 0, 0)
    );
    page.graphics.drawString(
        "Correo Electronico: ${clienteSeleccionado?['cor_cli']}",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: const ui.Rect.fromLTWH(0, 230, 0, 0)
    );

    //LINEA SEPARADORA
    page.graphics.drawString(
        "----------------------------------------------------------------------------------------------------",
        PdfStandardFont(PdfFontFamily.timesRoman, 20),
        bounds: const ui.Rect.fromLTWH(0, 237, 0, 0)
    );


  // INFORMACION DE LOS PRODUCTOS
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2),
    );

    grid.columns.add(count: 5);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Cantidad';
    header.cells[1].value = 'Nombre del Producto';
    header.cells[2].value = 'Precio Unitario';
    header.cells[3].value = 'IVA';
    header.cells[4].value = 'Total';

    // FOR PARA CONTABILIZAR LOS PRODUCTOS
    List<Map<String, dynamic>> productose = (detallesPedido['productos'] as List).cast<Map<String, dynamic>>();
    for (var producto in productose) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = producto['cantidad'].toString();
      row.cells[1].value = producto['nombre'];

      // Verificar si el tipo es "bebida" para aplicar el IVA
      if (producto['nombre'].toLowerCase().contains('pizza')) {
        iva = 0.00;
        row.cells[3].value = '0.00';
      } else {
        // Si el nombre no contiene "Pizza", poner 0 en la celda de IVA
        iva = (producto['totalProducto'] * (ivaGlobal / 100));
        ivapersonal = (producto['precio'] * (ivaGlobal / 100));
        row.cells[3].value = iva.toStringAsFixed(2);
      }

      PreciosinIVA= (producto['precio']-iva);
      row.cells[2].value = (producto['precio']-ivapersonal).toString();

      totalIva=totalIva+iva;
      row.cells[4].value = (producto['totalProducto']).toStringAsFixed(2);
      totalFactura= totalFactura+producto['totalProducto']-iva;
    }

    grid.draw(page: page, bounds: const ui.Rect.fromLTWH(0, 255, 0, 0));

    //LINEA SEPARADORA DE LOS PRODUCTOS Y EL TOTAL
    page.graphics.drawString(
        "----------------------------------------------------------------------------------------------------",
        PdfStandardFont(PdfFontFamily.timesRoman, 20),
        bounds: const ui.Rect.fromLTWH(0, 570, 0, 0)
    );

    // Crear el PdfGrid
    // Crear el PdfGrid
    PdfGrid totalGrid = PdfGrid();
    totalGrid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2),
    );

    totalGrid.columns.add(count: 2);

// Fila para el Subtotal
    PdfGridRow subtotalRow = totalGrid.rows.add();
    subtotalRow.cells[0].value = 'Subtotal';
    subtotalRow.cells[1].value = totalFactura.toStringAsFixed(2);

// Fila para el IVA
    PdfGridRow ivaRow = totalGrid.rows.add();
    ivaRow.cells[0].value = 'IVA';
    ivaRow.cells[1].value = totalIva.toStringAsFixed(2);

// Fila para el Total Factura
    PdfGridRow totalRow = totalGrid.rows.add();
    totalRow.cells[0].value = 'Total Factura';
    totalRow.cells[1].value = (totalFactura+totalIva).toStringAsFixed(2);

    totalGrid.draw(page: page, bounds: const  ui.Rect.fromLTWH(300, 590, 500, 0));

    //PIE DE PAGINA DE LA FACTURA
    //LINEA SEPARADORA
    page.graphics.drawString(
        "----------------------------------------------------------------------------------------------------",
        PdfStandardFont(PdfFontFamily.timesRoman, 20),
        bounds: const ui.Rect.fromLTWH(0, 650, 0, 0)
    );
    page.graphics.drawString(
        "PIZZERIA GUERRIN",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: const  ui.Rect.fromLTWH(0, 665, 0, 0)
    );
    page.graphics.drawString(
        "Direccion: Av. los Guaytambos, Ambato 180101",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: const  ui.Rect.fromLTWH(0, 680, 0, 0)
    );

    page.graphics.drawString(
        "Telefono 0963307063",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: const  ui.Rect.fromLTWH(0, 695, 0, 0)
    );
    page.graphics.drawString(
        "RUC: 0296537341001",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: const  ui.Rect.fromLTWH(0, 710, 0, 0)
    );
    page.graphics.drawString(
        "Correo: pizzeriaguerrin@gmail.com",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: const  ui.Rect.fromLTWH(0, 725, 0, 0)
    );

  Future<void> saveFacturaToFirebase(Map<String, dynamic> facturaData) async {
    try {
      await FirebaseFirestore.instance.collection('facturas').add(facturaData);
    } catch (error) {
      print('Error al guardar la factura en Firebase: $error');
      // Manejar el error según tus necesidades
    }
  }
double totalNormal = totalFactura; // Tu cálculo del total normal aquí
double total = datosFactura['met_pag'] == 0 ? totalNormal : double.parse((totalNormal * 0.9677).toStringAsFixed(2));

Map<String, dynamic> facturaData = {
      'id_fac': IDFactura1,
      'fec_emi_fac': Timestamp.now(), 
      'num_mes_per': datosFactura['num_mes'], //cambiar
      'total': total,
      'id_cli_fac': clienteSeleccionado?['ced_cli'],
      'met_pag': datosFactura['met_pag'], ///cambiar
      'productos': detallesPedido['productos'],
      'id_emp_fac': datosUsuario['ced_user'], //cambiar 
      'id_stripe': idStripe.value,//cambiar
    };

    await saveFacturaToFirebase(facturaData);


    //FIN DEL DOCUMENTO
    try {
      // Obtener el directorio de documentos (o cualquier otro directorio apropiado)
      final directory = await getApplicationDocumentsDirectory();
      final emailpath =
          '${directory.path}/ReciboFactura.pdf'; // Ruta completa al archivo PDF

      // Guardar el PDF en el directorio obtenido
      final List<int> bytes = await document.save();
      final File file = File(emailpath);
      await file.writeAsBytes(bytes);

      //ENVIO DEL PDF VIA EMAIL
      sendEmail('$emailpath', IDFactura);
      //saveAndLaunchFile(bytes, "Output.pdf");
      actualizarTodo(datosFactura['num_mes']);
      // Cierra el documento
      document.dispose();
    } catch (error) {
    //  print('Error al guardar el archivo PDF: $error');
    }

  }
}

Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load('lib/img/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
sendEmail(String emailpath, String IDFactura) async {
  final Email email = Email(
    body: 'Factura Recibida con el ID $IDFactura',
    subject: 'Factura - Pizzeria Guerrin $IDFactura',
    recipients: ['${clienteSeleccionado?['cor_cli']}'],
    //cc: ['cc@example.com'],
    //bcc: ['bcc@example.com'],
    attachmentPaths: [emailpath],
    isHTML: false,
  );
  await FlutterEmailSender.send(email);
}

Future<void> actualizarTodo(int numMesa) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Actualizar pedidos
  QuerySnapshot pedidosSnapshot = await _firestore
      .collection('pedidos')
      .where('num_mesa', isEqualTo: numMesa)
      .where('pagado', isEqualTo: false)
      .get();

  for (QueryDocumentSnapshot pedidoDoc in pedidosSnapshot.docs) {
    await _firestore
        .collection('pedidos')
        .doc(pedidoDoc.id)
        .update({'pagado': true});
  }

  // Actualizar facturas
  QuerySnapshot facturasSnapshot = await _firestore
      .collection('facturas')
      .where('num_mes_per', isEqualTo: numMesa)
      .get();

  for (QueryDocumentSnapshot facturaDoc in facturasSnapshot.docs) {
    await _firestore
        .collection('facturas')
        .doc(facturaDoc.id)
        .update({'pagado': true});
  }

  // Actualizar tables
  QuerySnapshot tablesSnapshot = await _firestore
      .collection('tables')
      .where('num', isEqualTo: numMesa)
      .get();

  for (QueryDocumentSnapshot tableDoc in tablesSnapshot.docs) {
    await _firestore.collection('tables').doc(tableDoc.id).update({
      'est_tab': true,
      'pagado': true,
    });
  }

  // Actualizar mesas 
  datosFactura = {
  'num_mes': 0,
  'met_pag': 0,
  };

  idStripe.value = '';
  estado_stripe = false;
  Navigator.push(
  tomarMesa!,
  MaterialPageRoute(builder: (context) => const  TomarMesa()),
);
}

