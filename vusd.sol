// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract vusd is  ERC20 {
    
    constructor() public ERC20("vusd1", "VUSD") { 
    }
    
    bool statusVusd ; 
    address ownerVusd = msg.sender;
    address addresswithdraw = msg.sender;

    uint moneyWithdrawed = 0;

    address public addressVNC;

    vnc VNC = vnc(addressVNC);
    uint moneyICanWithdraw = VNC.moneyIcanUse();


    address  USDC = 0x38558FB189f9fB0a6B455064477627Fdbe3d0f1c;

    event buyVusd(address _address, uint _amount);
    event sellVusd(address _address, uint _amount);
    event changestatuesVusd(bool _status);
    event changeownerVusd(address _address);



    function buyVUSD(uint _amount) public {
        require(statusVusd, "Contract is maintaining");
        require(_amount > 0);
        require(IERC20(USDC).allowance(msg.sender, address(this)) == _amount*10**18,"You must approve in web3");
        require(IERC20(USDC).transferFrom(msg.sender, address(this),_amount*10**18), "Transfer failed");
        _mint(msg.sender, _amount*10**18);
        emit buyVusd(msg.sender, _amount);

    }

    function sellVUSD(uint _amount) public {
        require(statusVusd, "Contract is maintaining");
        require(_amount > 0);
        require(IERC20(USDC).balanceOf(address(this))>= _amount*10**18, "Balance is not enough");
        require(transfer(address(this), _amount*10**18), "Transfer failed");
        IERC20(USDC).transfer(msg.sender, _amount*10**18);
        emit sellVusd(msg.sender, _amount);

    }

    function withdraw() public {
        require(msg.sender == addresswithdraw,"permission denied");
        require(moneyICanWithdraw >= moneyWithdrawed);
        IERC20(USDC).transfer(msg.sender, (moneyICanWithdraw - moneyWithdrawed));
        moneyWithdrawed += (moneyICanWithdraw - moneyWithdrawed);
    }
    
    function changeWithdraw(address _address) public {
        require(_address != address(0), "Address is invalid");
        require(msg.sender == ownerVusd,"permission denied");
        addresswithdraw = _address;
    }
        

    function checkBalance(address _token) public view returns(uint){
       return IERC20(_token).balanceOf(address(this));
    }
    
    function changeStatusVusd(bool _status) public {
        require(msg.sender == ownerVusd,"permission denied");
        statusVusd = _status;
        emit changestatuesVusd(_status);
    }

    function changeOwnerVusd(address _address) public {
        require(msg.sender == ownerVusd,"permission denied");
        require(_address != address(0), "Address is invalid");
        ownerVusd = _address;
        emit changeownerVusd(_address);
    }

    function updateVNCAddress(address _address) public {
        require(msg.sender == ownerVusd);
        addressVNC = _address;

    }

} 

abstract contract vnc {
    function moneyIcanUse() public virtual  returns(uint);
}