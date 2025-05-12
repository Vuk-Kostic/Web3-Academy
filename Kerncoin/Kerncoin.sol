// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Kerncoin is ERC20 {
    constructor(uint256 initialSupply) ERC20("Kerncoin", "KERNC "){
        _mint(msg.sender, initialSupply * (10**decimals()));
    }
}