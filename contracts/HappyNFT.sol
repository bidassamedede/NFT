// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract HappyNFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    constructor(address initialOwner) ERC721("Happy", "MHP") Ownable(initialOwner) {}

    function uriMaker(string memory img) private pure returns (string memory) {
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(bytes(img))
            )
        );
    }

    function jsonMaker(uint256 tokenId, string memory img) private pure returns (string memory) {

        string memory uri = uriMaker(img);

        return string(
            abi.encodePacked(
                '{"name": "Happy',
                Strings.toString(tokenId),
                '", "description": "happy nft ", "image": "',
                uri,
                '", "attributes": [{"trait_type": "Style", "value": "Neon"}, {"trait_type": "Background", "value": "Black"}]}'
            )
        );
    }

    function tokenURI( uint256 tokenId) public pure override returns (string memory) {
        string
            memory img = "<svg width='200' height='200' xmlns='http://www.w3.org/2000/svg'><rect width='100' height='100' x='50' y='50' fill='red' /></svg>";

        string memory json = jsonMaker(
            tokenId, 
            img
        );

        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(bytes(json))
                )
            );
    }

    function mint(address _to) external onlyOwner {
        _nextTokenId++;
        _mint(_to, _nextTokenId);
    }
}