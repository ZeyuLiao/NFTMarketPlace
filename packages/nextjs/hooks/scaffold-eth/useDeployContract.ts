// // hooks/useDeployContract.ts
// import { useState } from "react";
// import { useAccount } from "wagmi";
// import { ethers } from "ethers";
// import { NFTCollectionABI, NFTCollectionBytecode } from "../../contracts/contractConstants"

// export function useDeployContract() {
//     const [deployedAddress, setDeployedAddress] = useState<string | null>(null);
//     const [loading, setLoading] = useState(false);
//     const { data: signer } = useSigner(); // 获取当前连接的钱包
//     const { address, isConnected } = useAccount(); // 获取用户地址

//     const deployContract = async () => {
//         if (!isConnected) {
//             alert("请连接钱包！");
//             return;
//         }

//         setLoading(true);
//         try {
//             // 使用 ethers.js 创建合约工厂
//             const factory = new ethers.ContractFactory(NFTCollectionABI, NFTCollectionBytecode, signer);

//             // 部署合约
//             const contract = await factory.deploy("NFTCollection", "NFTC");
//             await contract.deployTransaction.wait(); // 等待交易被确认

//             setDeployedAddress(contract.address); // 设置已部署合约地址
//             alert(`合约部署成功，合约地址：${contract.address}`);
//         } catch (error) {
//             console.error("部署失败", error);
//         } finally {
//             setLoading(false);
//         }
//     };

//     return { deployContract, deployedAddress, loading };
// }
