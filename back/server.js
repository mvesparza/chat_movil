const express = require('express');
const cors = require('cors');
const admin = require('firebase-admin');

// Inicializar Firebase con las credenciales del serviceAccountKey.json
const serviceAccount = require('./chatenvivo-a1ae1-firebase-adminsdk-fbsvc-92812cc30c.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const app = express();
app.use(express.json());
app.use(cors()); // Permitir acceso desde cualquier IP

const PORT = 8002;

// Endpoint para obtener los mensajes
app.get('/messages', async (req, res) => {
  const snapshot = await db.collection('mensajes').orderBy('hora').get();
  const mensajes = snapshot.docs.map(doc => doc.data());
  res.json(mensajes);
});

// Endpoint para enviar un mensaje
app.post('/messages', async (req, res) => {
  const { remitente, texto } = req.body;
  if (!remitente || !texto) return res.status(400).json({ error: 'Datos incompletos' });

  const mensaje = {
    remitente,
    texto,
    hora: new Date().toISOString()
  };

  await db.collection('mensajes').add(mensaje);
  res.json({ success: true, mensaje });
});

// Iniciar el servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en http://10.40.25.88:${PORT}`);
});
