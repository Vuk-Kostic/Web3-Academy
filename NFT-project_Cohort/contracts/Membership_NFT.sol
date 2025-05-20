// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


// razlog importa ove ekstenzije je:
// da ne bih moramo manuelno da postavljam gettere i setere i ovom ekstenzijom omogucavam
// da se lakse storuju URIovi, tacnije da se automatski managuje metadata-u
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


// inicializaciaj contracta, postavljanje min cene, njegov id
// i provera da li je NFT mintovan
contract NFT is ERC721URIStorage {
    uint256 public mintPrice = 0.01 ether; // cena mintovanja
    uint256 public tokenID = 1; // id prvog mintovanog NFT-a

    mapping(address => bool) public isMinted; // flagovanje mintovanog NFT-a(ovime se postize da se moze kreirati samo 1 )


// inicijalizacija adresa

address public DAOad; //adresa DAO


// deployovanje contracta i mintovanje prvog NFT-a
constructor (address _DAOad, address _creator) ERC721("DAO Membership","DAOM"){


    // mintovanje prvog NFT-a DAO adresi
    DAOad = _DAOad; // storuje adresu za koriscenje u contractu
        _mint(_creator, tokenID);

    // postavljanje bool na true jer je mintovan NFT
    isMinted[_creator] = true;
        

    // inkrementacija countera
    tokenID++; 
 }

// funkcija za mintovanje
function mint(string memory _tokenURI) external payable {

    // uslovi za mintovanje
    require(isMinted[msg.sender] == false, "Already minted");

    require(msg.value >= mintPrice, "Insufficient founds");


    // mintovanje (ukoliku su ispunjeni uslovi)
    _mint(msg.sender, tokenID);

    // built in funkcija od ekstenzije koja omogucava postavljanje metadata-e
    _setTokenURI(tokenID,_tokenURI);


    // flagovanje nft-a za korisnika i autoinrekmentacija tokena
    isMinted[msg.sender] = true;
    tokenID++;
}

}
