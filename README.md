！项目正在完善中，
🔗 ON_CHAIN_MMORPG - Aptos 链上角色扮演游戏智能合约
欢迎来到 ON_CHAIN_MMORPG 的世界！本合约是构建于 Aptos 区块链 之上的去中心化链游基础协议，提供了完整的链上角色、装备、战斗与资产系统，是下一代 Web3 游戏基础设施的重要构件。

🚀 项目亮点
🎮 完全链上角色系统：每位玩家在链上拥有唯一的角色信息，包括攻击力（ATK）、生命值（Health）与绑定武器。

⚔️ 可装备 NFT 武器系统：武器为链上生成的 NFT，属性（攻击力、速度）由随机数模块随机生成，确保唯一性和稀缺性。

💰 链上 Game Coin 模块：使用自定义的 Game Coin 模拟游戏货币，实现押注、奖励分发与手续费销毁逻辑。

🎲 可验证的链上战斗逻辑：完全链上执行 PvP 战斗，对战逻辑使用链上随机数模块决定暴击等关键行为。

🔄 模块化可拓展设计：基于 Aptos 的 object 与 token 框架，支持未来引入坐骑、宠物、技能等扩展模块。

⚙️ 核心模块说明
🎮 玩家系统（Player）
每个玩家由一个 Player 资源表示，记录攻击力、生命值、装备武器与资产管理引用。

玩家由创建者 signer 初始化，通过 create_player_collection 和 create_weapon_entry 创建角色和武器。

🗡️ 武器系统（Weapon）
武器为独立 NFT，对应 WEAPON 结构，具有攻击与速度属性。

武器通过 create_weapon 函数生成，并存储于玩家账户中。

💰 Game Coin 系统
专用代币 Game Coin 由 CoinController 管理，支持铸造、销毁、转账等行为。

战斗消耗一定比例手续费（如 3%），剩余奖励归胜利方所有。

⚔️ 链上战斗系统
match_challenge 为 PvP 对战函数，输入两个玩家地址与下注金额。

使用链上随机函数生成暴击机制，实现公平、透明的链上战斗。

战斗胜负基于累计攻击值与速度值，胜者自动获得奖励。
🔐 安全与合规
使用 Aptos 官方 aptos_framework 和 aptos_token_objects 作为核心依赖。

随机数通过链上 randomness 模块安全生成。

所有重要操作（如战斗、铸币）均为 entry fun，确保可追溯与合约层级控制。

💡 项目愿景
本项目希望成为链游领域的标杆示例，打破“链游即炒作”的固有印象，真正将游戏体验与链上资产结合，推动 Web3 游戏向更公平、透明和可持续发展。

📬 联系我们
项目地址：https://github.com/eclouder/aptos_rpg_figame
合约语言：Move（基于 Aptos）
邮箱：
