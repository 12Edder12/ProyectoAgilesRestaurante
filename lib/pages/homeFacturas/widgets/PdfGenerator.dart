import 'dart:io';
import 'dart:typed_data';
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
    // Crear el documento PDF
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();

    //NOMBRE DEL RESTAURANTE Y LOGO DEL MISMO
    page.graphics.drawString(
        "PIZZERIA GUERRIN",
        PdfStandardFont(PdfFontFamily.timesRoman, 50),
        bounds: ui.Rect.fromLTWH(0, 0, 250, 0)
    );
    //LOGO DEL RESTAURANTE
    page.graphics.drawImage(
      PdfBitmap(await _readImageData('res_logo.png')),
      ui.Rect.fromLTWH(350,0,130,130)
    );
    //LINEA DIVISORA 1
    page.graphics.drawString(
      "----------------------------------------------------------------------------------------------------",
      PdfStandardFont(PdfFontFamily.timesRoman, 20),
      bounds: ui.Rect.fromLTWH(0, 130, 0, 0)
    );
    //INFORMACION DE LA FACTURA
    page.graphics.drawString(
      "Factura: ${fechaNumerica}${numeroFactura}${clienteSeleccionado?['ced_cli']}001FP",
      PdfStandardFont(PdfFontFamily.timesRoman, 15),
      bounds: ui.Rect.fromLTWH(0, 145, 0, 0)
    );


    page.graphics.drawString(
        "Fecha de Facturacion: $formattedDate",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: ui.Rect.fromLTWH(0, 160, 0, 0)
    );

    //INFORMACION DEL CLIENTE
    page.graphics.drawString(
        "Cedula/RUC: ${clienteSeleccionado?['ced_cli']}",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: ui.Rect.fromLTWH(0, 185, 0, 0)
    );
    page.graphics.drawString(
        "Cliente: ${clienteSeleccionado?['nom_cli']} ${clienteSeleccionado?['ape_cli']}",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: ui.Rect.fromLTWH(0, 200, 0, 0)
    );
    page.graphics.drawString(
        "Direccion: ",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: ui.Rect.fromLTWH(0, 215, 0, 0)
    );
    page.graphics.drawString(
        "Correo Electronico: ${clienteSeleccionado?['cor_cli']}",
        PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: ui.Rect.fromLTWH(0, 230, 0, 0)
    );

    //LINEA SEPARADORA
    page.graphics.drawString(
        "----------------------------------------------------------------------------------------------------",
        PdfStandardFont(PdfFontFamily.timesRoman, 20),
        bounds: ui.Rect.fromLTWH(0, 250, 0, 0)
    );


  // INFORMACION DE LOS PRODUCTOS
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2),
    );

    grid.columns.add(count: 4);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Cantidad';
    header.cells[1].value = 'Nombre del Producto';
    header.cells[2].value = 'Precio Unitario';
    header.cells[3].value = 'Total';

    // FOR PARA CONTABILIZAR LOS PRODUCTOS
    List<Map<String, dynamic>> productose = (detallesPedido['productos'] as List).cast<Map<String, dynamic>>();
    for (var producto in productose) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = producto['cantidad'].toString();
      row.cells[1].value = producto['nombre'];
      row.cells[2].value = producto['precio'].toString();
      row.cells[3].value = producto['totalProducto'].toString();
      totalFactura= totalFactura+producto['totalProducto'];
      print(producto);
    }

    grid.draw(page: page, bounds: ui.Rect.fromLTWH(0, 280, 0, 0));

    //LINEA SEPARADORA DE LOS PRODUCTOS Y EL TOTAL
    page.graphics.drawString(
        "----------------------------------------------------------------------------------------------------",
        PdfStandardFont(PdfFontFamily.timesRoman, 20),
        bounds: ui.Rect.fromLTWH(0, 620, 0, 0)
    );

    // Crear el PdfGrid
    PdfGrid totalGrid = PdfGrid();
    totalGrid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2),
    );

    totalGrid.columns.add(count: 2);
    PdfGridRow totalRow = totalGrid.rows.add();

    totalRow.cells[0].value = 'Total Factura';
    totalRow.cells[1].value = totalFactura.toString();

// Dibujar el grid en la página
    totalGrid.draw(page: page, bounds: ui.Rect.fromLTWH(300, 640, 500, 0));

    //PIE DE PAGINA DE LA FACTURA
    //LINEA SEPARADORA
    page.graphics.drawString(
        "----------------------------------------------------------------------------------------------------",
        PdfStandardFont(PdfFontFamily.timesRoman, 20),
        bounds: ui.Rect.fromLTWH(0, 650, 0, 0)
    );
    page.graphics.drawString(
        "PIZZERIA GUERRIN",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: ui.Rect.fromLTWH(0, 665, 0, 0)
    );
    page.graphics.drawString(
        "Direccion: Ennrique Segoviano",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: ui.Rect.fromLTWH(0, 680, 0, 0)
    );

    page.graphics.drawString(
        "Telefono 0963307063",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: ui.Rect.fromLTWH(0, 695, 0, 0)
    );
    page.graphics.drawString(
        "RUC: 0296537341001",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: ui.Rect.fromLTWH(0, 710, 0, 0)
    );
    page.graphics.drawString(
        "Correo: pizzeriaguerrin@gmail.com",
        PdfStandardFont(PdfFontFamily.timesRoman, 12),
        bounds: ui.Rect.fromLTWH(0, 725, 0, 0)
    );
    //FIN DEL DOCUMENTO
    try {
      // Obtener el directorio de documentos (o cualquier otro directorio apropiado)
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/example.pdf'; // Ruta completa al archivo PDF

      // Guardar el PDF en el directorio obtenido
      final List<int> bytes = await document.save();
      final File file = File(path);
      await file.writeAsBytes(bytes);

      // Mostrar un mensaje (esto es opcional, puedes eliminarlo si lo deseas)
      print('PDF generado en $path');
      saveAndLaunchFile(bytes, "Output.pdf");
      // Cierra el documento
      document.dispose();
    } catch (error) {
      print('Error al guardar el archivo PDF: $error');
    }
  }
}


Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load('lib/img/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}