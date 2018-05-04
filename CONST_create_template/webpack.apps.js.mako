const path = require('path');
const ls = require('ls');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const plugins = [];
const entry = {};

// The dev mode will be used for builds on local machine outside docker
const nodeEnv = process.env['NODE_ENV'] || 'development';
const dev = nodeEnv == 'development'
process.traceDeprecation = true;

for (const filename of ls(path.resolve(
  __dirname, 'geoportal/demo_geoportal/static-ngeo/js/apps/*.html' + (dev ? '.mako' : '')
))) {
  const name = filename.file.split('.')[0];
  entry[name] = path.resolve(__dirname, 'geoportal/demo_geoportal/static-ngeo/js/apps/Controller' + name + '.js');
  plugins.push(
    new HtmlWebpackPlugin({
      inject: 'head',
      template: filename.full,
      chunksSortMode: 'manual',
      filename: name + '.html',
      chunks: ['commons', name],
    })
  );
}

const babelPresets = [['env',{
  "targets": {
    "browsers": ["last 2 versions", "Firefox ESR", "ie 11"],
  },
  "modules": false,
  "loose": true,
}]]
const babelUse = {
  loader: 'babel-loader',
  options: {
    presets: babelPresets,
    plugins: ['@camptocamp/babel-plugin-angularjs-annotate'],
  }
}
const annotateRule = {
  test: /geoportal\/demo_geoportal\/static-ngeo\/js\/.*\.js$/,
  use: babelUse,
}

// Transform code to ES2015 and annotate injectable functions with an $inject array.
const projectRule = {
  test: /geoportal\/demo_geoportal\/static-ngeo\/js\/.*\.js$/,
  use: {
    loader: 'babel-loader',
    options: {
      presets: babelPresets,
      plugins: ['@camptocamp/babel-plugin-angularjs-annotate'],
    }
  },
};

const rules = [
  projectRule
];


if (dev) {
  rules.push({
    test: /.html.mako/,
    use: [
    {
      loader: 'html-loader'
    },
    {
      loader: 'webpack-replace',
      options: {
        search: '/${'$'}{instanceid}/wsgi/',
        replace: '/${instanceid}/wsgi/'
      }
    }],
  });
}
rules.push(annotateRule);


module.exports = {
  output: {
    path: path.resolve(__dirname, 'geoportal/demo_geoportal/static-ngeo/build/'),
    publicPath: dev ? '/${instanceid}/dev/' : '/${instanceid}/wsgi/static-ngeo/UNUSED_CACHE_VERSION/build/'
  },
  entry: entry,
  optimization: {
    splitChunks: {
      chunks: 'all',
      name: 'commons',
    }
  },
  module: {
    rules
  },
  plugins: plugins,
};
