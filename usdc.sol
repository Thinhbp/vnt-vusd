// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MintableToken is  ERC20 {
    constructor() public ERC20("usdc", "USDC") {
    }

    function mintToken(uint _amount) public {
        _mint(msg.sender, _amount * 10 **18);
    }
}
