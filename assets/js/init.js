const addressHex = "$address";
const rpcURL = "$rpcurl";
const chainID = "$chainId";

function executeCallback (id, error, value) {
  AlphaWallet.executeCallback(id, error, value)
}

window.AlphaWallet.init(rpcURL, {
  getAccounts: function (cb) { cb(null, [addressHex]) },
  processTransaction: function (tx, cb){
    console.log('signing a transaction', tx)
    const { id = 8888 } = tx
    AlphaWallet.addCallback(id, cb)

    var gasLimit = tx.gasLimit || tx.gas || null;
    var gasPrice = tx.gasPrice || null;
    var data = tx.data || null;
    var nonce = tx.nonce || -1;
    flutter_inappwebview.callHandler('processTransaction', id, tx);

  },
  signMessage: function (msgParams, cb) {
      console.log('signMessage', msgParams)
      const { data, chainType } = msgParams
      const { id = 8888 } = msgParams
    AlphaWallet.addCallback(id, cb)
    flutter_inappwebview.callHandler('signMessage', id, data);
  },
  signPersonalMessage: function (msgParams, cb) {
      console.log('signPersonalMessage', msgParams)
      const { data, chainType } = msgParams
      const { id = 8888 } = msgParams
    AlphaWallet.addCallback(id, cb)
    flutter_inappwebview.callHandler('signPersonalMessage', id, data);
  },
  signTypedMessage: function (msgParams, cb) {
    console.log('signTypedMessage ', msgParams)
    const { data } = msgParams
    const { id = 8888 } = msgParams
    AlphaWallet.addCallback(id, cb)
    flutter_inappwebview.callHandler('signTypedMessage', id, JSON.stringify(msgParams));
  },
  ethCall: function (msgParams, cb) {
    console.log("eth_call", msgParams)
    const data = msgParams
    const { id = Math.floor((Math.random() * 100000) + 1) } = msgParams
    AlphaWallet.addCallback(id, cb)
    flutter_inappwebview.callHandler('ethCall', id, msgParams.to, msgParams.data);
  },
  walletAddEthereumChain: function (msgParams, cb) {
    const data = msgParams
    const { id = Math.floor((Math.random() * 100000) + 1) } = msgParams
    console.log("walletAddEthereumChain", msgParams)
    AlphaWallet.addCallback(id, cb)
    flutter_inappwebview.callHandler('walletAddEthereumChain', id, JSON.stringify(msgParams));
  },
  enable: function() {
      return new Promise(function(resolve, reject) {
          //send back the coinbase account as an array of one
          resolve([addressHex]);
      })
  },
}, {
    address: addressHex,
    networkVersion: chainID
})

window.web3.setProvider = function () {
  console.debug('Alpha Wallet - overrode web3.setProvider')
}

window.web3.version.getNetwork = function(cb) {
    cb(null, chainID)
}
window.web3.eth.getCoinbase = function(cb) {
    return cb(null, addressHex)
}
window.web3.eth.defaultAccount = addressHex
window.ethereum = web3.currentProvider

window.showWallet = function() {
  console.log("showWallet ...");
  flutter_inappwebview.callHandler('showWallet');
}