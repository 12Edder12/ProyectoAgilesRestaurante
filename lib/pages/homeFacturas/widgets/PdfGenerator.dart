import 'dart:io';
import 'package:Pizzeria_Guerrin/services/mobileFiles.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

class PdfGenerator {
  static Future<void> generatePDF() async {
    // Crear el documento PDF
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    final PdfGraphics graphics = page.graphics;
    graphics.drawString('Hola, este es un PDF generado desde Flutter', PdfStandardFont(PdfFontFamily.helvetica, 20));

    try {
      // Obtener el directorio de documentos (o cualquier otro directorio apropiado)
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/example.pdf';  // Ruta completa al archivo PDF

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
