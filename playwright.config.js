const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
    testDir: './',
    timeout: 90000, // 90 segundos de timeout global
    expect: {
        timeout: 30000, // 30 segundos para asserções
    },
    use: {
        // Configurações do navegador
        browserName: 'chromium',
        headless: true,
        viewport: { width: 1280, height: 720 },
        ignoreHTTPSErrors: true,
        video: 'on', // Sempre captura vídeo para diagnóstico
        trace: 'on', // Sempre captura trace para diagnóstico

        // Timeouts aumentados
        navigationTimeout: 60000, // 60 segundos para navegação
        actionTimeout: 30000,     // 30 segundos para ações
    },
    retries: 2, // Permite até 2 retentativas locais
    reporter: [
        ['html', { open: 'never' }],
        ['list']
    ],
});