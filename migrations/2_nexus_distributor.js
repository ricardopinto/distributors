const {MASTER} = require('./nexus_addresses');
const {ether} = require('@openzeppelin/test-helpers');
const {hex} = require('../test/utils/helpers');
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Distributor = artifacts.require('Distributor');
const INXMaster = artifacts.require('INXMaster');
const SelfKyc = artifacts.require('SelfKyc');
const Token = artifacts.require('OZIERC20');
const IMemberRoles = artifacts.require('IMemberRoles')

const params = {
    feePercentage: 100, // 1%
    tokenName: 'Bright Nexus',
    tokenSymbol: 'BRIGHT-NEXUS'
}

module.exports = async (deployer, network, accounts) => {
    params.treasury = accounts[0];
    const {feePercentage, tokenName, tokenSymbol, treasury} = params;

    const masterAddress = MASTER[network];
    const master = await INXMaster.at(masterAddress);

    const coverAddress = await master.getLatestAddress("CO");
    const nxmTokenAddress = await master.tokenAddress();
    const distributor = await deployProxy(Distributor, [
        coverAddress,
        nxmTokenAddress,
        masterAddress,
        feePercentage,
        treasury,
        tokenName,
        tokenSymbol
    ], { deployer });

    const distributorAddress = distributor.address;
    console.log(`Successfully deployed at ${distributorAddress}`);

    //approving TokenController to move the distributor's NXM
    await distributor.approveNXM(await master.getLatestAddress(hex('TC')), '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');

    if (network.name !== 'mainnet') {
        console.log('Using test network. Self-approving kyc..');
        const {val: selfKycAddress} = await master.getOwnerParameters(hex('KYCAUTH'));
        console.log({selfKycAddress});
        const selfKyc = await SelfKyc.at(selfKycAddress);

        //KYC specific address
        /*const memberRolesAddr = await master.getLatestAddress(hex('MR'));
        console.log(`IMemberRoles: ${memberRolesAddr}`);
        const memberRoles = await IMemberRoles.at(memberRolesAddr);
        await memberRoles.payJoiningFee('0xa19b2F3b880e7dCEb44435ca263AFcB58072D67d', {value: ether('0.002')});*/

        await selfKyc.approveKyc(distributorAddress);
    }
};
