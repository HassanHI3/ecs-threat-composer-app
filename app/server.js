const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3003;

app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

app.use(express.static(path.join(__dirname, "build")));

app.use((req, res) => {
  res.sendFile(path.join(__dirname, "build", "index.html"));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
});