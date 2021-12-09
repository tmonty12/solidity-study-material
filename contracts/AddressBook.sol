//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;


/**
 * @author Thomas Montfort
 * @title A simple address book
 */
contract AddressBook {

    /// struct for a type of "address" // this allows every user to have their address book//
    struct Record {
        string name;
        address addr;
        string note;
    }

    /// mapping to link user with their addressbook 
    mapping (address => Record[]) private _aBook;


    function getStringLength(string memory _str) public pure returns (uint256){
        bytes memory bts = bytes(_str);
        return bts.length;
    }

    /**
     * @param _name name of the individual
     * @param _addr address of the individual
     * @param _note note to include with address
     * @dev adds an address to the msg.sender's address book
     */
    function addAddress(string memory _name, address _addr, string memory _note) public {
        require(getStringLength(_name) >= 1, "Name can not be empty");
        Record memory newRecord = Record(_name, _addr, _note); // created in memory - don't need the variable to persist
        _aBook[msg.sender].push(newRecord);
    }
    
    /**
     * @dev returns the address book of the msg.sender
     * @return the address book of msg.sender
     */
    function getAddrBook() public view returns (Record[] memory){
        return _aBook[msg.sender];
    }

}