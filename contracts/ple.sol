// File: contracts/ple.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PlayLearnEarnAlpha is ERC1155, Ownable {
    string public constant name = "Play Learn Earn Alpha";
    string public constant symbol = "PLE";
    string public itemURI = "https://raw.githubusercontent.com/BDU-NFT-Course/WisdomHub-Dev/main/metadata/{id}.json";
    using Counters for Counters.Counter;
    Counters.Counter private _certIds;
    uint public totalLevels;

    mapping(address => bool) public pleAdmins;

    mapping(uint => bool) levelInit;

    constructor() ERC1155(itemURI){
        _mint(msg.sender,0,1,"");
        levelInit[0]=true;
        _certIds.increment();
        totalLevels = _certIds.current();
        pleAdmins[msg.sender] = true; //adding Owner during Verify?
    }

    function addAdmin(address newAdminAddr) public onlyOwner {
        pleAdmins[newAdminAddr] = true;
    }

    function removeAdmin(address newAdminAddr) public onlyOwner {
        pleAdmins[newAdminAddr] = false;
    }

    function mintCert(address toAccount, uint256 id) public returns (uint256) {
        require(levelInit[id], "Certification Level is not released yet");
        _mint(toAccount, id, 1, "");
        return id;
    }

    function initLevel(address toAccount) public returns (uint256) {
        require(pleAdmins[msg.sender] == true, "Not an authorized Admin");
        uint256 id = _certIds.current();
        _mint(toAccount, id, 1, "");
        levelInit[id]=true;
        _certIds.increment();
        totalLevels = _certIds.current();
        return id;
    }

    function burn(address itemOwnerAccount, uint256 id, uint256 amount) public {
        require(msg.sender == itemOwnerAccount);
        _burn(itemOwnerAccount, id, amount);
    }

    function contractURI() public pure returns (string memory) {
        return "https://raw.githubusercontent.com/BDU-NFT-Course/NFT-Metadata/main/sample-certs/contract-metadata-erc1155.json";
    }

}