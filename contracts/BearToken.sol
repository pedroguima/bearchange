pragma solidity ^0.4.4;

import "./owned.sol";

contract ERC20 {
  function totalSupply() constant returns (uint totalSupply);
  function balanceOf(address _owner) constant returns (uint balance);
  function transfer(address _to, uint _value) returns (bool success);
  function transferFrom(address _from, address _to, uint _value) returns (bool success);
  function approve(address _spender, uint _value) returns (bool success);
  function allowance(address _owner, address _spender) constant returns (uint remaining);
  event Transfer(address indexed _from, address indexed _to, uint _value);
  event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract BearToken is ERC20, Owned {
  string public constant symbol = "BEAR";
  string public constant name = "A pessimistic token";
  uint8 public constant decimals = 0;
  uint256 _totalSupply = 1000000;

  // Owner of this contract
  address public owner;

  // Balances for each account
  mapping (address => uint256) balances;

  // Owner of account approves the transfer of an amount to another account
  mapping (address => mapping (address => uint256)) allowed;

  // Constructor
  function BearToken() {
    owner = msg.sender;
    balances[owner] = _totalSupply;
  }

  function totalSupply() constant returns (uint256 totalSupply) {
    totalSupply = _totalSupply;
  }

  // What is the balance of a particular account?
  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

  // Transfer the balance from owner's account to another account
  function transfer(address _to, uint256 _amount) returns (bool success) {
    if (balances[msg.sender] >= _amount
        && _amount > 0
        && balances[_to] + _amount > balances[_to]) {
      balances[msg.sender] -= _amount;
      balances[_to] += _amount;
      Transfer(msg.sender, _to, _amount);
      return true;
    }
    else {
      return false;
    }
  }

  // Send _value amount of tokens from address _from to address _to
  // The transferFrom method is used for a withdraw workflow, allowing contracts to send
  // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
  // fees in sub-currencies; the command should fail unless the _from account has
  // deliberately authorized the sender of the message via some mechanism; we propose
  // these standardized APIs for approval:
  function transferFrom(
      address _from,
      address _to,
      uint256 _amount
      ) returns (bool success) {
    if (balances[_from] >= _amount
        && allowed[_from][msg.sender] >= _amount
        && _amount > 0
        && balances[_to] + _amount > balances[_to]) {
      balances[_from] -= _amount;
      allowed[_from][msg.sender] -= _amount;
      balances[_to] += _amount;
      Transfer(_from, _to, _amount);
      return true;
    }
    else {
      return false;
    }
  }


  // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
  // If this function is called again it overwrites the current allowance with _value.
  function approve(address _spender, uint256 _amount) returns (bool success) {
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

}
