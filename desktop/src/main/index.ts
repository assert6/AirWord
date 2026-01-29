import { app, BrowserWindow, ipcMain, globalShortcut } from 'electron';
import * as robot from 'robotjs';
import path from 'path';

let mainWindow: BrowserWindow | null = null;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, '../preload/index.js'),
      contextIsolation: true,
      nodeIntegration: false,
    },
    autoHideMenuBar: true,
  });

  // 开发环境加载Vite开发服务器
  if (process.env.VITE_DEV_SERVER_URL) {
    mainWindow.loadURL(process.env.VITE_DEV_SERVER_URL);
    mainWindow.webContents.openDevTools();
  } else {
    mainWindow.loadFile(path.join(__dirname, '../renderer/index.html'));
  }

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

app.whenReady().then(() => {
  createWindow();

  // 注册全局快捷键 (可选: Ctrl+Shift+A 显示/隐藏窗口)
  globalShortcut.register('CommandOrControl+Shift+W', () => {
    if (mainWindow) {
      if (mainWindow.isVisible()) {
        mainWindow.hide();
      } else {
        mainWindow.show();
        mainWindow.focus();
      }
    }
  });

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('will-quit', () => {
  globalShortcut.unregisterAll();
});

// IPC处理程序
ipcMain.handle('type-text', async (_event, text: string) => {
  console.log('Main: type-text called with:', text);
  try {
    robot.typeString(text);
    console.log('Main: type-text success');
    return { success: true };
  } catch (error) {
    console.error('Main: Failed to type text:', error);
    return { success: false, error: String(error) };
  }
});

ipcMain.handle('delete-text', async (_event, count: number) => {
  console.log('Main: delete-text called with count:', count);
  try {
    for (let i = 0; i < count; i++) {
      robot.keyTap('backspace');
    }
    console.log('Main: delete-text success');
    return { success: true };
  } catch (error) {
    console.error('Main: Failed to delete text:', error);
    return { success: false, error: String(error) };
  }
});
