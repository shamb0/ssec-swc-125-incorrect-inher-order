// SPDX-License-Identifier: MIT
// pragma solidity ^0.4.18;
// pragma solidity ^0.4.25;
// pragma solidity ^0.5.1;
// pragma solidity ^0.6.0;
pragma solidity ^0.6.0;

import "./CappedCrowdsale.sol";
import "./WhitelistedCrowdsale.sol";

import "@nomiclabs/buidler/console.sol";


contract MDTCrowdsale is WhitelistedCrowdsale, CappedCrowdsale {
// contract MDTCrowdsale is CappedCrowdsale {
    constructor () public
    CappedCrowdsale(50000000000000000000000)
    Crowdsale(block.number, block.number + 100000, 1, msg.sender) { // Wallet is the contract creator, to whom funds will be sent
        addToWhitelist(msg.sender);
        addToWhitelist( 0x0D5BDa9Db5Dd36278c6A40683960bA58CAc0149b );
        addToWhitelist( 0x1B6dDC637C24305b354D7c337F9126F68AaD4886 );
    }

    function hasEnded() public view override(CappedCrowdsale, Crowdsale) returns (bool) {
        console.log("MDTCrowdsale.sol::hasEnded");
        return super.hasEnded();
    }

    function validPurchase() internal view override( WhitelistedCrowdsale, CappedCrowdsale ) returns (bool) {
        console.log("MDTCrowdsale.sol::validPurchase");
        return super.validPurchase();
    }

}
