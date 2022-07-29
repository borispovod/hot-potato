module 0x1::thief {
    use 0x1::hot_potato;

    struct MyWallet has key {
        wallet: hot_potato::Wallet,
    }

    public entry fun try_to_steal(_my_account: &signer, addr: address) {
        let (loan, h_p) = hot_potato::loan_from_wallet(addr, 50);
        hot_potato::pay_loan(addr, loan, h_p);
    }
}