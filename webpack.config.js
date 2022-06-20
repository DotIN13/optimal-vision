const path = require('path');

module.exports = {
  mode: "development",
  entry: './webpack/javascript/index.js',
  output: {
    filename: 'vision.js',
    path: path.resolve(__dirname, 'dist'),
  },
};