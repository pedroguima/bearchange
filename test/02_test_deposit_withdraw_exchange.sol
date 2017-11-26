//
//// test deposit
//
//var bearchange = artifacts.require("./Bearchange");
//
//contract('Bearchange test', function(accounts) {
//  
//
//  it("Deposit should result in balance increase for user in exchange", function () {
//    var account0 = accounts[0];
//    var account0_starting_balance = web3.eth.getBalance(accounts[0]).
//    var account0_finishing_balance;
//    
//    var amount = 10;
//
//    return bearchange.deployed().then(function(instance) {
//      return instance.depositEther({from: accounts[0], value: web3.toWei(amount, "ether")});
//    }).then(function (txhash) {
//            gasUsed += txHash.receipt.cumulativeGasUsed * web3.eth.getTransaction(txHash.receipt.transactionHash).gasPrice.toNumber(); //here we have a problem
//            balanceAfterDeposit = web3.eth.getBalance(accounts[0]);
//            return myExchangeInstance.getEthBalanceInWei.call();      
//    
//    });
//    
//  });
//
//
//});
