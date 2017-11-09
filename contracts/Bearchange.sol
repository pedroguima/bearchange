pragma solidity ^0.4.4;

import "./owned.sol";

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
    

    
    function Bearchange() public {
        owner = msg.sender;
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
    
    function getTokenAddress(uint _index) public constant returns (address) {
        return(tokens[_index].contract_address);
    }
}

