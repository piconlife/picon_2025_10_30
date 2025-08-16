const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.getNearbyLocations = functions.https.onCall(async (data, context) => {
  const lat = data.lat;       // user latitude
  const lon = data.lon;       // user longitude
  const radius = data.radius || 5; // km
  const typeFilter = data.type;    // optional
  const statusFilter = data.status; // optional

  const locationsRef = admin.firestore().collection("locations");

  // 🔹 Step 1: Bounding Box (Firestore query)
  const latDegree = radius / 111.32;
  const lonDegree = radius / (111.32 * Math.cos(lat * Math.PI / 180));

  const minLat = lat - latDegree;
  const maxLat = lat + latDegree;
  const minLon = lon - lonDegree;
  const maxLon = lon + lonDegree;

  // 🔹 Step 2: Firestore query
  let query = locationsRef
      .where("lat", ">=", minLat)
      .where("lat", "<=", maxLat)
      .where("lon", ">=", minLon)
      .where("lon", "<=", maxLon);

  if(typeFilter){
      query = query.where("type", "==", typeFilter);
  }
  if(statusFilter){
      query = query.where("status", "==", statusFilter);
  }

  const snapshot = await query.get();
  const results = [];

  // 🔹 Step 3: Actual radius filter (manual calculation)
  snapshot.forEach(doc => {
    const data = doc.data();
    const dLat = (data.lat - lat) * Math.PI / 180;
    const dLon = (data.lon - lon) * Math.PI / 180;
    const a = Math.sin(dLat/2)**2 + Math.cos(lat*Math.PI/180) * Math.cos(data.lat*Math.PI/180) * Math.sin(dLon/2)**2;
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    const distance = 6371 * c; // distance in km

    if(distance <= radius){
      results.push({...data, distance});
    }
  });

  // 🔹 Optional: sort by distance
  results.sort((a, b) => a.distance - b.distance);

  return results;
});
