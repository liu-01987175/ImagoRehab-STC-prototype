// backend/server.js

/**
 * Express proxy for Vertex AI’s Gemini 2.0 Flash-Lite model,
 * using an explicit keyFilename so we don’t need GOOGLE_APPLICATION_CREDENTIALS.
 */

const path           = require('path');
const express        = require('express');
const axios          = require('axios');
const cors           = require('cors');
const { GoogleAuth } = require('google-auth-library');

const app  = express();
const port = 3000;

// Point directly at your downloaded service-account JSON:
const auth = new GoogleAuth({
  keyFilename: path.join(__dirname, 'service_account.json'),
  scopes:     ['https://www.googleapis.com/auth/cloud-platform'],
});

app.use(cors());
app.use(express.json());

app.post('/generate-content', async (req, res) => {
  const prompt = req.body.prompt;
  console.log('→ Received prompt:', prompt);

  try {
    // Your GCP project ID and region
    const project  = 'ornate-hour-455923-f6';
    const location = 'us-central1';

    const url =
      `https://${location}-aiplatform.googleapis.com/v1/` +
      `projects/${project}/locations/${location}/publishers/google/` +
      `models/gemini-2.0-flash-lite:generateContent`;

    // This will load your service_account.json automatically:
    const client = await auth.getClient();
    const { token } = await client.getAccessToken();

    const payload = {
      contents: [
        { role: 'user', parts: [{ text: prompt }] }
      ],
      systemInstruction: {
        role: 'system',
        parts: [
          {
            text: 'You are an occupational therapist. Provide a clear, week-by-week home action plan for stroke recovery.'
          }
        ]
      },
      generationConfig: {
        temperature:     1.0,
        maxOutputTokens: 1024,
      },
    };

    const apiRes = await axios.post(url, payload, {
      headers: {
        'Content-Type':  'application/json',
        Authorization:   `Bearer ${token}`,
      },
    });

    console.log('← Gemini responded:', apiRes.data);
    res.json(apiRes.data);

  } catch (err) {
    console.error('*** Error calling Gemini:', err.response?.data || err.message);
    res.status(500).json({ error: err.response?.data || err.message });
  }
});

app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
});
