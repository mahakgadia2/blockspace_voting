pragma solidity ^0.8.2;

contract Voting {
    //  Structure for Candidate
    struct Candidate {
        string name;
        uint256 voteCount;
    }
    
    // creating an array for the candidate structure
    Candidate[] public candidates;
    address owner;
    // checking whether msg sender has voted or not
    mapping(address => bool) public voters;

    // timestamps for start and end of voting
    uint256 public votingStart;
    uint256 public votingEnd; 

    constructor(string[] memory _candidateNames, uint256 _durationInMinutes) {
    // adding candidate name
    for (uint256 i = 0; i < _candidateNames.length; i++) {
        candidates.push(Candidate({
            name: _candidateNames[i],
            voteCount: 0
        }));
    }

    owner = msg.sender;
    votingStart = block.timestamp;
    votingEnd = block.timestamp + (_durationInMinutes * 1 minutes); 
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    // lets the owner add candidates later
    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({
                name: _name,
                voteCount: 0
        }));
    }

    // lets the msg sender vote for candidates
    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted."); // prevent double votes
        require(_candidateIndex < candidates.length, "Invalid candidate index."); // prevent invalid candidates
        require(block.timestamp >= votingStart && block.timestamp < votingEnd ); // make sure voting is during time limit

        candidates[_candidateIndex].voteCount++; 
        voters[msg.sender] = true;
    }
    // get all the votes for candidates at the same time 
    function getAllVotes() public view returns (Candidate[] memory){
        return candidates; 
    }
    
    //check whether you can still vote to close down the voting if needed
    function getVotingStatus() public view returns (bool) {
    return (block.timestamp >= votingStart && block.timestamp < votingEnd); 
    }

    function getRemainingTime() public view returns (uint256) {
        require(block.timestamp >= votingStart, "Voting has not started yet."); 
        require(block.timestamp < votingEnd, "Voting has ended.");
        
        if (block.timestamp >= votingEnd) {
            return 0;
        }
        return votingEnd - block.timestamp;
}
}