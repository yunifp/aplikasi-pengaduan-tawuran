const admin = require('firebase-admin');

const serviceAccount = require('./serviceAccountKey.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const uidToMakeAdmin = 'KB4Lxfuk0RYMjT97TTrYyrgPhdw2';

admin.auth().setCustomUserClaims(uidToMakeAdmin, { admin: true })
  .then(() => {
    console.log(`Sukses! Pengguna dengan UID: ${uidToMakeAdmin} sekarang adalah admin.`);
    process.exit(0);
  })
  .catch(error => {
    console.error('Error setting custom claims:', error);
    process.exit(1);
  });