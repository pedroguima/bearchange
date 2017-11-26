pragma solidity ^0.4.4;

import "./Owned.sol";

contract Bearchange is Owned {
  address owner;

  struct token {
    string symbol;
    address contract_address;
  }

  mapping(uint => token) tokens;
  uint numTokens;

  struct offer {
    uint amount;
    address who;
  }

  struct orderBook {
    uint higherPrice;
    uint lowerPrice;
    mapping (uint => offer) offers;

    uint offers_key;
    uint offers_length;  
  }

  mapping(uint => orderBook) buyBook;
  mapping(uint => orderBook) sellBook;

  mapping(address => uint) balancesInEther;
  // address => ( tokenNum => balance)
  mapping(address => mapping (uint => uint)) balancesInTokens; 


  function Bearchange() public {
    owner = msg.sender;
  }

  //////////////////////////////////
  /// Ether
  ///////////////////////////////////

  /// Ether management functions
  function depositEther() payable public {
    // check for dodgy overflow stuff
    require (balancesInEther[msg.sender]+msg.value>=balancesInEther[msg.sender]);
    balancesInEther[msg.sender] += msg.value;
  }

  // amount in wei
  function withdrawEther(uint _amount) public {
    require(balancesInEther[msg.sender]-_amount >= 0);
    require(balancesInEther[msg.sender]-_amount <= balancesInEther[msg.sender]);
    balancesInEther[msg.sender] = balancesInEther[msg.sender]-_amount;
    msg.sender.transfer(_amount);
  }

  //////////////////////////////////
  /// Tokens 
  ///////////////////////////////////
  
  function withdrawToken(string _tokenSymbol, uint _amount) public {
    require(hasSymbol(_tokenSymbol));
    uint tokenIndex = getTokenIndex(_tokenSymbol);
    require(balancesInTokens[msg.sender][_tokenIndex] - _amount >= 0);
    require(balancesInTokens[msg.sender][_tokenIndex] - _amount < balancesInTokens[msg.sender][_tokenIndex]);
  
    ERC20Interface token = ERC20Interface(tokens[tokenIndex].contract_address);
    require(token.transfer(msg.sender, amount) == true);
  }

  function depositToken(string _tokenSymbol, uint _amount) public {
    require(hasSymbol(_tokenSymbol));
    require(amount>0);

    uint tokenIndex = getTokenIndex(_tokenSymbol);
    uint tokenContractAddress = tokens[tokenIndex].contract_address;
    
    ERC20Interface token = ERC20Interface(tokenContractAddress);
    require(token.transferFrom(msg.sender, address(this), amount) == true);
    require(balancesInTokens[msg.sender][tokenIndex] + amount >= balancesInTokens[msg.sender][tokenIndex]);
    balancesInTokens[msg.sender][tokenIndex] += amount;

  }

  function getBalanceToken(string _tokenSymbol) constant public returns (uint) {
    uint tokenIndex = getTokenIndex(_tokenSymbol);
    return balancesInTokens[msg.sender][tokenIndex];
  }

  /// Add ERC20 Token
  function addToken(string _symbol, address _contract_address) onlyByOwner public returns (bool) {
    require(!hasSymbol(_symbol));
    token memory t;
    t.contract_address = _contract_address;
    t.symbol = _symbol;
    tokens[numTokens] = t;
    numTokens++;
    return true;
  }


  /// Check if ERC20 token symbol exists
  function hasSymbol(string _symbol) public constant returns (bool)  {
    if(numTokens == 0) {
      return false;
    }

    for(uint i=0; i<numTokens; i++) {
      if(keccak256(tokens[i].symbol) == keccak256(_symbol)) {
        return true;
      }
    }
    return false;
  }

  /// Get ERC20 token index
  function getTokenIndex(string _symbol) public constant returns (uint) {
    require(hasSymbol(_symbol));

    for(uint i=0; i<numTokens; i++) {
      if(keccak256(tokens[i].symbol) == keccak256(_symbol)) {
        return i;
      }
    }
  }

  function getTokenAddress(uint _index) public constant returns (address) {
    return(tokens[_index].contract_address);
  }
}

