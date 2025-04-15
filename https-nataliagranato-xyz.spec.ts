import { test, expect } from '@playwright/test';

// Configuração com tempos de espera aumentados para todo o teste
test.setTimeout(90000); // 90 segundos de timeout para o teste inteiro

test('Verificar site nataliagranato.xyz', async ({ page }) => {
    console.log('Iniciando teste do site nataliagranato.xyz');

    // Aumenta o timeout da navegação para 60 segundos
    await page.goto('https://www.nataliagranato.xyz', {
        timeout: 60000,
        waitUntil: 'networkidle' // Espera até que não haja mais requisições de rede
    });

    console.log('Página carregada, verificando URL...');

    // Verifica se a URL está correta
    await expect(page).toHaveURL(/.*nataliagranato\.xyz.*/, { timeout: 30000 });

    // Obtém e exibe o título da página para diagnóstico
    const title = await page.title();
    console.log(`Título da página: ${title}`);

    // Verifica se elementos essenciais da página estão presentes
    console.log('Verificando elementos da página...');
    await expect(page.locator('body')).toBeVisible({ timeout: 30000 });

    // Verifica se o conteúdo principal foi carregado (ajuste o seletor conforme necessário)
    // Por exemplo, verificando se há um elemento de cabeçalho ou conteúdo principal
    try {
        // Tenta localizar headers, main content ou outros elementos importantes
        const mainContent = await page.$('header, main, #content, .main-content');
        console.log('Conteúdo principal encontrado:', !!mainContent);
    } catch (e) {
        console.log('Erro ao verificar conteúdo principal:', e);
    }

    // Captura screenshot para análise posterior
    await page.screenshot({ path: 'screenshot.png', fullPage: true });

    console.log('Teste concluído com sucesso!');
});