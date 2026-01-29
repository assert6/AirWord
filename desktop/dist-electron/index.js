"use strict";
const electron = require("electron");
const robot = require("robotjs");
const path = require("path");
function _interopNamespaceDefault(e) {
  const n = Object.create(null, { [Symbol.toStringTag]: { value: "Module" } });
  if (e) {
    for (const k in e) {
      if (k !== "default") {
        const d = Object.getOwnPropertyDescriptor(e, k);
        Object.defineProperty(n, k, d.get ? d : {
          enumerable: true,
          get: () => e[k]
        });
      }
    }
  }
  n.default = e;
  return Object.freeze(n);
}
const robot__namespace = /* @__PURE__ */ _interopNamespaceDefault(robot);
let mainWindow = null;
function createWindow() {
  mainWindow = new electron.BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, "../preload/index.js"),
      contextIsolation: true,
      nodeIntegration: false
    },
    autoHideMenuBar: true
  });
  if (process.env.VITE_DEV_SERVER_URL) {
    mainWindow.loadURL(process.env.VITE_DEV_SERVER_URL);
    mainWindow.webContents.openDevTools();
  } else {
    mainWindow.loadFile(path.join(__dirname, "../renderer/index.html"));
  }
  mainWindow.on("closed", () => {
    mainWindow = null;
  });
}
electron.app.whenReady().then(() => {
  createWindow();
  electron.globalShortcut.register("CommandOrControl+Shift+W", () => {
    if (mainWindow) {
      if (mainWindow.isVisible()) {
        mainWindow.hide();
      } else {
        mainWindow.show();
        mainWindow.focus();
      }
    }
  });
  electron.app.on("activate", () => {
    if (electron.BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});
electron.app.on("window-all-closed", () => {
  if (process.platform !== "darwin") {
    electron.app.quit();
  }
});
electron.app.on("will-quit", () => {
  electron.globalShortcut.unregisterAll();
});
electron.ipcMain.handle("type-text", async (_event, text) => {
  console.log("Main: type-text called with:", text);
  try {
    robot__namespace.typeString(text);
    console.log("Main: type-text success");
    return { success: true };
  } catch (error) {
    console.error("Main: Failed to type text:", error);
    return { success: false, error: String(error) };
  }
});
electron.ipcMain.handle("delete-text", async (_event, count) => {
  console.log("Main: delete-text called with count:", count);
  try {
    for (let i = 0; i < count; i++) {
      robot__namespace.keyTap("backspace");
    }
    console.log("Main: delete-text success");
    return { success: true };
  } catch (error) {
    console.error("Main: Failed to delete text:", error);
    return { success: false, error: String(error) };
  }
});
