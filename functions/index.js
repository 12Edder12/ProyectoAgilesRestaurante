/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.enviarNotificacionNuevoPedido = functions.firestore
  .document('pedidos/{pedidoId}')
  .onCreate(async (snapshot, context) => {
    const pedido = snapshot.data();

    // Mensaje de notificación
    const payload = {
      notification: {
        title: 'Nuevo Pedido!',
        body: `Se ha ingresado un nuevo pedido: ${pedido.detalles}`,
      },
    };

    // Enviar notificación a todos los dispositivos suscritos
    const tokens = await obtenerTodosLosTokensDeDispositivos();
    return admin.messaging().sendToDevice(tokens, payload);
  });

async function obtenerTodosLosTokensDeDispositivos() {
  const tokens = [];
  const dispositivos = await admin.firestore().collection('tokens').get();

  dispositivos.forEach((dispositivo) => {
    tokens.push(dispositivo.data().token);
  });

  return tokens;
}

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
