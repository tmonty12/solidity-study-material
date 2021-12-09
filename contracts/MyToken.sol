//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @title Interface for the ERC20 token standard
 */
interface ERC20 {
    function totalSupply() external view returns (uint _totalSupply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

/**
 * @author Thomas Montfort
 * @title A simple token implementation
 */
contract MyToken is ERC20 {
    
    string public constant symbol = "MTK";
    string public constant name = "MyToken";
    uint256 public constant decimals = 18;

    uint256 private constant _totalSupply = 1000000000000000000000;

    // keeps track of the balance of each address
    mapping (address =>  uint256) private _balanceOf;

    // keeps track of the allowances an address provides to all other addresses
    mapping (address => mapping(address => uint256)) private _allowances;

    // creator of contract has control over to total supply
    constructor() {
        _balanceOf[msg.sender] = _totalSupply;
    }

    /**
     * @dev returns the total supply of the token
     */
    function totalSupply() public pure override returns (uint256){
        return _totalSupply;
    }

    /**
     * @dev returns the balance of the address 
     */
    function balanceOf(address _addr) public view override returns (uint256) {
        return _balanceOf[_addr];
    }

    /**
     * @dev transfers tokens from msg.sender to another address
     */
    function transfer(address _to, uint256 _value) public override returns (bool) {
        // make sure there is a value and that the sender has more than or same as amount sent
        if(_value > 0 &&  _value <= balanceOf(msg.sender)) {
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value; 
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    /**
     * @dev determines if the address holds a contract
     */
    function isContract(address _addr) public view returns (bool) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }
        return codeSize > 0;  
    }

    /**
    * @dev allows an address to claim an allowance from a certain address
    */
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        if(_allowances[_from][msg.sender] > 0 &&
        _value > 0 && 
        _allowances[_from][msg.sender] >= _value &&
        _value <= balanceOf(msg.sender) &&
        !isContract(_to)) {                
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value; 
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    /**
    * @dev approves an allowance from the msg.sender to a certain spender address
    */
    function approve(address _spender, uint256 _value) external override returns (bool) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval (msg.sender, _spender, _value);
        return true;
    }
    /**
     * @dev returns the allowance for a spender from an owner
     */
    function allowance(address _owner, address _spender) external override view returns (uint256) {
        return _allowances[_owner][_spender];
    }
}