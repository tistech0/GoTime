let backendHost;

if (process.env.NODE_ENV === 'production') {
    backendHost = process.env.VUE_APP_API_HOST;
} else {
    backendHost = 'localhost';
}

module.exports = {
    devServer: {
        proxy: `http://${backendHost}:4000`
    }
};
