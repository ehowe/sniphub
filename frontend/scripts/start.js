import { commonBuildOptions } from './esbuildOptions.js'
import esbuild from 'esbuild'

const status = (reqStatus) =>
  reqStatus >= 200 && reqStatus < 400
    ? // Make it green
      `\x1b[32m${reqStatus}\x1b[0m`
    : // Make it red
      `\x1b[31m${reqStatus}\x1b[0m`

const logRequest = (req) =>
  console.log(
    `${req.remoteAddress} - "${req.method} ${req.path}" ${status(
      req.status
    )} [${req.timeInMS}]`
  )

esbuild
  .serve(
    { servedir: 'public/', port: 5100, onRequest: logRequest },
    { ...commonBuildOptions, logLevel: 'debug' }
  )
  .catch((err) => {
    console.error(err)
    process.exit(1)
  })
