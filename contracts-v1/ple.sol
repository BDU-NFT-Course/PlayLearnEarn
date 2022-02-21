// File: contracts/ple.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TestPlayLearnEarnAlpha is ERC1155, Ownable {
    string public constant name = "TEST Play Learn Earn Beta";
    string public constant symbol = "TestPLE";
    string public itemURI = "https://raw.githubusercontent.com/BDU-NFT-Course/ple-data/main/v2/{id}.json";

    mapping(address => bool) public pleAdmins;

    mapping(uint => bool) levelInit;
    mapping(uint => bool) levelOnOff;

    mapping(uint => address []) ownersOf;

    constructor() ERC1155(itemURI){
        pleAdmins[msg.sender] = true; 
    }

    function mintMyCert(address toAccount, uint256 id) public returns (uint256) {
        require(
            balanceOf(msg.sender, 0) > 0 
            && id > 0 
            && levelOnOff[id], 
            "Level not available"
        );
        _mint(toAccount, id, 1, "");
        ownersOf[id].push(toAccount);
        return id;
    }

    function mintCertAdmin(address toAccount, uint256 id, uint256 amount) public returns (uint256) {
        require(pleAdmins[msg.sender] && levelOnOff[id], "Not an authorized Admin");
        if (!levelInit[id]){
           levelInit[id]=true;
        }
        _mint(toAccount, id, amount, "");
        return id;
    }

    function switchLevelOnOff(uint256 id) public returns (bool) {
        require(pleAdmins[msg.sender], "Not an authorized Admin");
            levelOnOff[id] = !levelOnOff[id];
        return levelOnOff[id];
    }

    function getLevelOnOff(uint256 id) public view returns (bool) {
        return levelOnOff[id];
    }
    
    function getOwnersOf(uint256 id) public view returns (address [] memory) {
        return ownersOf[id];
    }

    function addAdmin(address newAdminAddr) public onlyOwner {
        pleAdmins[newAdminAddr] = true;
    }

    function removeAdmin(address newAdminAddr) public onlyOwner {
        pleAdmins[newAdminAddr] = false;
    }

    function burn(address itemOwnerAccount, uint256 id, uint256 amount) public {
        require(msg.sender == itemOwnerAccount);
        _burn(itemOwnerAccount, id, amount);
    }

}