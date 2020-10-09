import { expect } from './setup'

/* External Imports */
import { ethers } from '@nomiclabs/buidler'
import { readArtifact } from '@nomiclabs/buidler/plugins'

import { Contract, ContractFactory, Signer, BigNumber, utils, providers } from 'ethers'
import {
  getContractFactory, sleep, sendLT, getBalanceLT, ContractDeployOptions, deployContract, linkBytecode
} from './test-utils'

import { getLogger } from './test-utils'

import { GAS_LIMIT } from './test-helpers'
import { Artifact } from '@nomiclabs/buidler/types'

const log = getLogger('Phisable-Test')

function getRandomNumberBetween( min:number , max:number ){

  return Math.floor( Math.random() * (max-min+1) + min );
}

describe('MDTCrowdsale Test', () => {
  let wallet: Signer
  let usr1: Signer
  let usr2: Signer
  let usr3: Signer

  before(async () => {
    ;[wallet, usr1, usr2, usr3] = await ethers.getSigners()

    log.info(`Admin :: ${await wallet.getAddress()}`)
    log.info(`Usr1 :: ${await usr1.getAddress()}`)
    log.info(`Usr2 :: ${await usr2.getAddress()}`)
    log.info(`Usr3 :: ${await usr3.getAddress()}`)
  })

  let MDTCrowdsalefact: ContractFactory
  let MDTCrowdsaleinst: Contract
  before(async () => {

    MDTCrowdsalefact = getContractFactory( "MDTCrowdsale", wallet )

    log.debug( `Network Gas price @ ${await ethers.provider.getGasPrice()}`)

    log.debug(`S1-Ent wallet bal :: ${ethers.utils.formatUnits(await wallet.getBalance(), "ether")}`)

    MDTCrowdsaleinst = await MDTCrowdsalefact.deploy()

    log.debug( `MDTCrowdsale @ ${MDTCrowdsaleinst.address}`)

    const bal = await MDTCrowdsaleinst.provider.getBalance( MDTCrowdsaleinst.address )

    log.debug(`MDTCrowdsale balance :: ${ethers.utils.formatUnits( bal , "ether" )}`)

    log.debug(`S1-Ext wallet bal :: ${ethers.utils.formatUnits(await wallet.getBalance(), "ether")}`)

  })


  it("tst-item-001-run-attack", async () => {

    try {

      log.debug(`S2-Ent :: ${ethers.utils.formatUnits( await wallet.getBalance(), "ether")}`)

      log.debug(`S2-Ent usr1 bal :: ${ethers.utils.formatUnits( await usr1.getBalance(), "ether")}`)

      const tempcontint = new Contract( MDTCrowdsaleinst.address,
                                      MDTCrowdsalefact.interface,
                                      usr1
                                      )

      const transamount = ethers.utils.parseUnits( "10", 18 )

      const receipt = await usr1.sendTransaction({
        to: tempcontint.address,
        value: transamount,
        gasLimit: GAS_LIMIT,
      })
      
      await MDTCrowdsaleinst.provider.waitForTransaction( receipt.hash )

      log.debug(`S2-Ext usr1 bal :: ${ethers.utils.formatUnits( await usr1.getBalance(), "ether")}`)

      log.debug(`S2-Ext :: ${ethers.utils.formatUnits( await wallet.getBalance(), "ether")}`)
    }
    catch( err ){

      log.error(`Exception Err ${err}`)

    }
  })

  afterEach("Test-Case End Contract Status", async () => {

    let bal = await MDTCrowdsaleinst.provider.getBalance( MDTCrowdsaleinst.address );

    log.debug(`MDTCrowdsale balance :: ${ethers.utils.formatUnits( bal , "ether" )}`)

    log.debug(`S3-Ext wallet bal :: ${ethers.utils.formatUnits(await wallet.getBalance(), "ether")}`)

  })

  after("Test Done Cleanup", async () => {

    // await phishableattackinst.closeContract( await wallet.getAddress() )

    let bal = await MDTCrowdsaleinst.provider.getBalance( MDTCrowdsaleinst.address );

    log.debug(`MDTCrowdsale balance :: ${ethers.utils.formatUnits( bal , "ether" )}`)

    log.debug(`S4-Ext wallet bal :: ${ethers.utils.formatUnits(await wallet.getBalance(), "ether")}`)

  })

})
