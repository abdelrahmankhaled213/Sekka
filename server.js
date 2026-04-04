const express = require("express");
const admin = require("firebase-admin");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());


const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();


app.get("/", (req, res) => {
  res.send("Transport backend running 🚀");
});


app.post("/addStation", async (req, res) => {
  try {
    const { name, lat, lng } = req.body;

    const doc = await db.collection("stations").add({
      name,
      lat,
      lng,
      createdAt: new Date(),
    });

    res.json({ success: true, id: doc.id });
  } catch (e) {
    res.status(500).json({ error: e.message });
    
  }
});


app.post("/saveToken", async (req, res) => {
  try {

    const { userId, token } = req.body;

    await db.collection("users").doc(userId).set({
      fcmToken: token,
    });

    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});



app.listen(3000, () => {
  console.log("Server running on port 3000");
});