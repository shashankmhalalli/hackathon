const serverless = require('serverless-http');
const app = require('appointment-service');
exports.handler = serverless(app);
