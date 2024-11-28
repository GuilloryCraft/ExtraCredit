
local mod = SMODS.current_mod
SMODS.Atlas({key = "ECjokers", path = "ECjokers.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()

-- Page 1 Jokers

SMODS.Joker{ --Forklift
    name = "Forklift",
    key = "forklift",
    config = {
        extra = {
            card_limit = 1
        }
    },
    loc_txt = {
        ['name'] = 'Forklift',
        ['text'] = {
            [1] = '{C:attention}+#1#{} Consumable Slots'
        }
    },
    pos = {
        x = 0,
        y = 0
     },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.card_limit}}
    end,

    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
            return true end }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.card_limit
            return true end }))
    end

}

SMODS.Joker{ --Double Rainbow
    name = "Double Rainbow",
    key = "doublerainbow",
    config = {
        extra = 1
    },
    loc_txt = {
        ['name'] = 'Double Rainbow',
        ['text'] = {
            [1] = '{C:attention}Retrigger{} played {C:attention}Lucky Cards{}'
        }
    },
    pos = {
        x = 1,
        y = 0
     },
    enhancement_gate = 'm_lucky',
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_lucky 
        return
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_lucky') then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card
            }
        end
    end

}

SMODS.Joker{ --Starfruit
    name = "Starfruit",
    key = "starfruit",
    config = {
        extra = {
            uses = 3
        }
    },
    loc_txt = {
        ['name'] = 'Starfruit',
        ['text'] = {
            [1] = '{C:attention}First played hand{} each',
            [2] = 'round gains {C:attention}1{} level',
            [3] = '{C:inactive}({}{C:attention}#1#{}{C:inactive} remaining)'
        }
    },
    pos = {
        x = 2,
        y = 0
     },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.uses}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and G.GAME.current_round.hands_played == 0 and context.before then 
            local text,disp_text = context.scoring_name
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex')})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
            level_up_hand(context.blueprint_card or card, text, nil, 1)
            if not context.blueprint then
                card.ability.extra.uses = card.ability.extra.uses - 1
                if card.ability.extra.uses <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(self)
                                        card:remove()
                                        card = nil
                                    return true; end})) 
                            return true
                        end
                    }))
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.MONEY
                    }
                end
            end
        end
    end
}

local function sum_levels()
    return ((G.GAME.hands['High Card'].level)+(G.GAME.hands['Pair'].level)+(G.GAME.hands['Two Pair'].level)+(G.GAME.hands['Three of a Kind'].level)+(G.GAME.hands['Straight'].level)+(G.GAME.hands['Flush'].level)+(G.GAME.hands['Full House'].level )+(G.GAME.hands['Four of a Kind'].level)+(G.GAME.hands['Straight Flush'].level)+(G.GAME.hands['Five of a Kind'].level)+(G.GAME.hands['Flush House'].level)+(G.GAME.hands['Flush Five'].level))
end

SMODS.Joker{ --Eclipse
    name = "Eclipse",
    key = "eclipse",
    config = {
        extra = {
            chip_mod = 10
        }
    },
    loc_txt = {
        ['name'] = 'Eclipse',
        ['text'] = {
            [1] = '{C:chips}+#2#{} Chips for every {C:attention}Hand Level',
            [2] = 'above {C:attention}level one',
            [3] = '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        }
    },
    pos = {
        x = 3,
        y = 0
     },
    cost = 9,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {((sum_levels()-12)*10), card.ability.extra.chip_mod}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and G.GAME.current_round.hands_played == 0 and context.before and not context.blueprint and G.GAME.hands[context.scoring_name].level > 1 then 
            

        elseif context.cardarea == G.jokers and (sum_levels() - 12) > 0 and context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={(sum_levels()-12)*10}},
                chip_mod = (sum_levels()-12)*10,
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker{ --Rubber Ducky
    name = "Rubber Ducky",
    key = "rubberducky",
    config = {
        extra = {
            chips = 0,
            suck = 2
        }
    },
    loc_txt = {
        ['name'] = 'Rubber Ducky',
        ['text'] = {
            [1] = 'Played cards {C:red}lose{} {C:chips}#2# Chips{} when scored',
            [2] = 'This joker gains lost chips',
            [3] = '{C:inactive}(Currently {C:chips}+#1# {}{C:inactive}Chips)'
        }
    },
    pos = {
        x = 4,
        y = 0
     },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.suck}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and not context.blueprint 
        and ((context.other_card.ability.perma_bonus or 0) + context.other_card.base.nominal) > 0 then

            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            context.other_card.ability.perma_bonus = math.max((context.other_card.ability.perma_bonus - card.ability.extra.suck), (context.other_card.base.nominal * -1))
            card.ability.extra.chips = card.ability.extra.chips + 2
            return {
                extra = {message = localize('k_eaten_ex'), colour = G.C.CHIPS},
                colour = G.C.CHIPS,
                card = card
            }

    

        elseif context.cardarea == G.jokers and context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            }

        end
    end
}



