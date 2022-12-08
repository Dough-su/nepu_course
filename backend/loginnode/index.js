const express = require('express');
const { login } = require('./login');
const app = express();
const port = 9000;

app.get('/', (req, res) => {
    login(req,res);
    });
app.listen(port, () => console.log(`Example app listening on port ${port}!`));