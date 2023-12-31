// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Sticky is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor(
        string memory _uri,
        string memory _name,
        string memory _symbol,
        address _target
    ) ERC721(_name, _symbol) {
        safeMint(_target, _uri);
    }

    /// @notice Mints an NFT to the targeted wallet address
    /// @dev Once minted and transferred, the token can't be transfered
    /// @param to Trget wallet address
    /// @param uri The `tokenURI` of the NFT metadata (should be "ipfs://<CID>")
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        require(
            from == address(0) || to == address(0),
            "Sticky NFT cannot be transfered"
        );
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721) {
        super._afterTokenTransfer(from, to, tokenId, batchSize);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /// @notice Replaces the tokenId of a given NFT
    /// @dev Marked `onlyOwner`: only the contract owner can access this function
    /// @param tokenId The id of the NFT
    /// @param uri The new `tokenURI` for this ID (should be "ipfs://<CID>")
    function setMetadata(uint256 tokenId, string memory uri) public onlyOwner {
        _setTokenURI(tokenId, uri);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) onlyOwner {
        super._burn(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
