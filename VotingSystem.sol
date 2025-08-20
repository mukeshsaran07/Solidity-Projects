// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VotingSystem {
    address public owner;
    uint256 public votingStart;
    uint256 public votingEnd;
    uint256 public totalVotes;

    struct Candidate {
        string name;
        uint256 votes;
        bool exists;
    }

    mapping(string => Candidate) public candidates;
    string[] public candidateNames;
    mapping(address => bool) public hasVoted;

    // Events
    event CandidateAdded(string name);
    event CandidateRemoved(string name);
    event VoteCasted(address voter, string candidate);
    event WinnerDeclared(string winner, uint256 maxVotes);

    constructor() {
        owner = msg.sender;
    }

    // --- Modifiers ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier beforeVotingStarts() {
        require(votingStart == 0 || block.timestamp < votingStart, "Voting already started");
        _;
    }

    modifier duringVoting() {
        require(votingStart != 0 && block.timestamp >= votingStart, "Voting not started");
        require(block.timestamp <= votingEnd, "Voting ended");
        _;
    }

    // --- Candidate Management ---
    function addCandidate(string memory _name) external onlyOwner beforeVotingStarts {
        require(!candidates[_name].exists, "Candidate already exists");

        candidates[_name] = Candidate(_name, 0, true);
        candidateNames.push(_name);

        emit CandidateAdded(_name);
    }

    function removeCandidate(string memory _name) external onlyOwner beforeVotingStarts {
        require(candidates[_name].exists, "Candidate not found");

        delete candidates[_name];

        // Remove from candidateNames array
        for (uint256 i = 0; i < candidateNames.length; i++) {
            if (keccak256(bytes(candidateNames[i])) == keccak256(bytes(_name))) {
                candidateNames[i] = candidateNames[candidateNames.length - 1];
                candidateNames.pop();
                break;
            }
        }

        emit CandidateRemoved(_name);
    }

    // --- Voting Control ---
    function startVoting(uint256 _duration) external onlyOwner beforeVotingStarts {
        require(_duration > 0, "Duration must be > 0");
        votingStart = block.timestamp;
        votingEnd = block.timestamp + _duration;
    }

    // --- Voting ---
    function vote(string memory _candidateName) external duringVoting {
        require(!hasVoted[msg.sender], "Already voted");
        require(candidates[_candidateName].exists, "Candidate not found");

        candidates[_candidateName].votes += 1;
        hasVoted[msg.sender] = true;
        totalVotes += 1;

        emit VoteCasted(msg.sender, _candidateName);
    }

    // --- Results ---
    function getWinner() public view returns (string memory, uint256) {
        require(votingEnd != 0 && block.timestamp > votingEnd, "Voting still active");

        string memory winner;
        uint256 maxVotes = 0;

        for (uint256 i = 0; i < candidateNames.length; i++) {
            string memory name = candidateNames[i];
            uint256 votes = candidates[name].votes;

            if (votes > maxVotes) {
                maxVotes = votes;
                winner = name;
            }
        }

        return (winner, maxVotes);
    }

    function declareWinner() external onlyOwner {
        (string memory winner, uint256 maxVotes) = getWinner();
        emit WinnerDeclared(winner, maxVotes);
    }

    // --- Helpers ---
    function candidateCount() external view returns (uint256) {
        return candidateNames.length;
    }
}
