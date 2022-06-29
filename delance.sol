// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract Delance {
    address public freelancer;
    address public employer;
    uint256 public deadline;
    uint256 public price;
    Request[] public requests;

    struct Request {
        uint256 amount;
        string title;
        bool locked;
        bool paid;
    }

    modifier onlyFreelancer(uint256 _amount) {
        // keep error messages small
        require(msg.sender == freelancer, "Only freelancer!");
        require(_amount > 0, "Should be greater than 0!");
        _;
    }

    constructor(address _freelancer, uint256 _deadline) payable {
        freelancer = _freelancer;
        // global variable property: has the address of
        // sender who called constructor
        deadline = _deadline;
        employer = msg.sender;
        // global variable property: contains eth sent to contract
        price = msg.value;
    }

    function setAddress(address _freelancer) public {
        freelancer = _freelancer;
    }

    function setDeadline(uint256 _deadline) public {
        deadline = _deadline;
    }

    function createRequest(uint256 _amount, string memory _title)
        public
        onlyFreelancer(_amount)
    {
        Request memory request = Request({
            amount: _amount,
            title: _title,
            locked: true,
            paid: false
        });

        requests.push(request);
    }

    // called when any ethers are sent to contract
    receive() external payable {
        price += msg.value;
    }
}
