/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
// ESM COMPAT FLAG
__webpack_require__.r(__webpack_exports__);

// CONCATENATED MODULE: ./modules/e2ee/crypto-utils.js
/**
 * Derives a set of keys from the master key.
 * @param {CryptoKey} material - master key to derive from
 *
 * See https://tools.ietf.org/html/draft-omara-sframe-00#section-4.3.1
 */
async function deriveKeys(material) {
    const info = new ArrayBuffer();
    const textEncoder = new TextEncoder();

    // https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/deriveKey#HKDF
    // https://developer.mozilla.org/en-US/docs/Web/API/HkdfParams
    const encryptionKey = await crypto.subtle.deriveKey({
        name: 'HKDF',
        salt: textEncoder.encode('JFrameEncryptionKey'),
        hash: 'SHA-256',
        info
    }, material, {
        name: 'AES-GCM',
        length: 128
    }, false, [ 'encrypt', 'decrypt' ]);

    return {
        material,
        encryptionKey
    };
}

/**
 * Ratchets a key. See
 * https://tools.ietf.org/html/draft-omara-sframe-00#section-4.3.5.1
 * @param {CryptoKey} material - base key material
 * @returns {ArrayBuffer} - ratcheted key material
 */
async function ratchet(material) {
    const textEncoder = new TextEncoder();

    // https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/deriveBits
    return crypto.subtle.deriveBits({
        name: 'HKDF',
        salt: textEncoder.encode('JFrameRatchetKey'),
        hash: 'SHA-256',
        info: new ArrayBuffer()
    }, material, 256);
}

/**
 * Converts a raw key into a WebCrypto key object with default options
 * suitable for our usage.
 * @param {ArrayBuffer} keyBytes - raw key
 * @param {Array} keyUsages - key usages, see importKey documentation
 * @returns {CryptoKey} - the WebCrypto key.
 */
async function importKey(keyBytes) {
    // https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/importKey
    return crypto.subtle.importKey('raw', keyBytes, 'HKDF', false, [ 'deriveBits', 'deriveKey' ]);
}

// CONCATENATED MODULE: ./modules/e2ee/Context.js
/* eslint-disable no-bitwise */
/* global BigInt */



// We use a ringbuffer of keys so we can change them and still decode packets that were
// encrypted with an old key. We use a size of 16 which corresponds to the four bits
// in the frame trailer.
const KEYRING_SIZE = 16;

// We copy the first bytes of the VP8 payload unencrypted.
// For keyframes this is 10 bytes, for non-keyframes (delta) 3. See
//   https://tools.ietf.org/html/rfc6386#section-9.1
// This allows the bridge to continue detecting keyframes (only one byte needed in the JVB)
// and is also a bit easier for the VP8 decoder (i.e. it generates funny garbage pictures
// instead of being unable to decode).
// This is a bit for show and we might want to reduce to 1 unconditionally in the final version.
//
// For audio (where frame.type is not set) we do not encrypt the opus TOC byte:
//   https://tools.ietf.org/html/rfc6716#section-3.1
const UNENCRYPTED_BYTES = {
    key: 10,
    delta: 3,
    undefined: 1 // frame.type is not set on audio
};
const ENCRYPTION_ALGORITHM = 'AES-GCM';

/* We use a 96 bit IV for AES GCM. This is signalled in plain together with the
 packet. See https://developer.mozilla.org/en-US/docs/Web/API/AesGcmParams */
const IV_LENGTH = 12;

const RATCHET_WINDOW_SIZE = 8;

/**
 * Per-participant context holding the cryptographic keys and
 * encode/decode functions
 */
class Context_Context {
    /**
     * @param {string} id - local muc resourcepart
     */
    constructor(id) {
        // An array (ring) of keys that we use for sending and receiving.
        this._cryptoKeyRing = new Array(KEYRING_SIZE);

        // A pointer to the currently used key.
        this._currentKeyIndex = -1;

        this._sendCounts = new Map();

        this._id = id;
    }

    /**
     * Derives the different subkeys and starts using them for encryption or
     * decryption.
     * @param {Uint8Array|false} key bytes. Pass false to disable.
     * @param {Number} keyIndex
     */
    async setKey(keyBytes, keyIndex) {
        let newKey;

        if (keyBytes) {
            const material = await importKey(keyBytes);

            newKey = await deriveKeys(material);
        } else {
            newKey = false;
        }
        this._currentKeyIndex = keyIndex % this._cryptoKeyRing.length;
        this._setKeys(newKey);
    }

