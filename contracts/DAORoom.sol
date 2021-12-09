//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @author Thomas Montfort
 * @title A simple DAO room
 */
contract DAORoom {

    address payable public owner;

    uint public cost;

    enum Status {Vacant, Occupied}

    Status currentStatus;

    event Occupied(address _occupant);

    constructor() {
        owner =  payable(msg.sender);
        cost = 1;
        currentStatus = Status.Vacant;
    }

    modifier onlyWhenVacant {
        require(currentStatus == Status.Vacant, "Room is occupied");
        _;
    }

    /**
     * @dev rents out the room to msg.sender
     */
    function rent() external payable onlyWhenVacant {
        require(msg.value != cost, "Insufficient funds");
        owner.transfer(msg.value);
        emit Occupied(msg.sender);
    } 



}