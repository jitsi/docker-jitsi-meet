/* global __dirname */

const CircularDependencyPlugin = require('circular-dependency-plugin');
const process = require('process');
const webpack = require('webpack');
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');

/**
 * The URL of the Jitsi Meet deployment to be proxy to in the context of
 * development with webpack-dev-server.
 */
const devServerProxyTarget
    = process.env.WEBPACK_DEV_SERVER_PROXY_TARGET || 'https://alpha.jitsi.net';

const analyzeBundle = process.argv.indexOf('--analyze-bundle') !== -1;
const detectCircularDeps = process.argv.indexOf('--detect-circular-deps') !== -1;

const minimize
    = process.argv.indexOf('-p') !== -1
        || process.argv.indexOf('--optimize-minimize') !== -1;

/**
 * Build a Performance configuration object for the given size.
 * See: https://webpack.js.org/configuration/performance/
 */
function getPerformanceHints(size) {
    return {
        hints: minimize && !analyzeBundle ? 'error' : false,
        maxAssetSize: size,
        maxEntrypointSize: size
    };
}

/**
 * Build a BundleAnalyzerPlugin plugin instance for the given bundle name.
 */
function getBundleAnalyzerPlugin(name) {
    if (!analyzeBundle) {
        return [];
    }

    return [ new BundleAnalyzerPlugin({
        analyzerMode: 'disabled',
        generateStatsFile: true,
        statsFilename: `${name}-stats.json`
    }) ];
}


// The base Webpack configuration to bundle the JavaScript artifacts of
// jitsi-meet such as app.bundle.js and external_api.js.
const config = {
    devServer: {
        https: true,
        host: '127.0.0.1',
        inline: true,
        proxy: {
            '/': {
                bypass: devServerProxyBypass,
                secure: false,
                target: devServerProxyTarget,
                headers: {
                    'Host': new URL(devServerProxyTarget).host
                }
            }
        }
    },
    devtool: 'source-map',
    mode: minimize ? 'production' : 'development',
    module: {
        rules: [ {
            // Transpile ES2015 (aka ES6) to ES5. Accept the JSX syntax by React
            // as well.

            exclude: [
                new RegExp(`${__dirname}/node_modules/(?!@jitsi/js-utils)`)
            ],
            loader: 'babel-loader',
            options: {
                // Avoid loading babel.config.js, since we only use it for React Native.
                configFile: false,

                // XXX The require.resolve bellow solves failures to locate the
                // presets when lib-jitsi-meet, for example, is npm linked in
                // jitsi-meet.
                plugins: [
                    require.resolve('@babel/plugin-transform-flow-strip-types'),
                    require.resolve('@babel/plugin-proposal-class-properties'),
                    require.resolve('@babel/plugin-proposal-export-default-from'),
                    require.resolve('@babel/plugin-proposal-export-namespace-from'),
                    require.resolve('@babel/plugin-proposal-nullish-coalescing-operator'),
                    require.resolve('@babel/plugin-proposal-optional-chaining')
                ],
                presets: [
                    [
                        require.resolve('@babel/preset-env'),

                        // Tell babel to avoid compiling imports into CommonJS
                        // so that webpack may do tree shaking.
                        {
                            modules: false,

                            // Specify our target browsers so no transpiling is
                            // done unnecessarily. For browsers not specified
                            // here, the ES2015+ profile will be used.
                            targets: {
                                chrome: 58,
                                electron: 2,
                                firefox: 54,
                                safari: 11
                            }

                        }
                    ],
                    require.resolve('@babel/preset-flow'),
                    require.resolve('@babel/preset-react')
                ]
            },
            test: /\.jsx?$/
        }, {
            // Expose jquery as the globals $ and jQuery because it is expected
            // to be available in such a form by multiple jitsi-meet
            // dependencies including lib-jitsi-meet.

            loader: 'expose-loader?$!expose-loader?jQuery',
            test: /[/\\]node_modules[/\\]jquery[/\\].*\.js$/
        }, {
            // Allow CSS to be imported into JavaScript.

            test: /\.css$/,
            use: [
                'style-loader',
                'css-loader'
            ]
        }, {
            test: /\/node_modules\/@atlaskit\/modal-dialog\/.*\.js$/,
            resolve: {
                alias: {
                    'react-focus-lock': `${__dirname}/react/features/base/util/react-focus-lock-wrapper.js`,
                    '../styled/Modal': `${__dirname}/react/features/base/dialog/components/web/ThemedDialog.js`
                }
            }
        }, {
            test: /\/react\/features\/base\/util\/react-focus-lock-wrapper.js$/,
            resolve: {
                alias: {
                    'react-focus-lock': `${__dirname}/node_modules/react-focus-lock`
                }
            }
        }, {
            test: /\.svg$/,
            use: [ {
                loader: '@svgr/webpack',
                options: {
                    dimensions: false,
                    expandProps: 'start'
                }
            } ]
        } ]
    },
    node: {
        // Allow the use of the real filename of the module being executed. By
        // default Webpack does not leak path-related information and provides a
        // value that is a mock (/index.js).
        __filename: true,

        // Provide some empty Node modules (required by olm).
        crypto: 'empty',
        fs: 'empty'
    },
    optimization: {
        concatenateModules: minimize,
        minimize
    },
    output: {
        filename: `[name]${minimize ? '.min' : ''}.js`,
        path: `${__dirname}/build`,
        publicPath: '/libs/',
        sourceMapFilename: `[name].${minimize ? 'min' : 'js'}.map`
    },
    plugins: [
        detectCircularDeps
            && new CircularDependencyPlugin({
                allowAsyncCycles: false,
                exclude: /node_modules/,
                failOnError: false
            })
    ].filter(Boolean),
    resolve: {
        alias: {
            'focus-visible': 'focus-visible/dist/focus-visible.min.js',
            jquery: `jquery/dist/jquery${minimize ? '.min' : ''}.js`
        },
        aliasFields: [
            'browser'
        ],
        extensions: [
            '.web.js',

            // Webpack defaults:
            '.js',
            '.json'
        ]
    }
};