    /**
     * Sets a set of keys and resets the sendCount.
     * decryption.
     * @param {Object} keys set of keys.
     * @param {Number} keyIndex optional
     * @private
     */
    _setKeys(keys, keyIndex = -1) {
        if (keyIndex >= 0) {
            this._cryptoKeyRing[keyIndex] = keys;
        } else {
            this._cryptoKeyRing[this._currentKeyIndex] = keys;
        }
        this._sendCount = BigInt(0); // eslint-disable-line new-cap
    }

    /**
     * Function that will be injected in a stream and will encrypt the given encoded frames.
     *
     * @param {RTCEncodedVideoFrame|RTCEncodedAudioFrame} encodedFrame - Encoded video frame.
     * @param {TransformStreamDefaultController} controller - TransportStreamController.
     *
     * The VP8 payload descriptor described in
     * https://tools.ietf.org/html/rfc7741#section-4.2
     * is part of the RTP packet and not part of the frame and is not controllable by us.
     * This is fine as the SFU keeps having access to it for routing.
     *
     * The encrypted frame is formed as follows:
     * 1) Leave the first (10, 3, 1) bytes unencrypted, depending on the frame type and kind.
     * 2) Form the GCM IV for the frame as described above.
     * 3) Encrypt the rest of the frame using AES-GCM.
     * 4) Allocate space for the encrypted frame.
     * 5) Copy the unencrypted bytes to the start of the encrypted frame.
     * 6) Append the ciphertext to the encrypted frame.
     * 7) Append the IV.
     * 8) Append a single byte for the key identifier.
     * 9) Enqueue the encrypted frame for sending.
     */
    encodeFunction(encodedFrame, controller) {
        const keyIndex = this._currentKeyIndex;

        if (this._cryptoKeyRing[keyIndex]) {
            const iv = this._makeIV(encodedFrame.getMetadata().synchronizationSource, encodedFrame.timestamp);

            // Thіs is not encrypted and contains the VP8 payload descriptor or the Opus TOC byte.
            const frameHeader = new Uint8Array(encodedFrame.data, 0, UNENCRYPTED_BYTES[encodedFrame.type]);

            // Frame trailer contains the R|IV_LENGTH and key index
            const frameTrailer = new Uint8Array(2);

            frameTrailer[0] = IV_LENGTH;
            frameTrailer[1] = keyIndex;

            // Construct frame trailer. Similar to the frame header described in
            // https://tools.ietf.org/html/draft-omara-sframe-00#section-4.2
            // but we put it at the end.
            //
            // ---------+-------------------------+-+---------+----
            // payload  |IV...(length = IV_LENGTH)|R|IV_LENGTH|KID |
            // ---------+-------------------------+-+---------+----

            return crypto.subtle.encrypt({
                name: ENCRYPTION_ALGORITHM,
                iv,
                additionalData: new Uint8Array(encodedFrame.data, 0, frameHeader.byteLength)
            }, this._cryptoKeyRing[keyIndex].encryptionKey, new Uint8Array(encodedFrame.data,
                UNENCRYPTED_BYTES[encodedFrame.type]))
            .then(cipherText => {
                const newData = new ArrayBuffer(frameHeader.byteLength + cipherText.byteLength
                    + iv.byteLength + frameTrailer.byteLength);
                const newUint8 = new Uint8Array(newData);

                newUint8.set(frameHeader); // copy first bytes.
                newUint8.set(
                    new Uint8Array(cipherText), frameHeader.byteLength); // add ciphertext.
                newUint8.set(
                    new Uint8Array(iv), frameHeader.byteLength + cipherText.byteLength); // append IV.
                newUint8.set(
                        frameTrailer,
                        frameHeader.byteLength + cipherText.byteLength + iv.byteLength); // append frame trailer.

                encodedFrame.data = newData;

                return controller.enqueue(encodedFrame);
            }, e => {
                // TODO: surface this to the app.
                console.error(e);

                // We are not enqueuing the frame here on purpose.
            });
        }

        /* NOTE WELL:
         * This will send unencrypted data (only protected by DTLS transport encryption) when no key is configured.
         * This is ok for demo purposes but should not be done once this becomes more relied upon.
         */
        controller.enqueue(encodedFrame);
    }

