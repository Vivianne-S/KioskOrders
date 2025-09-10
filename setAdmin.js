const admin = require("firebase-admin");

// 🔑 Ladda service account key
const serviceAccount = require("./serviceAccountKey.json");

// Initiera Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Byt UID till admin@admin.se:s UID
const uid = "CqUf0RLN2IUh6pF8ls03Ovwy1mz2";

async function setAdmin() {
  try {
    await admin.auth().setCustomUserClaims(uid, { admin: true });
    console.log(`✅ Admin claim satt på UID=${uid}`);
    process.exit(0);
  } catch (err) {
    console.error("❌ Fel:", err);
    process.exit(1);
  }
}

setAdmin();
