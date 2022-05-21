pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@maticnetwork/fx-portal/contracts/tunnel/FxBaseChildTunnel.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BootcampPlayer is FxBaseChildTunnel, ERC721{

  uint256 public latestStateId;
  address public latestRootMessageSender;
  bytes public latestData;

  constructor(address _fxChild) FxBaseChildTunnel(_fxChild)ERC721("MPL_L2", "MPL2"){}

  function _processMessageFromRoot(
    uint256 stateId,
    address sender,
    bytes memory data)
		internal override validateSender(sender) 
	{
   	 latestStateId = stateId;
   	 latestRootMessageSender = sender;
   	 latestData = data;
		 (uint[] memory tokenIds, address recipient) = abi.decode(data, (uint[], address));
		 _claimPlayers(tokenIds, recipient);
	}

	function _claimPlayers
		(uint[] memory tokenIds, address recipient)
		internal
	{
		for(uint i=0; i<tokenIds.length; i++){
			require(tokenIds[i] < 10000, "Invalid token id");
			_safeMint(recipient, tokenIds[i]);
		}
	}
}
