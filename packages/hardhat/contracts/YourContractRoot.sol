pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@maticnetwork/fx-portal/contracts/tunnel/FxBaseRootTunnel.sol";

interface MPL {
	function ownerOf(uint tokenId) external view returns(address);
}

contract BootcampBridge is FxBaseRootTunnel {

  MPL mpl;

  constructor(address _checkpointManager, address _fxRoot, MPL _mpl)FxBaseRootTunnel(_checkpointManager, _fxRoot){
	 mpl = _mpl;
  }

	function claimPlayers (uint[] memory tokenIds) public {
		for(uint i; i<tokenIds.length; i++){
			require(mpl.ownerOf(tokenIds[i]) == msg.sender, "Not owner of this token");
		}
		_sendMessageToChild(abi.encode(tokenIds, msg.sender));
	}

	function _processMessageFromChild (bytes memory message) virtual internal override{}
}
