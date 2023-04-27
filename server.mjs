import express from "express";
import webpush from "web-push";
import dotenv from "dotenv";
import fs from 'fs';
import https from 'https';

dotenv.config();

const app = express();

app.use(express.json());

let subscriptionData = null;

webpush.setVapidDetails(
  `mailto:${process.env.VAPID_MAILTO}`,
  process.env.VAPID_PUBLIC_KEY,
  process.env.VAPID_PRIVATE_KEY
)

app.get('/send-notification', (req, res) => {
  webpush.sendNotification(subscriptionData, JSON.stringify({
    title: "Notificación de prueba",
    body: "Esta es una notificación de prueba",
    icon: "https://www.arsys.es/blog/file/uploads/2019/05/que-es-una-aplicacion-web-progresiva-1.jpg"
  }))
  .catch(err => console.error(err));

  res.sendStatus(200);
})

app.post("/save-subscription", async (req, res) => {
  subscriptionData = req.body;
  res.sendStatus(200);
});

app.use(express.static("./public"));

const privateKey = fs.readFileSync('./certs/server.key', 'utf8');
const certificate = fs.readFileSync('./certs/server.pem', 'utf8');
const credentials = { key: privateKey, cert: certificate };

const httpsServer = https.createServer(credentials, app);

httpsServer.listen(443, () => {
  console.log('Servidor HTTPS en https://10.210.50.134:443');
});
