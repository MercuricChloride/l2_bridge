pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract BootcampPlayer is ERC721 {

  // TODO IMPLIMENT THE ADDRESSES FOR BOTH OF THESE
  // @notice playerOracle
  //IPlayerOracle playerOracle;
  // @notice playerRenderer is the contract that handles the rendering of the tokens
  //IPlayerRenderer playerRenderer;

  constructor()ERC721("Player", "PLR"){}

  // could probably pack this entire struct to fill a single slot, but again it's probably not a real consideration given l2 and all
  struct Stats {
    uint256 id;
    uint8 passing;
    uint8 finishing;
    uint8 tackling;
    uint8 teamwork;
    uint8 creativity;
    uint8 pace;
    uint8 strength;
    uint8 kit;
    uint8 boots;
  }

  /*
  contract gas probably isn't a consideration because we are on an l2, but it would be cheaper to pack these as such by about 40k gas
  uint8 startingSkill1 = 22;
  uint8 startingSkill2 = 24;
  uint8 startingSkill3 = 27;
  uint8 startingSkill4 = 31;
  uint8 startingSkill5 = 37;
  uint8 startingSkill6 = 45;
  uint8 startingSkill7 = 55;
  */
  uint8[] startingSkillTotal = [22, 24, 27, 31, 37, 45, 55];

  mapping(uint256 => Stats) public playerStats;
  mapping(uint256 => uint256) public playerSkillTotal;

  function hasStats(uint256 tokenId) public returns(bool) {
    if(playerStats[tokenId].id > 0) return true;
    return false;
  }

  function claimPlayer(uint256 tokenId, Stats stats, bytes calldata signature) public {
    // TODO the keccak hash is probably the correct hash to use here, but I didn't double check that
    require(ECDSA.tryRecover(keccak256("Requesting Mint", signature)) == msg.sender, 'invalid signature');

    _mint(tokenId, msg.sender);

    uint256 skillTotal = playerSkillTotal[tokenId];
    if(skillTotal == 0) {
      startingInfo = playerOracle.getPlayerInfo(tokenId);
      skillTotal = startingSkillTotal[startingInfo[1]];

      if(startingInfo[0] == 1) skillTotal += 4; // martian bonus
      if(startingInfo[0] == 2) skillTotal += 8; // astronaut bonus
    }
    // TODO a bit confused about this, what values am I reading from and what should I check?
    // check that the stats are ok
    // e.g. maximum values
    // e.g. kit + boot selection is allowed based on skill level
    playerStats[tokenId] = stats;
  }

}
