// SPDX-License-Identifier: MIT
// pragma solidity ^0.4.18;
// pragma solidity ^0.4.25;
// pragma solidity ^0.5.1;
// pragma solidity ^0.6.0;
pragma solidity ^0.6.0;

import "./SafeMath.sol";
import "./ERC20Mintable.sol";

import "@nomiclabs/buidler/console.sol";

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end block, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale {
    using SafeMath for uint256;

    // The token being sold
    ERC20Mintable public token;

    // start and end block where investments are allowed (both inclusive)
    uint256 public startBlock;
    uint256 public endBlock;

    // address where funds are collected
    address payable public wallet;

    // how many token units a buyer gets per wei
    uint256 public rate;

    // amount of raised money in wei
    uint256 public weiRaised;

    /**
    * event for token purchase logging
    * @param purchaser who paid for the tokens
    * @param beneficiary who got the tokens
    * @param value weis paid for purchase
    * @param amount amount of tokens purchased
    */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    constructor (uint256 _startBlock, uint256 _endBlock, uint256 _rate, address payable _wallet) public {
        require(_startBlock >= block.number);
        require(_endBlock >= _startBlock);
        require(_rate > 0);
        require(_wallet != address(0x0));

        token = createTokenContract();
        startBlock = _startBlock;
        endBlock = _endBlock;
        rate = _rate;
        wallet = _wallet;
    }

    // creates the token to be sold.
    // override this method to have crowdsale of a specific mintable token.
    function createTokenContract() internal returns (ERC20Mintable) {
        return new ERC20Mintable();
    }

    receive () external payable {
        console.log("Crowdsale.sol::receive");
        buyTokens(msg.sender);
    }

    // low level token purchase function
    function buyTokens(address beneficiary) public payable {
        require(beneficiary != address(0x0));
        require(validPurchase());

        uint256 weiAmount = msg.value;

        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(rate);

        // update state
        weiRaised = weiRaised.add(weiAmount);

        token.mint(beneficiary, tokens);
        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal view virtual returns (bool) {
        uint256 current = block.number;
        bool withinPeriod = current >= startBlock && current <= endBlock;
        bool nonZeroPurchase = msg.value != 0;
        console.log("Crowdsale.sol::validPurchase");
        return withinPeriod && nonZeroPurchase;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public view virtual returns (bool) {
        console.log("Crowdsale.sol::hasEnded");
        return block.number > endBlock;
    }
}
