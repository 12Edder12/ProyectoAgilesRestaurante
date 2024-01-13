import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF y Email',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<void> _generateAndSendPDF() async {
    // Crear el PDF
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Center(child: pw.Text('Hola, este es un PDF generado desde Flutter')),
    ));

    // Guardar el PDF temporalmente
    final output = await File("example.pdf").create();
    await output.writeAsBytes(await pdf.save());

    // Configurar y enviar el correo electrónico
    final smtpServer = gmail('your-email@gmail.com', 'your-password');
    final message = Message()
      ..from = Address('your-email@gmail.com', 'Your Name')
      ..recipients.add('recipient-email@example.com')
      ..subject = 'PDF generado desde Flutter'
      ..text = 'Adjunto encontrarás el PDF generado.'
      ..attachments.add(FileAttachment(File("example.pdf")));

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar PDF y enviar por email'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _generateAndSendPDF,
          child: Text('Generar y Enviar PDF'),
        ),
      ),
    );
  }
}
