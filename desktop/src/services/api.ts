import axios from 'axios';

const API_BASE_URL = 'http://localhost:3001/api';

export const api = {
  async createSession() {
    const response = await axios.post(`${API_BASE_URL}/session/create`);
    return response.data;
  },

  async getSessionStatus(sessionId: string) {
    const response = await axios.get(`${API_BASE_URL}/session/${sessionId}/status`);
    return response.data;
  }
};
