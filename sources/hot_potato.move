module 0x1::hot_potato {
    /// Let's say we have wallet resource storing some balance.
    struct Wallet has key, store {
        balance: u64,
    }

    /// Our HotPotato struct that can't be dropped, cloned, copied or stored.
    struct HotPotato {
    }

    /// Let's create some wallet on account.
    public fun create(account: &signer) {
        move_to(account, Wallet {
            balance: 100,
        });
    }

    /// Let's allow to loan from wallet.
    /// The function returns both loaned amount in Wallet and HotPotato.
    public fun loan_from_wallet(addr: address, amount: u64): (Wallet, HotPotato) acquires Wallet {
        let wallet = borrow_global_mut<Wallet>(addr);
        wallet.balance = wallet.balance - amount;

        let loan = Wallet {
            balance: amount
        };

        let hot_potato = HotPotato {};

        (loan, hot_potato)
    }

    /// Pay loan: pass both loan (Wallet) resource and hot potato resource.
    public fun pay_loan(addr: address, loan: Wallet, hot_potato: HotPotato) acquires Wallet {
        let wallet = borrow_global_mut<Wallet>(addr);
        wallet.balance = wallet.balance + loan.balance;
        assert!(wallet.balance  == 100, 0);

        // destruct
        let Wallet {balance: _} = loan;
        let HotPotato {} = hot_potato;
    }
}
