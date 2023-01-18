module BlockSec::bsc{
    use aptos_framework::coin;
    use aptos_framework::event;
    use aptos_framework::account;
    use aptos_std::type_info;
    use std::string::{utf8, String};
    use std::signer;


    struct BSC{}
    
    struct CapStore has key{
        mint_cap: coin::MintCapability<BSC>,
        freeze_cap: coin::FreezeCapability<BSC>,
        burn_cap: coin::BurnCapability<BSC>
    }

    struct BSCEventStore has key{
        event_handle: event::EventHandle<String>,
    }

    fun init_module(account: &signer){
        let (burn_cap, freeze_cap, mint_cap) = coin::initialize<BSC>(account, utf8(b"BSC"), utf8(b"BSC"), 6, true);
        move_to(account, CapStore{mint_cap: mint_cap, freeze_cap: freeze_cap, burn_cap: burn_cap});
    }

    public entry fun register(account: &signer){
        let address_ = signer::address_of(account);
        if(!coin::is_account_registered<BSC>(address_)){
            coin::register<BSC>(account);
        };
        if(!exists<BSCEventStore>(address_)){
            move_to(account, BSCEventStore{event_handle: account::new_event_handle(account)});
        };
    }

    fun emit_event(account: address, msg: String) acquires BSCEventStore{
        event::emit_event<String>(&mut borrow_global_mut<BSCEventStore>(account).event_handle, msg);
    }

    public entry fun mint_coin(cap_owner: &signer, to_address: address, amount: u64) acquires CapStore, BSCEventStore{
        let mint_cap = &borrow_global<CapStore>(signer::address_of(cap_owner)).mint_cap;
        let mint_coin = coin::mint<BSC>(amount, mint_cap);
        coin::deposit<BSC>(to_address, mint_coin);
        emit_event(to_address, utf8(b"minted BSC"));
    }

    public entry fun burn_coin(account: &signer, amount: u64) acquires CapStore, BSCEventStore{
        let owner_address = type_info::account_address(&type_info::type_of<BSC>());
        let burn_cap = &borrow_global<CapStore>(owner_address).burn_cap;
        let burn_coin = coin::withdraw<BSC>(account, amount);
        coin::burn<BSC>(burn_coin, burn_cap);
        emit_event(signer::address_of(account), utf8(b"burned BSC"));
    }

    public entry fun freeze_self(account: &signer) acquires CapStore, BSCEventStore{
        let owner_address = type_info::account_address(&type_info::type_of<BSC>());
        let freeze_cap = &borrow_global<CapStore>(owner_address).freeze_cap;
        let freeze_address = signer::address_of(account);
        coin::freeze_coin_store<BSC>(freeze_address, freeze_cap);
        emit_event(freeze_address, utf8(b"freezed self"));
    }

    public entry fun emergency_freeze(cap_owner: &signer, freeze_address: address) acquires CapStore, BSCEventStore{
        let owner_address = signer::address_of(cap_owner);
        let freeze_cap = &borrow_global<CapStore>(owner_address).freeze_cap;
        coin::freeze_coin_store<BSC>(freeze_address, freeze_cap);
        emit_event(freeze_address, utf8(b"emergency freezed"));
    }

    public entry fun unfreeze(cap_owner: &signer, unfreeze_address: address)acquires CapStore, BSCEventStore{
        let owner_address = signer::address_of(cap_owner);
        let freeze_cap = &borrow_global<CapStore>(owner_address).freeze_cap;
        coin::unfreeze_coin_store<BSC>(unfreeze_address, freeze_cap);
        emit_event(unfreeze_address, utf8(b"unfreezed"));
    }
    
}