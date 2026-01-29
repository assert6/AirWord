import axios from 'axios';
import { Session } from '../types';

const API_BASE_URL = '/api';

export const api = {
  async createSession(): Promise<Session> {
    const response = await axios.post(`${API_BASE_URL}/session/create`);
    return response.data;
  },

  async getSessionStatus(sessionId: string) {
    const response = await axios.get(`${API_BASE_URL}/session/${sessionId}/status`);
    return response.data;
  }
};
