const express = require("express");
const admin = require("firebase-admin");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

require("dotenv").config()

const serviceAccount = JSON.parse(process.env.FirebaseServiceAccount);

const { createClient } = require("@supabase/supabase-js")

const supabase= createClient(
  process.env.SUPABASE_URL
  , process.env.SUPABASE_KEY);


admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();


app.get("/", (req, res) => {
  
  res.send("dah hosting free 🚀");

});

app.post("/test-notification"
  ,async(req,res)=>{

  const {token,title,body}=req.body;
  try{
    await sendNotification(
      token
      ,title
      ,body,
    );

    res.json({ success: true, message: "Notification sent successfully" });
  }catch(e){
    res.status(500).json({ error: e.message });
  }

});



async function sendNotification(token,title, body) {

  const message = {
   notification:{
    title:title,
    body:body
   },
   token:token
  }
  try {
    await admin.messaging().send(message);
    console.log("Notification sent successfully");
  } catch (error) {
    console.error("Error sending notification:", error);
  }

}

app.post("/save-token", async (req, res) => {
  try {
    const { user_id, token, device_type } = req.body;

    if (!token) {
      return res.status(400).json({ error: "Token is required" });
    }

   
    const { data, error } = await supabase
     
        .from("user_devices")
      .upsert(
        {

          user_id: user_id ?? null,
          token: token,
          device_type: device_type ?? "android",
        },
         
      { onConflict: "token" }
 

      );

    if (error) throw error;

    res.json({
      success: true,
      message: "Token saved successfully 🚀",
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


app.get("/test-db", async (req, res) => {
  try {
    const { data, error } = await supabase.from("user_devices").select("*");
    if (error) throw error;
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});




const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});