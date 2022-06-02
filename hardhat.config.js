require("@nomiclabs/hardhat-ethers");

require('dotenv').config()

let private_key = process.env.PRIVATE_KEY;

module.exports = {
    networks: {
        hardhat: {},
        production: {
            chainId: 40101,
            gasPrice: 2000000000,
            gas: 3000000,
            url: "https://rpc.finachain.com",
            accounts: [private_key]
        }
    },
    solidity: {
        compilers: [{
            version: "0.5.10",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            },
        }, {
            version: "0.7.6",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            },
        }, {
            version: "0.4.18",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        }],
    },
    mocha: {
        timeout: 2000000
    }
};