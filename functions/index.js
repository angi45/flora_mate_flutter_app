import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

export const dailyPlantReminder = functions.pubsub
  .schedule("*/1 * * * *")
  .timeZone("Europe/Skopje")
  .onRun(async (context) => {
    console.log("Running daily plant reminder...");

    const tokensSnapshot = await admin.firestore().collection('users').get();

    const tokens: string[] = [];
    tokensSnapshot.forEach(doc => {
      const token = doc.data().fcmToken;
      if(token) tokens.push(token);
    });

    if(tokens.length === 0){
      console.log("No FCM tokens found");
      return null;
    }

    const message = {
      notification: {
        title: "🌱 Plant Reminder",
        body: "Check your plants! 🌿",
      },
      tokens: tokens,
    };

    const response = await admin.messaging().sendMulticast(message);
    console.log(`Notifications sent: ${response.successCount} successful, ${response.failureCount} failed`);
  });