SMODS.Joker{ --Pocket Aces
    name = "Pocket Aces",
    key = "pocketaces",
    config = {
        extra = {
            money = 0,
            m_gain = 1
        }
    },
    loc_txt = {
        ['name'] = 'Pocket Aces',
        ['text'] = {
            [1] = 'Gives {C:money}$#1#{} at end of round',
            [2] = 'Played {C:attention}Aces{} increase payout',
            [3] = 'by {C:money}$#2#{} when scored',
            [4] = '{C:inactive}(Resets each{} {C:attention}Ante{}{C:inactive})'
        }
    },
    pos = {
        x = 5,
        y = 0
     },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money, card.ability.extra.m_gain}}
    end,

    calc_dollar_bonus = function(self, card)
        local thunk = card.ability.extra.money
        if G.GAME.blind.boss then
            card.ability.extra.money = 0
        end
        return thunk
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
            card.ability.extra.money = card.ability.extra.money + card.ability.extra.m_gain
        end
    end


}

local function contains(table_, value)
    for _, v in pairs(table_) do
        if v == value then
            return true
        end
    end

    return false
end

SMODS.Joker{ --Warlock             
    name = "Warlock",
    key = "warlock",
    config = {
        extra = {
            odds = 7,
            succeed = false,
        }
    },
    loc_txt = {
        ['name'] = 'Warlock',
        ['text'] = {
            [1] = 'Played {C:attention}Lucky Cards{} have a',
            [2] = '{C:green}#1# in #2#{} chance to be {C:attention}destroyed{} and',
            [3] = 'spawn a {C:spectral}Spectral Card{} when scored',
            [4] = '{C:inactive}(Must have room)'
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    enhancement_gate = "m_lucky",
    atlas = 'ECjokers',

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_lucky 
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.destructo}}
    end,

    calculate = function(self, card, context)

        if context.before and not context.blueprint then
            card.ability.extra.destructo = {}

        
        elseif context.cardarea == G.play and context.individual and SMODS.has_enhancement(context.other_card, "m_lucky") then
            if pseudorandom('witch') < G.GAME.probabilities.normal / card.ability.extra.odds then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'witch')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                context.other_card:juice_up(0.5, 0.5)
                            return true
                        end)}))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})

                    if not contains(card.ability.extra.destructo, context.other_card) then
                        card.ability.extra.destructo[#card.ability.extra.destructo + 1] = context.other_card
                    end
                end
            end

        elseif context.destroying_card and not context.blueprint then
            return contains(card.ability.extra.destructo, context.destroying_card)
        elseif context.after and not context.blueprint then
            card.ability.extra.destructo = nil
        end
    end
}

SMODS.Joker{ --Purple Joker
    name = "Purple Joker",
    key = "purplejoker",
    config = {
        extra = {
            mulchs = 0,
        }
    },
    loc_txt = {
        ['name'] = 'Purple Joker',
        ['text'] = {
            [1] = 'Gains {C:mult}Mult{} and {C:chips}Chips{} equal to',
            [2] = 'total {C:blue}Hands{} and {C:red}Discards{} left',
            [3] = 'after each round',
            [4] = '{C:inactive}(Currently {}{C:purple}+#1# {C:inactive}Mult and Chips)'
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mulchs}}
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if (G.GAME.current_round.hands_left + G.GAME.current_round.discards_left > 0) then
                card.ability.extra.mulchs = card.ability.extra.mulchs + G.GAME.current_round.hands_left + G.GAME.current_round.discards_left
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.PURPLE
                }
            end
        
        elseif context.cardarea == G.jokers and context.joker_main and context.scoring_hand then
            return{
                colour = G.C.PURPLE, --color doesn't work :(
                message = "+"..card.ability.extra.mulchs.." Mulchs!",
                mult_mod = card.ability.extra.mulchs,
                chip_mod = card.ability.extra.mulchs,
            }
        end
    end
}

