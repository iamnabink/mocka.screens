const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('preferencesAPI', {
    getSettings: () => ipcRenderer.invoke('get-settings'),
    saveSettings: (settings) => ipcRenderer.invoke('save-settings', settings),
    getLLMProviders: () => ipcRenderer.invoke('get-llm-providers')
});
