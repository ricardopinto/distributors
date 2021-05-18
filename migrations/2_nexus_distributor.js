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
    feePercentage: 0, // 0%
    tokenName: 'Bright Nexus',
    tokenSymbol: 'BRIGHT-NEXUS'
}

module.exports = async (deployer, network, accounts) => {
    params.treasury = accounts[0];
    const {feePercentage, tokenName, tokenSymbol, treasury} = params;

    const masterAddress = MASTER[network];
    const master = await INXMaster.at(masterAddress);

    const coverAddress = await master.getLatestAddress(hex("CO"));
    const nxmTokenAddress = await master.tokenAddress();
    await deployProxy(Distributor, [
        coverAddress,
        nxmTokenAddress,
        masterAddress,
        feePercentage,
        treasury,
        tokenName,
        tokenSymbol
    ], { deployer });

    const distributor = await Distributor.deployed();

    const distributorAddress = distributor.address;
    console.log(`Successfully deployed at ${distributorAddress}`);

    //approving TokenController to move the distributor's NXM
    await distributor.approveNXM(await master.getLatestAddress(hex('TC')), '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');

    //KYC Distributor (proxy) address
    const memberRolesAddr = await master.getLatestAddress(hex('MR'));
    console.log(`IMemberRoles: ${memberRolesAddr}`);
    const memberRoles = await IMemberRoles.at(memberRolesAddr);
    await memberRoles.payJoiningFee(distributorAddress, {value: ether('0.002')});

    if (network.name !== 'mainnet') {
        console.log('Using test network. Self-approving kyc..');
        const {val: selfKycAddress} = await master.getOwnerParameters(hex('KYCAUTH'));
        console.log({selfKycAddress});
        const selfKyc = await SelfKyc.at(selfKycAddress);

        await selfKyc.approveKyc(distributorAddress);
    }
};
