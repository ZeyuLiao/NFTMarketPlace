import { defineChain } from 'viem';
import path from 'path';

export const vMainnet = defineChain({
    id: 1,
    name: 'Virtual Ethereum Mainnet',
    nativeCurrency: { name: 'vEther', symbol: 'vETH', decimals: 18 },
    rpcUrls: {
        default: { http: ["https://virtual.mainnet.rpc.tenderly.co/3020973c-06d6-4afc-9c92-f8cb3002ff8c"] },
    },
    blockExplorers: {
        default: {
            name: 'Tenderly Explorer',
            url: "https://virtual.mainnet.rpc.tenderly.co/3020973c-06d6-4afc-9c92-f8cb3002ff8c"
        },
    },
    contracts: {
        ensRegistry: {
            address: '0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e',
        },
        ensUniversalResolver: {
            address: '0xE4Acdd618deED4e6d2f03b9bf62dc6118FC9A4da',
            blockCreated: 16773775,
        },
        multicall3: {
            address: '0xca11bde05977b3631167028862be2a173976ca11',
            blockCreated: 14353601,
        },
    },
});