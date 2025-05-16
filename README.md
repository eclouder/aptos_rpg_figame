# 🛡️ ON_CHAIN_MMORPG - Aptos On-Chain Role-Playing Game Smart Contract

## Overview

**ON_CHAIN_MMORPG** is a fully on-chain multiplayer online role-playing game (MMORPG) built on the Aptos blockchain. The contract is designed with modularity, interactivity, and a real economic system at its core. It implements player registration, equipment crafting, battle matchmaking, and an in-game currency system — all executed and stored on-chain to ensure transparency and immutability.

---

## 🌟 Key Highlights

- ✅ **Fully On-Chain Execution**: Player states, equipment, and battle results are all stored on-chain, ensuring fairness and transparency.
- ⚔️ **Weapon Crafting System**: Weapons are minted with random attributes (attack and speed) using on-chain randomness, making each one unique.
- 🎮 **Battle Matchmaking Mechanism**: Fair combat logic with random critical hits ensures competitive and unpredictable outcomes.
- 🪙 **GameCoin Economic System**: A custom in-game token supports minting, burning, and transfers to simulate a closed-loop game economy.
- 🧾 **Event-Driven Logging**: Events for weapon minting and battles are emitted on-chain, enabling frontend integrations and auditability.
- 🔐 **Modular and Secure Resource Design**: Uses Aptos resource safety and object systems to protect user assets and enable extensibility.

---

## ⚙️ Core Functionalities

### 🔨 Player Creation & Weapon System
- Initialize a player collection using `create_player_collection`.
- Mint a weapon with randomized attack and speed using `create_weapon_entry`.
- Each mint emits a `MintWeaponEvent` for frontend listening and tracking.

### ⚔️ Battle Matchmaking
- Use `match_challenge` to initiate a battle challenge.
- The system determines the winner based on critical hit logic and attack speed comparison.
- The winner gains the staked `GameCoin`, while the loser loses part of their stake.

### 🪙 GameCoin Mechanics
- Create the in-game token using `create_coin`.
- Supports minting, burning, and peer-to-peer transfers.
- All battle activities are driven by `GameCoin`, simulating a real economic model.

---

## 📦 Dependencies

- `aptos_framework::event` – On-chain event emission system  
- `aptos_framework::randomness` – Source of randomness for weapon stats and critical hits  
- `aptos_token_objects::token` and `collection` – Implementation of NFT systems  
- `rpg_game::game_coin` – Custom module for GameCoin token management  

---

## 🌟 Project Advantages

- 🌐 **Native On-Chain Game Design**  
  All core logic runs entirely on-chain, ensuring trustworthy and tamper-proof game rules.

- 🛠️ **Modular and Extensible**  
  Designed for easy future expansion — including equipment systems, quest modules, and in-game markets.

- 💸 **Real Economic Model**  
  Built on Token and NFT standards to support asset circulation and in-game value exchange.

- 📈 **Scalability & Growth Potential**  
  Early supporters can participate in governance and share economic returns through incentive mechanisms.
