import { contextBridge, ipcRenderer, clipboard } from 'electron';

contextBridge.exposeInMainWorld('electronAPI', {
  typeText: (text: string) => ipcRenderer.invoke('type-text', text),
  deleteText: (count: number) => ipcRenderer.invoke('delete-text', count),
  copyText: (text: string) => clipboard.writeText(text),
});