SMODS.Joker{ --Compost
    name = "Compost",
    key = "compost",
    config = {
        extra = {
            mult = 0,
            mod = 1,
            fill = 0,
            do_once = true
        }
    },
    loc_txt = {
        ['name'] = 'Compost',
        ['text'] = {
            [1] = 'This joker gains {C:mult}+#2# {}Mult',
            [2] = 'every {C:attention}3{} cards {C:attention}discarded',
            [3] = 'Destroyed after {C:mult}+20 {}Mult',
            [4] = '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult and {C:attention}#3#{}{C:inactive}/3)'
        }
    },
    pos = {
        x = 8,
        y = 0
     },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mod, card.ability.extra.fill}}
    end,

    calculate = function(self, card, context)

        if context.discard and not context.blueprint and card.ability.extra.do_once then
            card.ability.extra.fill = card.ability.extra.fill + 1
            if card.ability.extra.fill == 3 then
                card.ability.extra.fill = 0
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mod 
                return {
                    delay = 0.2,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    colour = G.C.RED
                }
            end
            if card.ability.extra.mult >= 20 then
                card.ability.extra.do_once = false
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            end

        elseif context.cardarea == G.jokers and context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end
    end

}

SMODS.Joker{ --Candy Necklace
    name = "Candy Necklace",
    key = "candynecklace",
    config = {
        extra = {
            candies = 5,
            flavours = {
                [1] = 'tag_buffoon',
                [2] = 'tag_charm',
                [3] = 'tag_meteor',
                [4] = 'tag_standard',
                [5] = 'tag_ethereal'
            }
        }
    },
    loc_txt = {
        ['name'] = 'Candy Necklace',
        ['text'] = {
            [1] = 'Gain a random {C:attention}Booster Pack Tag{}',
            [2] = 'at the end of each round',
            [3] = '{C:inactive}({}{C:attention}#1#{}{C:inactive} remaining)'
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'tag_buffoon', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_charm', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_meteor', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_standard', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_ethereal', set = 'Tag'}
        return {vars = {card.ability.extra.candies, card.ability.extra.flavours}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then

            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag(pseudorandom_element(card.ability.extra.flavours, pseudoseed('candy'))))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))

            if not context.blueprint then
                card.ability.extra.candies = card.ability.extra.candies - 1
                if card.ability.extra.candies <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end})) 
                            return true
                        end
                    })) 
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.PURPLE
                    }
                end
            end
        end
    end
}



