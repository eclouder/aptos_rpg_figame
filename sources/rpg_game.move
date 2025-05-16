module rpg_game::main{
    use aptos_framework::event;
    use aptos_framework::object;
    use aptos_framework::timestamp;
    use aptos_framework::object::ExtendRef;
    use aptos_std::string_utils::{to_string};
    use aptos_token_objects::collection;
    use aptos_token_objects::token;
    use std::error;
    use std::option;
    use std::signer::address_of;
    use std::signer;
    use std::string::{Self, String,utf8};
    use aptos_framework::randomness;
    use rpg_game::game_coin;
    use std::fixed_point32::FixedPoint32;
    // ================================= DEFAULT GEME VALUE ========================== //
    const MIN_BET_VALUE:u64 = 40;
    // ================================= GLOBAL CONST NAME =========================== //
    const GAME_NAME:vector<u8> = b"ON_CHAIN_MMORPG";
    const WEAPON_COLLECTION_NAME:vector<u8> = b"weapon";
    const PLAYER_COLLECTION_DESCRIPTION:vector<u8> = b"player collection";
    const PLAYER_COLLECTION_NAME:vector<u8> = b"player";
    const GAME_COIN_SEED:vector<u8> = b"game coin";
    // ================================= Error Codes ================================= //
    const DEFAULT_HEALTH = 8192;
    ///
    const ENOT_PLAYER_L:u64 = 11;
    const ENOT_PLAYER_R:u64 = 12;
    const ENOT_PLAYER_L_BALANCE_INSUFFICIENT = 13;
    const ENOT_PLAYER_L_BALANCE_INSUFFICIENT = 14;
    const ENOT_LESS_THAN_BET_VALUE = 15;
    const ENOT_AVAILABLE: u64 = 1;
    /// Name length exceeded limit
    const ENAME_LIMIT: u64 = 2;
    /// User already has aptogotchi
    const EUSER_ALREADY_HAS_APTOGOTCHI: u64 = 3;
    /// Invalid body value
    const EBODY_VALUE_INVALID: u64 = 4;
    /// Invalid ear value
    const EEAR_VALUE_INVALID: u64 = 5;
    /// Invalid face value
    const EFACE_VALUE_INVALID: u64 = 6;
    // ================================ temp value =====================================//
    const TEMP_URI:vector<u8> = b"https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcSfOf8Xd98VJiT-HaQn2kZjq4ePN8QUM0C1D-0_FtYf9sMGWw-Jn9wnWbM6prZyfwf127hGhbhlgsFcqvgZTv3RipJOso05k_U8B8B969o";
    const TEMP_DESCRIPTION:vector<u8> = b"weapon_temp_desctiption";
    // ================================ random equipment value =========================//
    
    const WEAPON_ATK_MIN:u16 = 768;
    const WEAPON_ATK_MAX:u16 = 1024;
    const WEAPON_SPEED_MIN:u16 = 768;
    const WEAPON_SPEED_MAX:u16 = 1024; 
    struct CoinController has key{
        coin_mint_ref:MintRef,
        coin_burn_ref:BurnRef
    }
    fun create_coin(creator:&signer){
        let constructor_ref = &object::create_named_object(account,GAME_COIN_SEED);
        let coin 
    }
    struct CollectionCapability has key {
        extend_ref : ExtendRef
    }
    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct WEAPON has copy,drop,key,store{
        atk:u16,
        speed:u16,
        burn_ref: token::BurnRef,
        transfer_ref : TransferRef
    }
    #[event]
    struct MintWeaponEvent has drop,store{
        player_address:address,
        token_name:String,
        weapon:WEAPON
    }
    struct Player has key{
        atk:u16,
        health:u16,
        weapon:WEAPON,
        extend_ref: object::ExtendRef,
        mutator_ref: token::MutatorRef,
        burn_ref: token::BurnRef,
    }
    // struct MEquipment has copy{
        
    // }
    fun create_player_collection(creator:&signer){
        let description = utf8(PLAYER_COLLECTION_DESCRIPTION);
        let name = utf8(PLAYER_COLLECTION_NAME);
        let uri = utf8(TEMP_URI);
        collection::create_unlimited_collection(
            creator,
            description,
            name,
            option::none(),
            uri
        );
    }
    fun init_module(account:& signer){
        let constructor_ref = object::create_named_object(account,GAME_NAME);
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let app_signer = object::generate_signer(&constructor_ref);
        move_to(app_signer,CollectionCapability{
            extend_ref
        });
    }
    fun get_collection_address():address {
        object::create_object_address(&@aptogotchi_addr, GAME_NAME)
    }
    fun get_player_signer(player_address: address): signer acquires Player {
        object::generate_signer_for_extending(&borrow_global<Player>(aptogotchi_address).extend_ref)
    }       
    #[randomness]
    entry fun create_weapon_entry(user:&signer) acquires CollectionCapability{
        create_weapon(user);
    }
    fun create_weapon(user:&signer) :address acquires CollectionCapability{
        let atk = randomness::u16_range(WEAPON_ATK_MIN,WEAPON_ATK_MAX);
        let speed = randomness::u16_range(WEAPON_SPEED_MIN,WEAPON_SPEED_MAX);
        let uri = utf8(TEMP_URI);
        let description = utf8(TEMP_DESCRIPTION);
        let user_addr = signer::address_of(user);
        let token_name = to_string(&user_addr);
        let weapon = WEAPON{    
            atk,speed
        };
        let collection_addr = get_collection_address();
        let constructor_ref = &token::create(
            &get_player_signer(collection_addr),
            utf8(WEAPON_COLLECTION_NAME),
            description,    
            token_name,
            option::none(),
            uri
        );
        let token_signer_ref = &object::generate_signer(constructor_ref);
        let weapon_address = address_of(token_signer_ref);
        let extend_ref = object::generate_extend_ref(constructor_ref);
        let mutator_ref = token::generate_mutator_ref(constructor_ref);
        let burn_ref = token::generate_burn_ref(constructor_ref);
        let transfer_ref = object::generate_transfer_ref(constructor_ref);
        let player = Player{
            WEAPON:weapon,
            extend_ref,
            mutator_ref,
            burn_ref
        };
        move_to(token_signer_ref,player);
        event::emit<MintWeaponEvent>{
            MintWeaponEvent{
                player_address:address_of(token_signer_ref),
                token_name,
                weapon
            }
        }
        object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user));
        weapon_address
    }
    //将一个 u64 整数乘以0.03，并截断乘积的小数部分。如果乘积溢出，则执行中止。
    inline fun multiply_by_003_safe(value: u64): u64 {
        let intermediate = (value as u128) * 3;
        assert!(intermediate <= (u64::max_value() as u128), error::out_of_range());
        (intermediate as u64) / 10
    }
    // 线下赛等重要赛事上链，否则在服务器运行   
    #[randomness]
    entry fun match_challenge(player_address1:address,player_address2:address,
    bet_count:u64
    ) acquires Player,CollectionCapability{
        // 判断bet_count 是否大于最小值
        assert!(bet_count >= MIN_BET_VALUE,ENOT_LESS_THAN_BET_VALUE);

        let player1 = borrow_global<Player>(player_address1);
        let player2 = borrow_global<Player>(player_address2);
        // 判断双方入场金额
        assert!( game_coin::get_coin_balance(player1.coin) >= bet_count, ENOT_PLAYER_L_BALANCE_INSUFFICIENT);
        assert!( game_coin::get_coin_balance(player2.coin) >= bet_count, ENOT_PLAYER_L_BALANCE_INSUFFICIENT);
        let burn_coin_v = multiply_by_003_safe(bet_count);
        let winner_coin_v = bet_count - burn_coin_v;
        let player1_health = player1.health;
        let player2_health = player2.health;
        let player1_atk_health:u16 = 0;
        let player2_atk_health:u16 = 0;
        while ((player1_atk_health < player2_health) and(player2_atk_health < player1_health)){
            let critical_strike_player1 = randomness:u8_range(0,10);
            let critical_strike_player2 = randomness:u8_range(0,10);
            if (critical_strike_player1 = 0 ){
                player1_atk_health += 2 * player1.atk;
            }else{
                player1_atk_health += player1.atk;
            }
            if (critical_strike_player2 = 0){
                player2_atk_health += 2* player2.atk;
            }else{
                player2_atk_health += player2.atk;
            }
        }
        // 
        if (player1_atk_health >= player2_health) and (player2_atk_health >= player1_health){
             if (player1.speed > player2.speed){
                game_coin::transfer_coin(player_address2,winner_coin_v,player_address1);
             }else{
                game_coin::transfer_coin(player_address1,winner_coin_v,player_address2);
             }
        }
    }
}