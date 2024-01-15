import 'package:cloud_firestore/cloud_firestore.dart';

class ClientService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('clientes');

  Future<void> updateClient(String idFirebase, Map<String, dynamic> nuevosDatos) async {
    try {
      // Referencia al documento que quieres actualizar
      DocumentReference clienteRef = FirebaseFirestore.instance.collection('clientes').doc(idFirebase);

      // Actualiza los datos en el documento
      await clienteRef.update(nuevosDatos);

      print('Información actualizada con éxito en Firebase.');
    } catch (e) {
      print('Error al actualizar la información en Firebase: $e');
    }
  }

  Future<void> deleteClient(String id) async {
    await _usersCollection.doc(id).update({
      'est_user': "0",
      'cargo': "No definido",
    });
  }
}
