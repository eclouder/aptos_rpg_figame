module rpg_game::game_coin{
    use aptos_framework::fungible_asset::{Self, MintRef, BurnRef};
    use aptos_framework::object::{Self, Object, ExtendRef};
    use aptos_framework::primary_fungible_store;
    use std::option;
    use std::signer::address_of;
    use std::string::Self;
    friend rpg_game::main;
    const COIN_NAME:vector<u8> = b"BASE_COIN";
    const COIN_SYMBOL:vector<u8> = b"BASE_COIN_SYMBOL";
    const TEMP_COIN_URI:vector<u8> = b"";
    const TEMP_PROJECT_URI:vector<u8> = b"";
    
    struct CoinController has key{  
        coin_mint_ref:MintRef,
        coin_burn_ref:BurnRef
    }
    struct ObjectController has key {
        app_extend_ref:ExtendRef,
    }

    fun init_module(account:&signer){
        let constructor_ref = &object::create_named_object(account,GAME_COIN_SEED);
        let extend_ref = object::generate_extend_ref(constructor_ref);
        let app_signer = &object::generate_signer(constructor_ref);
        move_to(app_signer,ObjectController {
            app_extend_ref:extend_ref
        })
        primary_fungible_store::create_primary_store_enabled_fungible_asset(
        constructor_ref,
        option::none(),
        string::utf8(COIN_NAME),
        string::utf8(COIN_SYMBOL),
        2,
        string::utf8(TEMP_COIN_URI),
        string::utf8(TEMP_PROJECT_URI)
        );
        let fungible_asset_mint_ref = fungible_asset::generate_mint_ref(constructor_ref);
        let fungible_asset_burn_ref = fungible_asset::generate_burn_ref(constructor_ref);
        move_to(app_signer, CoinController {
            fungible_asset_mint_ref,
            fungible_asset_burn_ref,
        });
    }
    fun get_app_signer_address(): address {
        object::create_object_address(&@rpg_game, APP_OBJECT_SEED)
    }
    public(friend) fun mint_coin(user: &signer, amount: u64) acquires CoinController {
        let coin_controller = borrow_global<CoinController>(get_app_signer_address());
        let fungible_asset_mint_ref = &coin_controller.fungible_asset_mint_ref;
        primary_fungible_store::deposit(
            address_of(user),
            fungible_asset::mint(fungible_asset_mint_ref, amount),
        );
    }
    public(friend) fun burn_coin(user: &signer, amount: u64) acquires CoinController {
        let coin_controller = borrow_global<CoinController>(get_food_token_address());
        primary_fungible_store::burn(&coin_controller.fungible_asset_burn_ref, address_of(user), amount);
    }
    #[view]
    public(friend) fun get_coin_balance(owner_addr: address): u64 {
        let coin_controller = object::address_to_object<CoinController>(get_app_signer_address());
        primary_fungible_store::balance(owner_addr, coin_controller)
    }
    public(friend) fun transfer_coin(owner_addr:address,amount:u64,recipient:address){
        let coin_controller = object::address_to_object<CoinController>(get_app_signer_address());
        primary_fungible_store::transfer(owner_addr, coin_controller,recipient,amount);
    }
}