const serverless = require('serverless-http');
const app = require('./patient-service'); // or './appointment-service'
exports.handler = serverless(app);
