// backend/server.js

const path           = require('path');
const express        = require('express');
const axios          = require('axios');
const cors           = require('cors');
const mongoose       = require('mongoose');
const { GoogleAuth } = require('google-auth-library');

const { MONGO_URI } = require('./secrets'); // Atlas URI in secrets.js
const app  = express();
const port = 3000;

// Vertex AI setup
const auth = new GoogleAuth({
  keyFilename: path.join(__dirname, 'service_account.json'),
  scopes:     ['https://www.googleapis.com/auth/cloud-platform'],
});

app.use(cors());
app.use(express.json());

app.post('/generate-content', async (req, res) => {
  const prompt = req.body.prompt;
  try {
    const project  = 'ornate-hour-455923-f6';
    const location = 'us-central1';
    const url =
      `https://${location}-aiplatform.googleapis.com/v1/` +
      `projects/${project}/locations/${location}/publishers/google/` +
      `models/gemini-2.0-flash-lite:generateContent`;

    const client = await auth.getClient();
    const { token } = await client.getAccessToken();

    const payload = {
      contents: [{ role: 'user', parts: [{ text: prompt }] }],
      systemInstruction: {
        role: 'system',
        parts: [{
          text:
            'You are an occupational therapist. Provide a clear, week-by-week home action plan for stroke recovery.'
        }]
      },
      generationConfig: { temperature: 1.0, maxOutputTokens: 1024 }
    };

    const apiRes = await axios.post(url, payload, {
      headers: {
        'Content-Type': 'application/json',
        Authorization:  `Bearer ${token}`
      },
    });

    res.json(apiRes.data);
  } catch (err) {
    console.error(err.response?.data || err.message);
    res.status(500).json({ error: err.response?.data || err.message });
  }
});

// --------- MongoDB setup & /plans routes ---------
mongoose
  .connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB error:', err));

const planSchema = new mongoose.Schema({
  prompt: { type: String, required: true },
  plan:   { type: String, required: true },
}, { timestamps: true });

const Plan = mongoose.model('Plan', planSchema);

app.post('/plans', async (req, res) => {
  try {
    const { prompt, plan } = req.body;
    const newPlan = new Plan({ prompt, plan });
    const saved = await newPlan.save();
    res.json(saved);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to save plan' });
  }
});

app.get('/plans', async (req, res) => {
  try {
    const all = await Plan.find().sort({ createdAt: -1 });
    res.json(all);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch plans' });
  }
});

app.put('/plans/:id', async (req, res) => {
  try {
    const updated = await Plan.findByIdAndUpdate(
      req.params.id,
      { plan: req.body.plan },
      { new: true }
    );
    if (!updated) return res.status(404).json({ error: 'Not found' });
    res.json(updated);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to update plan' });
  }
});

app.delete('/plans/:id', async (req, res) => {
  try {
    const deleted = await Plan.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ error: 'Not found' });
    res.json({ message: 'Deleted' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to delete plan' });
  }
});

// --------- start server ---------
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
