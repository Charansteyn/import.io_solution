"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const winston_1 = __importDefault(require("winston"));
const express_winston_1 = __importDefault(require("express-winston"));
const app = (0, express_1.default)();
const PORT = 3000;
app.use(express_winston_1.default.logger({
    transports: [
        new winston_1.default.transports.Console()
    ],
    meta: false,
    msg: "HTTP  ",
    expressFormat: true,
    colorize: false,
    ignoreRoute: function (req, res) { return false; }
}));
app.get('/', (req, res) => {
    res.send('You have successfully run the import.io application!');
});
app.get('/import/:userId', function (req, res) {
    res.send(req.params);
});
app.all('*', function (req, res, next) {
    res.send(req.params);
});
app.listen(PORT, () => {
    console.log(`Express server is listening at ${PORT}`);
});