module.exports = [
    Object.assign({}, config, {
        entry: {
            'app.bundle': './app.js'
        },
        plugins: [
            ...config.plugins,
            ...getBundleAnalyzerPlugin('app'),
            new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
        ],
        performance: getPerformanceHints(4 * 1024 * 1024)
    }),
    Object.assign({}, config, {
        entry: {
            'alwaysontop': './react/features/always-on-top/index.js'
        },
        plugins: [
            ...config.plugins,
            ...getBundleAnalyzerPlugin('alwaysontop')
        ],
        performance: getPerformanceHints(800 * 1024)
    }),
    Object.assign({}, config, {
        entry: {
            'dial_in_info_bundle': './react/features/invite/components/dial-in-info-page'
        },
        plugins: [
            ...config.plugins,
            ...getBundleAnalyzerPlugin('dial_in_info'),
            new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
        ],
        performance: getPerformanceHints(500 * 1024)
    }),
    Object.assign({}, config, {
        entry: {
            'do_external_connect': './connection_optimization/do_external_connect.js'
        },
        plugins: [
            ...config.plugins,
            ...getBundleAnalyzerPlugin('do_external_connect')
        ],
        performance: getPerformanceHints(5 * 1024)
    }),
    Object.assign({}, config, {
        entry: {
            'flacEncodeWorker': './react/features/local-recording/recording/flac/flacEncodeWorker.js'
        },
        plugins: [
            ...config.plugins,
            ...getBundleAnalyzerPlugin('flacEncodeWorker')
        ],
        performance: getPerformanceHints(5 * 1024)
    }),
    Object.assign({}, config, {
        entry: {
            'analytics-ga': './react/features/analytics/handlers/GoogleAnalyticsHandler.js'
        },
        plugins: [
            ...config.plugins,
            ...getBundleAnalyzerPlugin('analytics-ga')
        ],
        performance: getPerformanceHints(5 * 1024)
    }),
    Object.assign({}, config, {
        entry: {
            'close3': './static/close3.js'
        },
        plugins: [
            ...config.plugins,
            ...getBundleAnalyzerPlugin('close3')
        ],
        performance: getPerformanceHints(128 * 1024)
    }),

    Object.assign({}, config, {
        entry: {
            'external_api': './modules/API/external/index.js'
        },
        output: Object.assign({}, config.output, {
            library: 'JitsiMeetExternalAPI',
            libraryTarget: 'umd'
        }),
        plugins: [
            ...config.plugins,
            ...getBundleAnalyzerPlugin('external_api')
        ],
        performance: getPerformanceHints(35 * 1024)
    })
];

/**
 * Determines whether a specific (HTTP) request is to bypass the proxy of
 * webpack-dev-server (i.e. is to be handled by the proxy target) and, if not,
 * which local file is to be served in response to the request.
 *
 * @param {Object} request - The (HTTP) request received by the proxy.
 * @returns {string|undefined} If the request is to be served by the proxy
 * target, undefined; otherwise, the path to the local file to be served.
 */
function devServerProxyBypass({ path }) {
    if (path.startsWith('/css/') || path.startsWith('/doc/')
            || path.startsWith('/fonts/')
            || path.startsWith('/images/')
            || path.startsWith('/lang/')
            || path.startsWith('/sounds/')
            || path.startsWith('/static/')
            || path.endsWith('.wasm')) {

        return path;
    }

    const configs = module.exports;

    /* eslint-disable array-callback-return, indent */

    if ((Array.isArray(configs) ? configs : Array(configs)).some(c => {
            if (path.startsWith(c.output.publicPath)) {
                    if (!minimize) {
                        // Since webpack-dev-server is serving non-minimized
                        // artifacts, serve them even if the minimized ones are
                        // requested.
                        return Object.keys(c.entry).some(e => {
                            const name = `${e}.min.js`;

                            if (path.indexOf(name) !== -1) {
                                // eslint-disable-next-line no-param-reassign
                                path = path.replace(name, `${e}.js`);

                                return true;
                            }
                        });
                    }
                }
            })) {
        return path;
    }

    if (path.startsWith('/libs/')) {
        return path;
    }
}
