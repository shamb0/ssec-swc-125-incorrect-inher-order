// SPDX-License-Identifier: MIT
// pragma solidity ^0.4.18;
// pragma solidity ^0.4.25;
// pragma solidity ^0.5.1;
// pragma solidity ^0.6.0;
pragma solidity ^0.6.0;


import "./SafeMath.sol";
import "./Crowdsale.sol";

import "@nomiclabs/buidler/console.sol";

/**
 * @title WhitelistedCrowdsale
 * @dev Extension of Crowsdale with a whitelist of investors that
 * can buy before the start block
 */
abstract contract WhitelistedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    mapping (address => bool) public whitelist;

    function addToWhitelist(address addr) public {
        require(msg.sender != address(this));
        whitelist[addr] = true;
    }

    // overriding Crowdsale#validPurchase to add extra whitelit logic
    // @return true if investors can buy at the moment
    function validPurchase() internal view override virtual returns (bool) {
        console.log("WhitelistedCrowdsale.sol::validPurchase");
        return super.validPurchase() || (whitelist[msg.sender] && !hasEnded());
    }

}
