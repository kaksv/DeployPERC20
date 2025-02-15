// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Budde {

    // Error
    error Insufficient_balance_error(uint256 value, string message);
    

    // Name and symbol declaration
    string public name ="BUDDE";
    string public symbol= "BDE";

    // Integer declarations
    uint256 public decimal = 18;
    uint256 public totalSupply;

    // Mappings to initialise balanceOf and allowance
    mapping (address => uint256) public balanceOf;
    mapping(address => mapping (address => uint256)) public allowances;

    // Event emitted when transfers occur
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Event emitted when an approval occurs
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


    // constructor to allow the deployer to initialise total supply
    constructor (uint256 _totalSupply) {
        // First lets set the total supply state varable to a value that the deployer will put
        totalSupply = _totalSupply * 10 ** decimal;
        // Then lets supply the initial amount to the address of the deployer. You could use addresses in an array
        balanceOf[msg.sender] = totalSupply; //balanceOf is a global variable as well as msg.sender
    }

    //function for the name (optional) :
    function getName() external view returns (string memory) {
        return name;
    }

// function for symbol (optional)
    function getSymbol() external view returns (string memory) {
        return  symbol;
    }

    // function for decimals (optional)
    function getDecemals() external view returns (uint256) {
        return decimal;
    }


    // function for totalSupply :returns amount of token in existance
    function getTotalSupply() external view returns (uint256) {
        return totalSupply;
    }

    // function for balanceOf :returns the amount of tokens owned by an account
    function getBalance(address _owner) external  view returns (uint256) {
        
        return balanceOf[_owner];
    }

    // function for transfer :moves amount of the token from the callers account to receipient
    // returns a boolean value indicating whether the operation is succesful or not.
    // Emits the transfer event
    function transfer(address _to, uint256 _value) external returns (bool success) {
        // require costs more gas than custom errors ie
        // reuire balanceOf[msg.sender] >= _value, "You have insufficient funds"
        // 
        if(balanceOf[msg.sender] < _value){
           revert  Insufficient_balance_error(_value, "You have insufficient funds");
            
        }else {
            balanceOf[msg.sender] -= _value; //balance = balance - value (this is input by the wallet interactiong with the smart contract)
            balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
    }

    

   

    // Function for approving
    function approve (address _spender, uint256 _value) external  returns(bool success) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    // function for transfer from : Moves amount of tokens from sender to recipient using the allowance mechanism
    // amount is then deducted from the caller's allowance
    // Returns a boolean value to indicate whether the operation is succesful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        // require(balanceOf[_from] >= _value, "Not enough balance");
        // require(allowance[_from][msg.sender] >= _value, "Not Enough allowance");
        if(balanceOf[_from] < _value) {
            revert("Not enough balance");
        }else if(allowances[_from][msg.sender] < _value) revert ("Not enough allowance");
        else {
            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
            allowances[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        }
    }

    // function for allowance: Returns the remaining number of tokens that the spender will be allowed
    // to spend on behalf of owner through transferFrom. This is Zero by default.
    // It changes when approve or transferFrom are called.
    // Beware that changing an allowance with this method brings the risk that someone may use both the old and the new 
    // allowance by unfortunate transaction ordering. One possible solution to mitigate this 
    // race condition is to first reduce the spender’s allowance to 0 and set the desired 
    // value afterwards: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowances[_owner][_spender];
    }


    // EVENTS (these will be placed immediately below the functions have been called.
    // event Transfer 
    // event Approval

    // After these we can now consider other secondary but crucial parts of the token like
    // Token being mintable 
    // Token being burnable

    // burn

    // Airdrop

}
