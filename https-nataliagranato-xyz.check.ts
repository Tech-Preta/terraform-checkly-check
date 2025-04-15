/**
* This is a Checkly CLI BrowserCheck construct. To learn more, visit:
* - https://www.checklyhq.com/docs/cli/
* - https://www.checklyhq.com/docs/cli/constructs-reference/#browsercheck
*/

import { BrowserCheck, Frequency, RetryStrategyBuilder } from 'checkly/constructs'

new BrowserCheck('https-nataliagranato-xyz', {
  name: 'https://www.nataliagranato.xyz',
  activated: true,
  muted: false,
  shouldFail: false,
  runParallel: true,
  locations: ['sa-east-1', 'af-south-1'],
  tags: [],
  sslCheckDomain: '',
  frequency: Frequency.EVERY_5M,
  environmentVariables: [],
  code: {
    entrypoint: './https-nataliagranato-xyz.spec.ts',
  },
  retryStrategy: RetryStrategyBuilder.linearStrategy({
    baseBackoffSeconds: 120,
    maxRetries: 3,
    maxDurationSeconds: 600,
    sameRegion: true,
  }),
})
