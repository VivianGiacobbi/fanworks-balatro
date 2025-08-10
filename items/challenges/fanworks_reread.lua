local chalInfo = {
    rules = {
        custom = {
            {id = "fnwk_duplicates_allowed"},
            {id = "max_stands", value = 2}
        }
    },
    restrictions = {
        banned_cards = {
            allowed = {
                Joker = {
                    {id = 'j_hanging_chad'},
                    {id = 'j_hack'},
                    {id = 'j_dusk'},
                    {id = 'j_selzer'},
                    {id = 'j_sock_and_buskin'},
                    {id = 'j_fnwk_mania_fragile'},
                    {id = 'j_fnwk_rubicon_fishy'},
                    {id = 'j_fnwk_bluebolt_secluded'},
                },
                Stand = {
                    {id = 'c_jojobal_diamond_killer_btd'},
                    {id = 'c_jojobal_stone_white'},
                    {id = 'c_jojobal_stone_white_moon'},
                    {id = 'c_fnwk_iron_shatter'},
                    {id = 'c_fnwk_spirit_ultimate'},
                    {id = 'c_fnwk_streetlight_neon_favorite'},
                    {id = 'c_fnwk_love_super'},
                    {id = 'c_fnwk_redrising_invisible'}
                }
            }
        },
        banned_tags = {
            {id = 'tag_rare'}
        }
    }
}

return chalInfo