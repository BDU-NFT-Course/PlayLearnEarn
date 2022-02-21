// File: contracts/ple.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PlayLearnEarnV2 is ERC1155, Ownable {
    string public constant name = "Play Learn Earn V2";
    string public constant symbol = "PLE";
    string public itemURI = "https://raw.githubusercontent.com/BDU-NFT-Course/ple-data/main/v2/{id}.json";


    mapping(address => bool) public pleAdmins;

    mapping(uint => bool) levelInit;
    mapping(uint => bool) levelOnOff;

    constructor() ERC1155(itemURI){
        pleAdmins[msg.sender] = true; 
    }

    function mintCertAdmin(address toAccount, uint256 id, uint256 amount) public returns (uint256) {
        require(pleAdmins[msg.sender] && levelOnOff[id], "Minting not authorised");
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