    /**
     * Function that will be injected in a stream and will decrypt the given encoded frames.
     *
     * @param {RTCEncodedVideoFrame|RTCEncodedAudioFrame} encodedFrame - Encoded video frame.
     * @param {TransformStreamDefaultController} controller - TransportStreamController.
     */
    async decodeFunction(encodedFrame, controller) {
        const data = new Uint8Array(encodedFrame.data);
        const keyIndex = data[encodedFrame.data.byteLength - 1];

        if (this._cryptoKeyRing[keyIndex]) {

            const decodedFrame = await this._decryptFrame(
                encodedFrame,
                keyIndex);

            return controller.enqueue(decodedFrame);
        }

        // TODO: this just passes through to the decoder. Is that ok? If we don't know the key yet
        // we might want to buffer a bit but it is still unclear how to do that (and for how long etc).
        controller.enqueue(encodedFrame);
    }

    /**
     * Function that will decrypt the given encoded frame. If the decryption fails, it will
     * ratchet the key for up to RATCHET_WINDOW_SIZE times.
     *
     * @param {RTCEncodedVideoFrame|RTCEncodedAudioFrame} encodedFrame - Encoded video frame.
     * @param {number} keyIndex - the index of the decryption data in _cryptoKeyRing array.
     * @param {number} ratchetCount - the number of retries after ratcheting the key.
     * @returns {RTCEncodedVideoFrame|RTCEncodedAudioFrame} - The decrypted frame.
     * @private
     */
    async _decryptFrame(
            encodedFrame,
            keyIndex,
            initialKey = undefined,
            ratchetCount = 0) {

        const { encryptionKey } = this._cryptoKeyRing[keyIndex];
        let { material } = this._cryptoKeyRing[keyIndex];

        // Construct frame trailer. Similar to the frame header described in
        // https://tools.ietf.org/html/draft-omara-sframe-00#section-4.2
        // but we put it at the end.
        //
        // ---------+-------------------------+-+---------+----
        // payload  |IV...(length = IV_LENGTH)|R|IV_LENGTH|KID |
        // ---------+-------------------------+-+---------+----

        try {
            const frameHeader = new Uint8Array(encodedFrame.data, 0, UNENCRYPTED_BYTES[encodedFrame.type]);
            const frameTrailer = new Uint8Array(encodedFrame.data, encodedFrame.data.byteLength - 2, 2);

            const ivLength = frameTrailer[0];
            const iv = new Uint8Array(
                encodedFrame.data,
                encodedFrame.data.byteLength - ivLength - frameTrailer.byteLength,
                ivLength);

            const cipherTextStart = frameHeader.byteLength;
            const cipherTextLength = encodedFrame.data.byteLength
                    - (frameHeader.byteLength + ivLength + frameTrailer.byteLength);

            const plainText = await crypto.subtle.decrypt({
                name: 'AES-GCM',
                iv,
                additionalData: new Uint8Array(encodedFrame.data, 0, frameHeader.byteLength)
            },
                encryptionKey,
                new Uint8Array(encodedFrame.data, cipherTextStart, cipherTextLength));

            const newData = new ArrayBuffer(frameHeader.byteLength + plainText.byteLength);
            const newUint8 = new Uint8Array(newData);

            newUint8.set(new Uint8Array(encodedFrame.data, 0, frameHeader.byteLength));
            newUint8.set(new Uint8Array(plainText), frameHeader.byteLength);

            encodedFrame.data = newData;
        } catch (error) {
            if (ratchetCount < RATCHET_WINDOW_SIZE) {
                material = await importKey(await ratchet(material));

                const newKey = await deriveKeys(material);

                this._setKeys(newKey);

                return await this._decryptFrame(
                    encodedFrame,
                    keyIndex,
                    initialKey || this._cryptoKeyRing[this._currentKeyIndex],
                    ratchetCount + 1);
            }

            /*
               Since the key it is first send and only afterwards actually used for encrypting, there were
               situations when the decrypting failed due to the fact that the received frame was not encrypted
               yet and ratcheting, of course, did not solve the problem. So if we fail RATCHET_WINDOW_SIZE times,
               we come back to the initial key.
            */
            this._setKeys(initialKey);

            // TODO: notify the application about error status.
        }

        return encodedFrame;
    }


