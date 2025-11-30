const serverless = require('serverless-http');
const app = require('./patient-service');
exports.handler = serverless(app);
