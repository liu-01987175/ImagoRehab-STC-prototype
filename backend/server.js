// This is a backend proxy that will let us communicate with Gemini API
const express = require('express');
const axios = require('axios');
const app = express();
const port = 3000;

app.use(express.json());

app.post('/generate-content', async (req, res) => {
  const { prompt } = req.body;

  try {
    const response = await axios.post(
      'https://genai.googleapis.com/v1/models/gemini-2.0-flash:generateContent',
      {
        model: 'gemini-2.0-flash',
        contents: prompt,
      },
      {
        headers: {
          Authorization: `Bearer YOUR_API_KEY`,
          'Content-Type': 'application/json',
        },
      }
    );
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});