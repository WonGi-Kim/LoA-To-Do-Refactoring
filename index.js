/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const firestore = admin.firestore();

// 첫 번째 데이터 초기화 함수 - 24시간마다 실행
exports.resetToDoInfoHourly = functions.pubsub
  .schedule("every day 06:00")
  .timeZone("Asia/Seoul")
  .onRun(async (context) => {
    try {
      // characters 컬렉션의 모든 문서를 가져옴
      const querySnapshot = await firestore.collection("ManageCharacter").get();

      // 모든 문서에 대해 초기화 작업 수행
      const promises = querySnapshot.docs.map(async (doc) => {
        const docRef = firestore.collection("ManageCharacter").doc(doc.id);
        await docRef.update({
          isGuardianRaidDone: false,
          isChaosDungeonDone: false

        });
        console.log(`Data for document ${doc.id} reset successful.`);
      });

      // 모든 초기화 작업이 완료될 때까지 기다림
      await Promise.all(promises);

      return null;
    } catch (error) {
      console.error("Error resetting data:", error);
      return null;
    }
  });

// 두 번째 데이터 초기화 함수 - 일주일중 수요일 마다 실행
exports.resetToDoInfoWeekly = functions.pubsub
  .schedule("0 6 * * 4") // 수요일 06시 초기화 cron형식
  .timeZone("Asia/Seoul")
  .onRun(async (context) => {
    try {
      // ManageCharacter 컬렉션의 모든 문서를 가져옴
      const querySnapshot = await firestore.collection("ManageCharacter").get();

      // 모든 문서에 대해 초기화 작업 수행
      const promises = querySnapshot.docs.map(async (doc) => {
        const docRef = firestore.collection("ManageCharacter").doc(doc.id);
        await docRef.update({
          "chaosDungeon": false,
          "guardianRaid": false,
          "valtanRaid": false,
          "viakissRaid": false,
          "koukuRaid": false,
          "abrelRaid": false,
          "iliakanRaid": false,
          "kamenRaid": false,
          "abyssRaid": false,
          "abyssDungeon": false

        });
        console.log(`Data for document ${doc.id} reset successful.`);
      });

      // 모든 초기화 작업이 완료될 때까지 기다림
      await Promise.all(promises);

      return null;
    } catch (error) {
      console.error("Error resetting data:", error);
      return null;
    }
  });



