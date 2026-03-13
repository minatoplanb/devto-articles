const fs = require('fs');
const https = require('https');
const path = require('path');

// Load env
const envPath = path.join(__dirname, '.env');
const env = fs.readFileSync(envPath, 'utf8');
const apiKey = env.match(/DEVTO_API_KEY=(.+)/)[1].trim();

// Read article
const articlePath = process.argv[2];
if (!articlePath) { console.error('Usage: node publish.js <article.md>'); process.exit(1); }

const content = fs.readFileSync(articlePath, 'utf8');
const lines = content.split('\n');

// Parse frontmatter
let fmEnd = 0, count = 0;
for (let i = 0; i < lines.length; i++) {
  if (lines[i].trim() === '---') { count++; if (count === 2) { fmEnd = i; break; } }
}

// Extract frontmatter fields
const fm = lines.slice(1, fmEnd).join('\n');
const title = fm.match(/title:\s*"(.+)"/)?.[1] || 'Untitled';
const desc = fm.match(/description:\s*"(.+)"/)?.[1] || '';
const tagsMatch = fm.match(/tags:\s*\[(.+)\]/) || fm.match(/tags:\s*(.+)/);
const tags = tagsMatch ? tagsMatch[1].split(',').map(t => t.trim().replace(/[\[\]"']/g, '')) : [];
const published = fm.includes('published: true');

const bodyMarkdown = lines.slice(fmEnd + 1).join('\n').trim();

const payload = JSON.stringify({
  article: {
    title,
    published,
    body_markdown: bodyMarkdown,
    description: desc,
    tags
  }
});

const options = {
  hostname: 'dev.to',
  path: '/api/articles',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'api-key': apiKey,
    'User-Agent': 'DevToPublisher/1.0',
    'Content-Length': Buffer.byteLength(payload)
  }
};

const req = https.request(options, (res) => {
  const chunks = [];
  res.on('data', c => chunks.push(c));
  res.on('end', () => {
    const raw = Buffer.concat(chunks).toString();
    console.log('Status:', res.statusCode);
    try {
      const data = JSON.parse(raw);
      if (data.url) {
        console.log('Published! URL:', data.url);
      } else if (data.error) {
        console.log('Error:', data.error, data.status);
      } else {
        console.log(JSON.stringify(data, null, 2).substring(0, 500));
      }
    } catch (e) {
      console.log('Raw response:', raw.substring(0, 500));
    }
  });
});

req.on('error', e => console.error('Request error:', e.message));
req.write(payload);
req.end();
