const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
module.exports = {
    entry: {
        'polyfills': './web/polyfills.ts',
        'app': './web/main.ts'
      },
   output:{
       path: path.resolve(__dirname, 'dist'),     // путь к каталогу выходных файлов - папка public
       publicPath: '/',
       filename: '[name].[fullhash].js'
   },
   devServer: {
    historyApiFallback: true,
    port: 8081,
    open: true
  },
   resolve: {
    extensions: ['.ts', '.js']
  },
   module:{
       rules:[   //загрузчик для ts
           {
               test: /\.ts$/, // определяем тип файлов
               use: [
                {
                    loader: 'ts-loader',
                    options: { configFile: path.resolve(__dirname, 'tsconfig.json') }
                  } ,
                   'angular2-template-loader'
               ]
            }, {
              test: /\.html$/,
              loader: 'html-loader'
            },{
            test: /\.(png|jpe?g|gif|svg|woff|woff2|ttf|eot|ico)$/,
            loader: 'file-loader',
            options: {
              name: '[name].[fullhash].[ext]',
            }
          },{
            test: /\.css$/,
            exclude: path.resolve(__dirname, './web'),
            use: [
              MiniCssExtractPlugin.loader,
              "css-loader"
            ]
          },{
            test: /\.css$/,
            include: path.resolve(__dirname, './web'),
            loader: 'raw-loader'
          },
          {
            test: /\.jsx?$/,
            include: [
                path.resolve('index.js'),
                path.resolve(__dirname, './node_modules/webpack-dev-server'),
                path.resolve(__dirname, './node_modules/@tonclient/core'),
                path.resolve(__dirname, './node_modules/@tonclient/lib-web'),
            ]
        }
       ]
   },
   plugins: [
    new webpack.ContextReplacementPlugin(
        /angular(\\|\/)core/,
        path.resolve(__dirname, 'web'), // каталог с исходными файлами
      {} // карта маршрутов
    ),
    new HtmlWebpackPlugin({
      template: 'web/index.html'
    }),
    new MiniCssExtractPlugin({
      filename: "[name].css"
    }),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.LoaderOptionsPlugin({
      htmlLoader: {
        minimize: false
      }
    })
  ]
}