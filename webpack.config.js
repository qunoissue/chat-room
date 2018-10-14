const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
    entry: `${__dirname}/src/index.js`,
    output: {
        path: `${__dirname}/dist`,
        filename: 'bundle.js',
        libraryTarget: 'window',
    },
    module: {
        rules: [
            {
                test: /\.(css|scss)$/,
                use: [
                    'style-loader',
                    {
                        loader: 'css-loader',
                        options: {
                            modules: true,
                            localIdentName: '[name]__[local]'
                        }
                    },
                    {
                        'loader': 'sass-loader',
                        'options': {
                            'includePaths': [
                                `${__dirname}/styles/`,
                            ],
                        },
                    },
                ]
            },
            {
                test:    /\.elm$/,
                loader: 'elm-webpack-loader',
                options: {
                    debug: true
                }
            },
        ],
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: `${__dirname}/src/index.html`,
        })
    ],
    mode: process.env.WEBPACK_SERVE ? 'development' : 'production',
    serve: {
      contentBase: `${__dirname}/dist`,
      port: '8080',
      open: true,
    }
};
