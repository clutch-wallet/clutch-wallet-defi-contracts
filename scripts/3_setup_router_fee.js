import deploymentAddresses from './deployment';

try {
  (async () => {
    const Router = await ethers.getContractFactory('Router');
    const router = await Router.attach(deploymentAddresses.router);
    const chainId = await hre.network.provider.request({ method: 'eth_chainId' });

    console.log(`Working with chainId ${chainId}`);

    const feeSignerTx = await router.functions.setProtocolFeeSigner(
      '0xcBf27770781f8d4DcDE4aEA964B6ef4Aa488b66e',
    );
    console.log(`Setting fee signer tx hash: ${feeSignerTx.hash}`);

    const feeDefaultTx = await router.functions.setProtocolFeeDefault(
      [
        '1000000000000000',
        deploymentAddresses.feeBeneficiaries[parseInt(chainId.toString(), 16).toString()],
      ],
    );
    console.log(`Setting fee defaults tx hash: ${feeDefaultTx.hash}`);
  })();
} catch (error) {
  console.error(error);
  process.exit(1);
}
