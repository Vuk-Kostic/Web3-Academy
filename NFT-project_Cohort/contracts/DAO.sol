// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./Membership_NFT.sol";

contract DAO  {
    NFT public mNFT; // objekat naseg contracta

    struct Proposal { // kreiranje datatype-a Proposal
    address proposalCreator;
    string description;
    uint256 deadline;
    uint256 votesFor;
    uint256 votesAgainst;
    bool executed;
    }

    Proposal[] public proposals; // array zarad storovanja proposala koji se cekaju na upit
    Proposal[] public accprop; // array za prihvacene proposale nakon executovanja istog


    // EVENTS
    // kod parametara nalazi se keyword indexed koji omogucava njihovu filtraciju i pretragu
    // to omogucava tim procesima da dosta smanje cenu gasa i omoguce te metode

    event MembershipMinted(address indexed member);
    event ProposalCreated(uint256 indexed proposalID, address indexed creator, string description);
    event UserVoted(uint256 indexed proposalID, address indexed voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalID, bool executed);


    // CUSTOM ERROR TYPES
    error NotNFTHolder();
    error AlreadyVoted();
    error VotingPeriodEnded();
    error ProposalAlreadyExecuted();
    error ProposalNotFound();


    constructor(){
        mNFT= new NFT(address(this), msg.sender); //mintuje prvi NFT-a creatoru(DAO)
    }


    function createProp(string memory _description) external {
        require(mNFT.isMinted(msg.sender), NotNFTHolder());

        Proposal memory newProp = Proposal({ // poenta keyword-a memory je da se sacuva na RAMU dok se ne ubaci u array za proposale
            proposalCreator: msg.sender,
            description: _description,
            deadline: block.timestamp + 7 days,
            votesFor: 0, // votovi se stavljaju na 0 jer je se ovime generise objekat Proposal,
            votesAgainst: 0, // znaci da je po defaultu neutralan
            executed: false // ovo se postavlja na true kada se zavrsi votovanje
        });


        proposals.push(newProp); // appenduje na array proposals

        emit ProposalCreated(proposals.length - 1, msg.sender, _description); // length-1 je jer indexiranje arrayija pocinje od 0

    }


// !!! JAKO BITNO !!!
// ovo nam omogucava da sacuamo i inicalizjuemo variajblu hasVoted
// njena funkcionalnost je da prati za svakog membera da li je votovao
// ili nije na specifican proposal koji se dobija uz pomoc proposalID-a

    mapping(uint256 => mapping(address => bool)) public hasVoted;



    // funkcija za glasanje za proposal
    function voteForProp(uint256 proposalID, bool vote) external {
        Proposal storage prop = proposals[proposalID]; // ovo nam sluzi da "izvadi" podatke iz arraya
                                                        // Proposal kako bi koristili podatke za taj specifican
                                                        // proposal


        require(mNFT.isMinted(msg.sender),NotNFTHolder());
        require(proposalID <proposals.length, ProposalNotFound());
        require(block.timestamp < prop.deadline, VotingPeriodEnded());
        require(hasVoted[proposalID][msg.sender] == false,AlreadyVoted());

        if (vote == true){
            prop.votesFor++;
        }else{
            prop.votesAgainst++;
        }
        hasVoted[proposalID][msg.sender] = true;
        emit UserVoted(proposalID, msg.sender, vote);

    }   
    // funkcija za prihvacanje ili odbijanje proposala
    function executeProp(uint256 proposalID) external {
        Proposal storage prop = proposals[proposalID]; // neohpodno za accesovanje podacima proposala
        require(proposalID < proposals.length,ProposalNotFound());
        require(block.timestamp >= prop.deadline, VotingPeriodEnded());
        require(prop.executed == false, ProposalAlreadyExecuted());

        if(prop.votesAgainst >= prop.votesFor){
        }else{
            accprop.push(prop); // appenduje proposal na array u kome su prihvaceni proposali
        }
        prop.executed = true; // stavlja proposal na True, cime se onemogucuje dalje votovanje na njemu

        emit ProposalExecuted(proposalID, prop.executed); // emituje event da li je proposal prihvacen ili ne
    }

}


