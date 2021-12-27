pragma solidity ^0.5.6;

import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IMix.sol";
import "./KDGC.sol";

contract KDGCMinter is Ownable {
    using SafeMath for uint256;

    KDGC public nft;
    uint256 public mintPrice = 80 * 1e18;
    address payable public feeTo;

    constructor(KDGC _nft, address payable _feeTo) public {
        nft = _nft;
        feeTo = _feeTo;
    }

    function setMintPrice(uint256 _price) external onlyOwner {
        mintPrice = _price;
    }

    function setFeeTo(address payable _feeTo) external onlyOwner {
        feeTo = _feeTo;
    }

    uint256 public limit;

    function setLimit(uint256 _limit) external onlyOwner {
        limit = _limit;
    }

    function mint(uint256 count) payable external {
        require(count <= limit);
        require(msg.value == mintPrice.mul(count));
        uint256 totalSupply = nft.totalSupply();
        nft.massMint(msg.sender, totalSupply + 1, totalSupply + count);
        feeTo.transfer(msg.value);
        limit = limit.sub(count);
    }
}
