const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

app.use(helmet());
app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

app.get('/', (req, res) => {
  res.json({
    message: 'RealWorld API',
    version: '1.0.0',
    endpoints: ['/health', '/api/tags', '/api/articles']
  });
});

app.get('/api/tags', (req, res) => {
  res.json({
    tags: ['nodejs', 'express', 'jenkins', 'aws', 'devops']
  });
});

app.get('/api/articles', (req, res) => {
  res.json({
    articles: [
      {
        slug: 'sample-article',
        title: 'Sample Article',
        description: 'This is a sample article for the RealWorld demo',
        body: 'Article content here...',
        tagList: ['nodejs', 'express'],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        favorited: false,
        favoritesCount: 0,
        author: {
          username: 'demo',
          bio: 'Demo user',
          image: 'https://via.placeholder.com/150',
          following: false
        }
      }
    ],
    articlesCount: 1
  });
});

app.get('/api/articles/feed', (req, res) => {
  res.json({
    articles: [],
    articlesCount: 0
  });
});

app.post('/api/users/login', (req, res) => {
  res.status(401).json({
    errors: { body: ['Email or password is invalid'] }
  });
});

app.post('/api/users', (req, res) => {
  res.status(422).json({
    errors: { body: ['Registration not implemented in demo'] }
  });
});

app.get('/api/user', (req, res) => {
  res.status(401).json({
    errors: { body: ['Unauthorized'] }
  });
});

app.use((req, res) => {
  res.status(404).json({
    message: 'Endpoint not found',
    availableEndpoints: ['/health', '/api/tags', '/api/articles']
  });
});

app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  res.status(500).json({
    message: 'Internal server error',
    error: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

const server = app.listen(PORT, HOST, () => {
  console.log(`Server running on http://${HOST}:${PORT}`);
});

process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
  });
});
