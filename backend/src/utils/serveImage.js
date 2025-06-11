const axios = require('axios');

async function getBase64ImageFromUrl(imageUrl) {
  try {
    const response = await axios.get(imageUrl, {
      responseType: 'arraybuffer'
    });

    const contentType = response.headers['content-type']; // e.g., image/jpeg
    const base64 = Buffer.from(response.data, 'binary').toString('base64');
    return `data:${contentType};base64,${base64}`;
  } catch (error) {
    console.error('Error fetching or converting image:', error.message);
    return null;
  }
}
exports.getBase64ImageFromUrl = getBase64ImageFromUrl;