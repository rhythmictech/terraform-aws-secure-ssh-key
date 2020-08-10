const AWS = require('aws-sdk')
const forge = require('node-forge')

const rsa = forge.pki.rsa

const secretsmanager = new AWS.SecretsManager()

const bits = process.env.KEY_BITS || 2048

exports.handler = async (event, context) => {
  try {
    const keypair = rsa.generateKeyPair({ bits, e: 0x10001 })
    await secretsmanager.putSecretValue({
      SecretId: event.pubkey_secret_name,
      SecretString: forge.ssh.publicKeyToOpenSSH(keypair.publicKey)
    }).promise()
    await secretsmanager.putSecretValue({
      SecretId: event.privkey_secret_name,
      SecretString: forge.ssh.privateKeyToOpenSSH(keypair.privateKey)
    }).promise()
  } catch (error) {
    console.error(error)
    throw (error)
  }
}
