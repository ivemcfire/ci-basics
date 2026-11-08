import http from 'node:http';
import { sum } from './sum.js';

const port = process.env.PORT || 8080;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(`ci-basics ok · 2+3=${sum(2, 3)} · sha=${process.env.GIT_SHA ?? 'dev'}\n`);
}).listen(port, () => console.log(`listening on ${port}`));