pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/// @title Simple wallet
contract Wallet {

    /// @dev Contract constructor.
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    /// @dev Allows to transfer tons to the destination account with commission payment.
    /// @param dest Transfer target address.
    /// @param value Nanotons value to transfer.
    /// @param bounce Flag that enables bounce message in case of target contract error.
    function sendAndPay(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 1);
    }

    /// @dev Allows to transfer tons to the destination account without commission payment.
    /// @param dest Transfer target address.
    /// @param value Nanotons value to transfer.
    /// @param bounce Flag that enables bounce message in case of target contract error.
    function sendWithoutPay(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 0);
    }

    /// @dev Send all tons and destroy the wallet.
    /// @param dest Transfer target address.
    /// @param bounce Flag that enables bounce message in case of target contract error.
    function sendAndDestroy(address dest, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(1, bounce, 160);
    }
}
