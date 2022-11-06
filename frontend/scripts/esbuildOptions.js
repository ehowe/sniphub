import manifestPlugin from 'esbuild-plugin-manifest'
import { sassPlugin } from 'esbuild-sass-plugin'
import dotenv from 'dotenv'

const nodeEnv = process.env.NODE_ENV
if (!nodeEnv) {
  throw new Error(
    'NODE_ENV was not set. This env variable is required when building the React app.'
  )
}

dotenv.config()

export const commonBuildOptions = {
  entryPoints: ['src/index.tsx'],
  bundle: true,
  define: {
    'process.env.NODE_ENV': `"${nodeEnv}"`,
    'process.env.REACT_APP_CLIENT_ID': `'${process.env.REACT_APP_CLIENT_ID}'`,
    'process.env.REACT_APP_REDIRECT_URI': `'${process.env.REACT_APP_REDIRECT_URI}'`,
    'process.env.REACT_APP_API_URL': `'${process.env.REACT_APP_API_URL}'`,
    'process.env.REACT_APP_API_PORT': `'${process.env.REACT_APP_API_PORT}'`,
    'process.env.REACT_APP_PROXY_URL': `'${process.env.REACT_APP_PROXY_URL}'`,
    'process.platform': `'${process.platform}'`,
  },
  minify: nodeEnv === 'production',
  sourcemap: nodeEnv !== 'production',
  target: 'es2020',
  outdir: './public',
  plugins: [sassPlugin(), manifestPlugin({ shortNames: true })],
}
