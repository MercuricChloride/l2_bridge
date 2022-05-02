pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@maticnetwork/fx-portal/contracts/tunnel/FxBaseRootTunnel.sol";

interface MPL {
	function ownerOf (uint tokenId) external returns(address);
    function getShuffledId(uint256 id) external view returns (uint256);
}

contract BootcampBridge is FxBaseRootTunnel {

	mapping(uint => bool) public isBridged;
	MPL mpl;

  constructor(address _checkpointManager, address _fxRoot, MPL _mpl)FxBaseRootTunnel(_checkpointManager, _fxRoot){
			mpl = _mpl;
	}

	function claimPlayers (uint[] memory tokenIds) public {
		for(uint i=0; i<tokenIds.length;i++) {
            require(mpl.ownerOf(tokenIds[i]) == msg.sender, 'Not owner of this token!');
            require(isBridged[tokenIds[i]] == false, 'Already bridged this token!');
            isBridged[tokenIds[i]] = true;
            tokenIds[i] = mpl.getShuffledId(tokenIds[i]);
        }
		_sendMessageToChild(abi.encode(tokenIds, msg.sender));
	}

	function _processMessageFromChild (bytes memory message) virtual internal override{}
}