    /**
     * Construct the IV used for AES-GCM and sent (in plain) with the packet similar to
     * https://tools.ietf.org/html/rfc7714#section-8.1
     * It concatenates
     * - the 32 bit synchronization source (SSRC) given on the encoded frame,
     * - the 32 bit rtp timestamp given on the encoded frame,
     * - a send counter that is specific to the SSRC. Starts at a random number.
     * The send counter is essentially the pictureId but we currently have to implement this ourselves.
     * There is no XOR with a salt. Note that this IV leaks the SSRC to the receiver but since this is
     * randomly generated and SFUs may not rewrite this is considered acceptable.
     * The SSRC is used to allow demultiplexing multiple streams with the same key, as described in
     *   https://tools.ietf.org/html/rfc3711#section-4.1.1
     * The RTP timestamp is 32 bits and advances by the codec clock rate (90khz for video, 48khz for
     * opus audio) every second. For video it rolls over roughly every 13 hours.
     * The send counter will advance at the frame rate (30fps for video, 50fps for 20ms opus audio)
     * every second. It will take a long time to roll over.
     *
     * See also https://developer.mozilla.org/en-US/docs/Web/API/AesGcmParams
     */
    _makeIV(synchronizationSource, timestamp) {
        const iv = new ArrayBuffer(IV_LENGTH);
        const ivView = new DataView(iv);

        // having to keep our own send count (similar to a picture id) is not ideal.
        if (!this._sendCounts.has(synchronizationSource)) {
            // Initialize with a random offset, similar to the RTP sequence number.
            this._sendCounts.set(synchronizationSource, Math.floor(Math.random() * 0xFFFF));
        }

        const sendCount = this._sendCounts.get(synchronizationSource);

        ivView.setUint32(0, synchronizationSource);
        ivView.setUint32(4, timestamp);
        ivView.setUint32(8, sendCount % 0xFFFF);

        this._sendCounts.set(synchronizationSource, sendCount + 1);

        return iv;
    }
}

// CONCATENATED MODULE: ./modules/e2ee/Worker.js
/* global TransformStream */
/* eslint-disable no-bitwise */

// Worker for E2EE/Insertable streams.



const contexts = new Map(); // Map participant id => context

/**
 * Retrieves the participant {@code Context}, creating it if necessary.
 *
 * @param {string} participantId - The participant whose context we need.
 * @returns {Object} The context.
 */
function getParticipantContext(participantId) {
    if (!contexts.has(participantId)) {
        contexts.set(participantId, new Context_Context(participantId));
    }

    return contexts.get(participantId);
}

/**
 * Sets an encode / decode transform.
 *
 * @param {Object} context - The participant context where the transform will be applied.
 * @param {string} operation - Encode / decode.
 * @param {Object} readableStream - Readable stream part.
 * @param {Object} writableStream - Writable stream part.
 */
function handleTransform(context, operation, readableStream, writableStream) {
    if (operation === 'encode' || operation === 'decode') {
        const transformFn = operation === 'encode' ? context.encodeFunction : context.decodeFunction;
        const transformStream = new TransformStream({
            transform: transformFn.bind(context)
        });

        readableStream
            .pipeThrough(transformStream)
            .pipeTo(writableStream);
    } else {
        console.error(`Invalid operation: ${operation}`);
    }
}

onmessage = async event => {
    const { operation } = event.data;

    if (operation === 'encode' || operation === 'decode') {
        const { readableStream, writableStream, participantId } = event.data;
        const context = getParticipantContext(participantId);

        handleTransform(context, operation, readableStream, writableStream);
    } else if (operation === 'setKey') {
        const { participantId, key, keyIndex } = event.data;
        const context = getParticipantContext(participantId);

        if (key) {
            context.setKey(key, keyIndex);
        } else {
            context.setKey(false, keyIndex);
        }
    } else if (operation === 'cleanup') {
        const { participantId } = event.data;

        contexts.delete(participantId);
    } else {
        console.error('e2ee worker', operation);
    }
};

// Operations using RTCRtpScriptTransform.
if (self.RTCTransformEvent) {
    self.onrtctransform = event => {
        const transformer = event.transformer;
        const { operation, participantId } = transformer.options;
        const context = getParticipantContext(participantId);

        handleTransform(context, operation, transformer.readable, transformer.writable);
    };
}


/***/ })
/******/ ]);