SMODS.Joker{ --Yellow Card
    name = "Yellow Card",
    key = "yellowcard",
    config = {
        extra = {
            money = 4
        }
    },
    loc_txt = {
        ['name'] = 'Yellow Card',
        ['text'] = {
            [1] = 'Gain {C:money}$#1#{} when any',
            [2] = '{C:attention}Booster Pack{} is skipped'
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,

    calculate = function(self, card, context)
        if context.skipping_booster and not context.open_booster then
            ease_dollars(card.ability.extra.money)
            card:juice_up(0.5, 0.5)
        end
    end
}

SMODS.Joker{ --Turtle
    name = "Turtle",
    key = "turtle",
    config = {
        extra = {
            Xmult_mod = 0.2,
            Xmult = 1
            }
        },
    loc_txt = {
        ['name'] = 'Turtle',
        ['text'] = {
            [1] = "This Joker gains {X:mult,C:white} X#1# {} Mult at the",
            [2] = "end of each {C:attention}Small Blind{} or {C:attention}Big Blind{}",
            [3] = "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
        }
    },
    pos = {
        x = 1,
        y = 1
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return{
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        elseif context.end_of_round and not context.repetition and not context.individual and not G.GAME.blind.boss and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            return {
                message = localize('k_upgrade_ex'),
                card = card,
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker{ --Clown College
    name = "Clown College",
    key = "clowncollege",
    config = {
        extra = {
            fools = 2
            }
        },
    loc_txt = {
        ['name'] = 'Clown College',
        ['text'] = {
            [1] = "Create {C:attention}#1# {C:tarot}The Fool{} cards",
            [2] = "after {C:attention}Boss Blind{} is defeated",
            [3] = "{C:inactive}(Must have room)",
        }
    },
    pos = {
        x = 4,
        y = 1
    },
    cost = 7,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'c_fool', set = 'Tarot'}
        return{vars = {card.ability.extra.fools}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss then
            for i=1, card.ability.extra.fools do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                G.E_MANAGER:add_event(Event({
                                    func = function() 
                                        local thunk = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool')
                                        card:add_to_deck()
                                        G.consumeables:emplace(thunk)
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end}))   
                                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                                return true
                            end)}))
                        end
                    end
                end
            end
}

SMODS.Joker{ --Handbook
    name = "Handbook",
    key = "handbook",
    config = {
        extra = {
            mult_mod = 1,
            mult = 0
            }
        },
    loc_txt = {
        ['name'] = 'Handbook',
        ['text'] = {
            [1] = "This Joker gains {C:mult}+#1# Mult{}",
            [2] = "if played {C:attention}poker hand{} has {C:attention}not{}",
            [3] = "already been played this round",
            [4] = "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)"
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_mod, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)

    if context.cardarea == G.jokers and context.joker_main then
        return {
            message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
            mult_mod = card.ability.extra.mult
        }

    elseif context.cardarea == G.jokers and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round == 1 and not context.blueprint and not context.after then 
            card.ability.extra.mult = card.ability.extra.mult +  card.ability.extra.mult_mod
            return{
                message = localize('k_upgrade_ex'),
                card = card,
                colour = G.C.SECONDARY_SET.Planet
            }               
        end
    end

}

SMODS.Joker{ --Ten Gallon
    name = "Ten Gallon",
    key = "tengallon",
    config = {
        extra = {
            Xmult = 0.2,
            dollars = 15
            }
        },
    loc_txt = {
        ['name'] = 'Ten Gallon',
        ['text'] = {
            [1] = "{X:mult,C:white}X#1#{} Mult for every",
            [2] = "{C:money}$#2#{} you have",
            [3] = "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.dollars, (1 + card.ability.extra.Xmult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.dollars))}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and (card.ability.extra.Xmult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.dollars)) > 0 then
            return{
                message = localize{type='variable',key='a_xmult',vars={1 + card.ability.extra.Xmult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.dollars)}},
                Xmult_mod = 1 + card.ability.extra.Xmult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.dollars)
            }
        end
    end
}

-- Page 2 Jokers

-- Page 3 Jokers 

SMODS.Joker{ --Lucky 7s
    name = "Lucky 7s",
    key = "lucky7s",
    loc_txt = {
        ['name'] = 'Lucky 7s',
        ['text'] = {
            [1] = "{C:attention}7s{} are considered",
            [2] = "{C:attention}Lucky Cards{}"
        }
    },
    pos = { --temp
        x = 2,
        y = 9
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    --atlas = 'ECjokers',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_lucky 
        return
    end,
    calculate = function(self, card, context)
        if context.check_enhancement and SMODS.Ranks[context.other_card.base.value].key == "7" then
            return {m_lucky = true}
        end
    end
}

SMODS.Joker{ --Alloy
    name = "Alloy",
    key = "alloy",
    loc_txt = {
        ['name'] = 'Alloy',
        ['text'] = {
            [1] = "{C:attention}Gold Cards{} are also considered",
            [2] = "{C:attention}Steel Cards{}, and vice versa"
        }
    },
    pos = { --temp
        x = 2,
        y = 9
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    --atlas = 'ECjokers',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        return
    end,
    calculate = function(self, card, context)
        if context.check_enhancement then
            if context.other_card.config.center.key == "m_gold" then
                return {m_steel = true}
            end
            if context.other_card.config.center.key == "m_steel" then
                return {m_gold = true}
            end
        end
    end
}