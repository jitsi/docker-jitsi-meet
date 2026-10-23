// Not the real WASM decoder glue. The server bundle imports this path statically,
// so it must exist; OPUS_BACKEND=native never uses it.
module.exports = () => {
    throw new Error('The WASM Opus backend is not available in this image. Use OPUS_BACKEND=native.');
};
