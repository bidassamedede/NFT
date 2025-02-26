// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract MyNFT is ERC721 {
    uint256 public tokenCounter;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mintNFT(address recipient) public returns (uint256) {
        uint256 newItemId = tokenCounter;
        _mint(recipient, newItemId);
        tokenCounter++;
        return newItemId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        address owner = ERC721.ownerOf(tokenId);
        if (owner == address(0)) {
            revert("Token does not exist");
        }

        string memory name = string(abi.encodePacked("MyNFT #", Strings.toString(tokenId)));
        string memory description = "An on-chain SVG NFT.";

        string memory svg = generateSVG(tokenId);
        string memory imageURI = string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));

        string memory json = string(abi.encodePacked(
            '{"name": "', name, '", "description": "', description, '", "image": "', imageURI, '"}'
        ));

        string memory base64Json = Base64.encode(bytes(json));
        return string(abi.encodePacked("data:application/json;base64,", base64Json));
    }

    function generateSVG(uint256 tokenId) internal pure returns (string memory) {
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">',
            '<rect width="300" height="300" fill="', getColor(tokenId), '"/>',
            '<text x="50%" y="50%" text-anchor="middle" dominant-baseline="middle" font-size="20">',
            Strings.toString(tokenId),
            '</text>',
            '</svg>'
        ));
        return svg;
    }

    function getColor(uint256 tokenId) internal pure returns (string memory) {
        uint256 colorCode = tokenId % 6;
        if (colorCode == 0) return "red";
        if (colorCode == 1) return "green";
        if (colorCode == 2) return "blue";
        if (colorCode == 3) return "yellow";
        if (colorCode == 4) return "purple";
        return "orange";
    }
}

library Base64 {
    function encode(bytes memory data) internal pure returns (string memory) {
        bytes memory TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; //constant local variable
        if (data.length == 0) return "";

        uint256 encodedLength = 4 * ((data.length + 2) / 3);
        bytes memory result = new bytes(encodedLength);

        assembly {
            let dataPtr := add(data, 32)
            let endPtr := add(dataPtr, mload(data))
            let resultPtr := add(result, 32)

            for {

            } lt(dataPtr, endPtr) {

            } {
                let input := mload(dataPtr)
                dataPtr := add(dataPtr, 3)

                mstore8(resultPtr, mload(add(TABLE, and(shr(18, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(TABLE, and(shr(12, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(TABLE, and(shr(6, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(TABLE, and(input, 0x3F))))
                resultPtr := add(resultPtr, 1)
            }

            switch mod(mload(data), 3)
            case 1 {
                mstore8(sub(resultPtr, 2), 0x3D)
                mstore8(sub(resultPtr, 1), 0x3D)
            }
            case 2 {
                mstore8(sub(resultPtr, 1), 0x3D)
            }
        }

        return string(result);
    }
}