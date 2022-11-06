import esbuild from 'esbuild'
import { commonBuildOptions } from './esbuildOptions.js'
import chokidar from 'chokidar'
import http from 'http'

const builds = {
  dev: { ...commonBuildOptions, loglevel: 'debug', watch: true },
  watch: {
    ...commonBuildOptions,
    minify: false,
    watch: true,
    logLevel: 'debug',
  },
  prod: { ...commonBuildOptions, minify: true, logLevel: 'debug' },
}

if (process.env.NODE_ENV !== 'production' && builds[process.argv[2]].watch) {
  const clients = []
  const watchedDirectories = ['src/**/*']
  http
    .createServer((req, res) => {
      return clients.push(
        res.writeHead(200, {
          'Content-Type': 'text/event-stream',
          'Cache-Control': 'no-cache',
          'Access-Control-Allow-Origin': '*',
          Connection: 'keep-alive',
        })
      )
    })
    .listen(8082)
  ;(async () => {
    const result = await esbuild.build(builds[process.argv[2]])
    chokidar.watch(watchedDirectories).on('all', (event, path) => {
      if (path.includes('client')) {
        console.log(`rebuilding ${path}`)
        result.rebuild()
      }
      clients.forEach((res) => res.write('data: update\n\n'))
      clients.length = 0
    })
  })()
} else {
  esbuild.build(builds[process.argv[2]]).catch((err) => {
    console.error(err)
    process.exit(1)
  })
}
