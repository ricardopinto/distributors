const {FACTORY} = require('./nexus_addresses');
const {ether} = require('@openzeppelin/test-helpers');
const {hex} = require('../test/utils/helpers');

const DistributorFactory = artifacts.require('DistributorFactory');
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
    const factoryAddress = FACTORY[network];
    params.treasury = accounts[0];
    const {feePercentage, tokenName, tokenSymbol, treasury} = params;

    const factory = await DistributorFactory.at(factoryAddress);
    const master = await INXMaster.at(await factory.master());
    console.log(`Using a Distributor Factory at ${factoryAddress}`);

    const tx = await factory.newDistributor(
        feePercentage,
        treasury,
        tokenName,
        tokenSymbol,
        {value: ether('0.002')}
    );
    const distributorAddress = tx.logs[0].args.contractAddress;
    console.log(`Successfully deployed at ${distributorAddress}`);

    const distributor = await Distributor.at(distributorAddress);
    //approving TokenController to move the distributor's NXM
    await distributor.approveNXM(await master.getLatestAddress(hex('TC')), '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');

    if (network.name !== 'mainnet') {
        console.log('Using test network. Self-approving kyc..');
        const master = await INXMaster.at(await factory.master());
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
