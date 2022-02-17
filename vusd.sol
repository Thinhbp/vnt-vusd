// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract vusd is  ERC20 {
    
    constructor() public ERC20("vusd", "VUSD") { 
    }
    
    bool status ; 
    address owner = msg.sender;
    address addresswithdraw = msg.sender;

    uint moneyWithdrawed = 0;

    address public addressVNC;


 


    address  USDC = 0x38558FB189f9fB0a6B455064477627Fdbe3d0f1c;

    event buy(address _address, uint _amount);
    event sell(address _address, uint _amount);
    event changestatues(bool _status);
    event changeowner(address _address);



    function buyToken(uint _amount) public {
        require(status, "Contract is maintaining");
        require(_amount > 0);
        //require(IERC20(USDC).allowance(msg.sender, address(this)) == _amount*10**18,"You must approve in web3");
        //require(IERC20(USDC).transferFrom(msg.sender, address(this),_amount*10**18), "Transfer failed");
        _mint(msg.sender, _amount*10**18);
        emit buy(msg.sender, _amount);

    }

    function sellToken(uint _amount) public {
        require(status, "Contract is maintaining");
        require(_amount > 0);
        require(IERC20(USDC).balanceOf(address(this))>= _amount*10**18, "Balance is not enough");
        require(transfer(address(this), _amount*10**18), "Transfer failed");
        IERC20(USDC).transfer(msg.sender, _amount*10**18);
        emit sell(msg.sender, _amount);

    }

    function withdraw() public {
        require(msg.sender == addresswithdraw,"permission denied");
        uint moneyCanWithdraw = vnc(addressVNC).moneyIcanUse();
        require(moneyCanWithdraw > moneyWithdrawed);
        IERC20(USDC).transfer(msg.sender, (moneyCanWithdraw - moneyWithdrawed));
        moneyWithdrawed += (moneyCanWithdraw - moneyWithdrawed);
    }
    
    function changeWithdraw(address _address) public {
        require(_address != address(0), "Address is invalid");
        require(msg.sender == owner,"permission denied");
        addresswithdraw = _address;
    }
        

    function checkBalance(address _token) public view returns(uint){
       return IERC20(_token).balanceOf(address(this));
    }
    
    function changeStatus(bool _status) public {
        require(msg.sender == owner,"permission denied");
        status = _status;
        emit changestatues(_status);
    }

    function changeOwner(address _address) public {
        require(msg.sender == owner,"permission denied");
        require(_address != address(0), "Address is invalid");
        owner = _address;
        emit changeowner(_address);
    }

    function updateVNCAddress(address _address) public {
        require(msg.sender == owner);
        addressVNC = _address;

    }

} 

abstract contract vnc {
    function moneyIcanUse() public virtual  returns(uint);
}

