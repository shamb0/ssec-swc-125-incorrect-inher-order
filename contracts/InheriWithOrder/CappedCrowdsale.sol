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
 * @title CappedCrowdsale
 * @dev Extension of Crowsdale with a max amount of funds raised
 */
 abstract contract CappedCrowdsale is Crowdsale {

    using SafeMath for uint256;
    uint256 public cap;

    constructor (uint256 _cap) internal {
        require(_cap > 0);
        cap = _cap;
    }

    // overriding Crowdsale#validPurchase to add extra cap logic
    // @return true if investors can buy at the moment
    function validPurchase() internal view override virtual returns (bool) {
        bool withinCap = weiRaised.add(msg.value) <= cap;
        console.log("CappedCrowdsale.sol::validPurchase");
        return super.validPurchase() && withinCap;
    }

    // overriding Crowdsale#hasEnded to add cap logic
    // @return true if crowdsale event has ended
    function hasEnded() public view override virtual returns (bool) {
        bool capReached = weiRaised >= cap;
        console.log("CappedCrowdsale.sol::hasEnded");
        return super.hasEnded() || capReached;
    }

}
