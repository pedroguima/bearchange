var BearToken = artifacts.require("./BearToken.sol");
var Bearchange = artifacts.require("./Bearchange.sol");

module.exports = function(deployer) {
  deployer.deploy(BearToken);
  deployer.deploy(Bearchange);
};
