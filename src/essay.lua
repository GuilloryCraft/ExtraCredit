local mod = SMODS.current_mod
SMODS.Atlas({key = "modicon", path = "modicon.png", px = 31, py = 32, atlas_table = "ASSET_ATLAS"}):register()
SMODS.Atlas({key = "ECjokers", path = "ECjokers.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()
SMODS.Atlas({key = "ECother", path = "ECother.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()

ECconfig = SMODS.current_mod.config
SMODS.current_mod.optional_features = { quantum_enhancements = true }

SMODS.current_mod.extra_tabs = function() --Credits tab
    local scale = 0.5
    return {
        label = "Interns",
        tab_definition_function = function()
        return {
            n = G.UIT.ROOT,
            config = {
            align = "cm",
            padding = 0.05,
            colour = G.C.CLEAR,
            },
            nodes = {
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Project Lead: CampfireCollective",
                    shadow = false,
                    scale = scale,
                    colour = G.C.PURPLE
                    }
                }
                }
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Artists: kittyknight, UselessReptile8, Wingcap, HonuKane,",
                    shadow = false,
                    scale = scale,
                    colour = G.C.MONEY
                    }
                },
                }
            },
            {
                n = G.UIT.R,
                config = {
                    padding = 0,
                    align = "cm"
                },
                nodes = {
                    {
                    n = G.UIT.T,
                    config = {
                        text = "bishopcorrigan, tuzzo, R3venantR3mnant, Neato, Sacto, Gote",
                        shadow = false,
                        scale = scale,
                        colour = G.C.MONEY
                    }
                    },
                }
                },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Programmers: CampfireCollective, Stupid, MathIsFun_",
                    shadow = false,
                    scale = scale,
                    colour = G.C.GREEN
                    }
                }
                },
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Special thanks: Drspectred, Djynasty, InertSteak, Akai, localthunk",
                    shadow = false,
                    scale = scale,
                    colour = G.C.BLUE
                    }
                }
                } 
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Concepting: CampfireCollective, kittyknight, Audrizzle, Neon, Expelsword, tuzzo, bishopcorrigan, Wingcap, AlasBabylon",
                    shadow = false,
                    scale = scale*0.6,
                    colour = G.C.BLACK
                    }
                }
                } 
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "HonuKane, conk reet, Sacto, BioSector, Splatter_Proto, SenrabMJam, Stupid, AviolosAvali, Xilande, Sbubby, Seadubbs, Swordodo, Qcom",
                    shadow = false,
                    scale = scale*0.6,
                    colour = G.C.BLACK
                    }
                }
                } 
            }
            }
        }
        end
    }
end

SMODS.current_mod.config_tab = function() --Config tab
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = {
        create_toggle({
            label = "Page 1 Jokers (restart required)",
            ref_table = ECconfig,
            ref_value = "wave1",
        }),
        create_toggle({
            label = "Page 2 Jokers (restart required)",
            ref_table = ECconfig,
            ref_value = "wave2",
        }),
        create_toggle({
            label = "Page 3 Jokers (restart required)",
            ref_table = ECconfig,
            ref_value = "wave3",
        }),
      },
    }
end

-- Talisman Compatibility

to_big = to_big or function(x)
  return x
end
to_number = to_number or function(x)
  return x
end

-------------------------


local function contains(table_, value)
    for _, v in pairs(table_) do
        if v == value then
            return true
        end
    end

    return false
end
local function eclipse_sum_levels()
    local total_hands = to_big(0)
    local total_levels = to_big(0)

    for hand, data in pairs(G.GAME.hands) do
        -- We should ignore hands which level is 0 or less for description consistency.
        if data.level >= to_big(1) then
            total_hands = total_hands + to_big(1)
            total_levels = total_levels + data.level
        end
    end
    return total_levels, total_hands
end
local ed = ease_dollars
function ease_dollars(mod, x)
    ed(mod, x)
    for i = 1, #G.jokers.cards do
	eval_card(G.jokers.cards[i], { EC_ease_dollars = to_big(mod)})
    end
end

-- Page 1 Jokers
if ECconfig.wave1 then
SMODS.Joker{ --Forklift
    name = "Forklift",
    key = "forklift",
    config = {
        extra = {
            card_limit = 2
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
    cost = 5,
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
            [1] = '{C:attention}Retrigger{} all {C:attention}Lucky Cards{}'
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
        if context.repetition and context.cardarea == G.play and SMODS.get_enhancements(context.other_card)["m_lucky"] == true then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card
            }
        
        elseif context.repetition and context.cardarea == G.hand and SMODS.get_enhancements(context.other_card)["m_lucky"] == true then
            if (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra,
                    card = card
                }
            end
        end
    end

}

SMODS.Joker{ --Starfruit
    name = "Starfruit",
    key = "starfruit",
    config = {
        extra = {
            uses = 5,
            odds = 2
        }
    },
    loc_txt = {
        ['name'] = 'Starfruit',
        ['text'] = {
            [1] = '{C:attention}First played hand{} each round',
            [2] = 'has a {C:green}#2# in #3#{} chance',
            [3] = 'to gain {C:attention}1{} level',
            [4] = '{C:inactive}({}{C:attention}#1#{}{C:inactive} rounds remaining)'
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
        return {vars = {card.ability.extra.uses, G.GAME.probabilities.normal, card.ability.extra.odds}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and G.GAME.current_round.hands_played == 0 and context.before then 
            
            if pseudorandom('star') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local text,disp_text = context.scoring_name
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex')})
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
                level_up_hand(context.blueprint_card or card, text, nil, 1)
            end
            
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

SMODS.Joker{ --Eclipse
    name = "Eclipse",
    key = "eclipse",
    config = {
        extra = {
            chip_mod = 12
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
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        local levels, hands = eclipse_sum_levels()
        return {vars = {((levels-hands)*card.ability.extra.chip_mod), card.ability.extra.chip_mod}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local levels, hands = eclipse_sum_levels()
            local chips = (levels - hands) * card.ability.extra.chip_mod
            if chips > to_big(0) then
                return {
                    message = localize{type='variable',key='a_chips',vars={chips}},
                    chip_mod = chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}

SMODS.Joker{ --Rubber Ducky
    name = "Rubber Ducky",
    key = "rubberducky",
    config = {
        extra = {
            chips = 0,
            suck = 3,
            min_bonus = 0
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
        if context.cardarea == G.play and context.individual and not context.blueprint then

            card.ability.extra.min_bonus = 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            if context.other_card.ability.name == 'Stone Card' then
                card.ability.extra.min_bonus = 50 * -1
            elseif context.other_card.ability.name == 'Bonus' then
                card.ability.extra.min_bonus = (30 + context.other_card.base.nominal) * -1
            else
                card.ability.extra.min_bonus = context.other_card.base.nominal * -1
            end
            
            if context.other_card.ability.perma_bonus > card.ability.extra.min_bonus then 
                local thunk = context.other_card.ability.perma_bonus
                context.other_card.ability.perma_bonus = math.max((context.other_card.ability.perma_bonus - card.ability.extra.suck), (card.ability.extra.min_bonus))
                thunk = thunk - context.other_card.ability.perma_bonus
                card.ability.extra.chips = card.ability.extra.chips + thunk
                return {
                    extra = {message = localize('k_eaten_ex'), colour = G.C.CHIPS},
                    colour = G.C.CHIPS,
                    card = card
                }
            end

    

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
            m_gain = 2
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
    cost = 7,
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
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 and not context.blueprint then
            card.ability.extra.money = card.ability.extra.money + card.ability.extra.m_gain
        end
    end


}

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

        
        elseif context.cardarea == G.play and context.individual and SMODS.get_enhancements(context.other_card)["m_lucky"] == true then
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
    cost = 4,
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
        
        elseif context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.mulchs > 1 then
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
            mod = 2,
            fill = 0,
            do_once = true
        }
    },
    loc_txt = {
        ['name'] = 'Compost',
        ['text'] = {
            [1] = 'This joker gains {C:mult}+#2# {}Mult',
            [2] = 'every {C:attention}3{} cards {C:attention}discarded',
            [3] = 'Destroyed after {C:mult}+30 {}Mult',
            [4] = '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult and {C:attention}#3#{}{C:inactive}/3)'
        }
    },
    pos = {
        x = 8,
        y = 0
    },
    cost = 5,
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
            if card.ability.extra.mult >= 30 then
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
            [2] = 'at the end of the {C:attention}shop',
            [3] = '{C:inactive}({}{C:attention}#1#{}{C:inactive} remaining)'
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
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
        if context.ending_shop then
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
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_eaten_ex'),
                            colour = G.C.PURPLE,
                        card = card
                    }) 
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
            money = 5
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
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "$"..tostring(card.ability.extra.money), colour = G.C.MONEY})
            ease_dollars(card.ability.extra.money)
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
    cost = 6,
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
        if context.cardarea == G.jokers and context.joker_main and card.ability.extra.Xmult > 1 then
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
            }
        },
    loc_txt = {
        ['name'] = 'Clown College',
        ['text'] = {
            [1] = "{C:attention}Fill{} consumeable slots with",
            [2] = "{C:tarot}The Fool{} cards after",
            [3] = "{C:attention}Boss Blind{} is defeated",
            [4] = "{C:inactive}(Must have room)",
        }
    },
    pos = {
        x = 4,
        y = 1
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'c_fool', set = 'Tarot'}
        return{vars = {}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss and not context.blueprint then
            for i=1, (G.consumeables.config.card_limit) do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                            card:juice_up(0.5, 0.5)
                            return true
                        end)}))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
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
            chip_mod = 5,
            chips = 0
            }
        },
    loc_txt = {
        ['name'] = 'Handbook',
        ['text'] = {
            [1] = "This Joker gains {C:blue}+#1#{} Chips if played",
            [2] = "{C:attention}poker hand{} has {C:attention}not{}",
            [3] = "already been played this round",
            [4] = "{C:inactive}(Currently {C:blue}+#2#{C:inactive} Chips)"
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)

    if context.cardarea == G.jokers and context.joker_main and card.ability.extra.chips > 0 then
        return {
            message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
            chip_mod = card.ability.extra.chips
        }

    elseif context.cardarea == G.jokers and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round == 1 and not context.blueprint and context.before then 
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return{
                message = localize('k_upgrade_ex'),
                card = card,
                colour = G.C.CHIPS
            }             
        end
    end

}

SMODS.Joker{ --Ten Gallon
    name = "Ten Gallon",
    key = "tengallon",
    config = {
        extra = {
            Xmult = 0.4,
            dollars = 25
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
        return {vars = {card.ability.extra.Xmult, card.ability.extra.dollars, to_big(1) + to_big(card.ability.extra.Xmult)*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or to_big(0)))/to_big(card.ability.extra.dollars))}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local xmult = (to_big(card.ability.extra.Xmult)*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or to_big(0)))/to_big(card.ability.extra.dollars)))
            if xmult > to_big(0) then
                return {
                    message = localize{type='variable',key='a_xmult',vars={to_big(1) + xmult}},
                    Xmult_mod = to_big(1) + xmult
                }
            end
        end
    end
}
end

-- Page 2 Jokers
if ECconfig.wave2 then
SMODS.Joker{ --Monte Haul
    name = "Monte Haul",
    key = "montehaul",
    config = {
        extra = {
            monty_rounds = 0,
            flavours = {'tag_foil','tag_holo','tag_polychrome','tag_negative','tag_uncommon','tag_rare'}
            }
        },
    loc_txt = {
        ['name'] = 'Monte Haul',
        ['text'] = {
            [1] = "After {C:attention}1{} round, sell this card",
            [2] = "to gain {C:attention}2{} random {C:attention}Joker Tags",
            [3] = "{C:inactive}(Currently {C:attention}#1#{C:inactive}/1)"

        }
    },
    pos = {
        x = 5,
        y = 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'tag_foil', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_holo', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_polychrome', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_negative', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_uncommon', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_rare', set = 'Tag'}
        return {vars = {card.ability.extra.monty_rounds}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.monty_rounds = card.ability.extra.monty_rounds + 1
            if card.ability.extra.monty_rounds >= 1 then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
                return {
                    message = localize('k_active_ex'),
                    colour = G.C.FILTER
                }
            end

        elseif context.selling_self and card.ability.extra.monty_rounds >= 1 then
            for i=1, 2 do
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag(pseudorandom_element(card.ability.extra.flavours, pseudoseed('monty'))))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end
    end
}

SMODS.Joker{ --Espresso
    name = "Espresseo",
    key = "espresso",
    config = {
        extra = {
            money = 30,
            m_loss = 5
        }
    },
    loc_txt = {
        ['name'] = 'Espresso',
        ['text'] = {
            [1] = 'Gain {C:money}$#1#{} and destroy this card',
            [2] = 'when any {C:attention}Blind{} is skipped',
            [3] = 'Reduces by {C:money}$#2#{} after each round'
        }
    },
    pos = {
        x = 6,
        y = 1
    },
    cost = 2,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money, card.ability.extra.m_loss}}
    end,

    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_drank_ex'),
                            colour = G.C.MONEY,
                        card = card
                    }) 
                    return true
                end}))
            ease_dollars(card.ability.extra.money)
            card:juice_up(0.5, 0.5)
            delay(0.5)
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

        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.money = card.ability.extra.money - card.ability.extra.m_loss
            if card.ability.extra.money <= 0 then
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
                    message = "Too cold!",
                    colour = G.C.FILTER
                }
            else 
                return {
                    message = "Cooled!",
                    colour = G.C.FILTER
                }
            end

        end
    end
}

SMODS.Joker{ --Traffic Light
    name = "Traffic Light",
    key = "trafficlight",
    config = {
        extra = {
            Xmult = 2.5,
            Xmult_mod = 1
        }
    },
    loc_txt = {
        ['name'] = 'Traffic Light',
        ['text'] = {
            [1] = 'Gives {X:mult,C:white}X#1#{} Mult',
            [2] = 'Decreases by {X:mult,C:white}X#2#{}',
            [3] = 'each hand played',
            [4] = 'Resets after {X:mult,C:white}X0.5{}'
        }
    },
    pos = {
        x = 7,
        y = 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return{
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }

        elseif context.after and not context.blueprint then

            card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.Xmult_mod

            if card.ability.extra.Xmult < 0.5 then
                card.ability.extra.Xmult = 2.5
                return {
                    message = "Go!",
                    colour = G.C.GREEN
                }
            elseif card.ability.extra.Xmult == 1.5 then
                return {
                    message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.Xmult_mod}},
                    colour = G.C.FILTER
                }
            elseif card.ability.extra.Xmult == 0.5 then
                return {
                    message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.Xmult_mod}},
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker{ --Hold Your Breath
    name = "Hold Your Breath",
    key = "holdyourbreath",
    config = {
        extra = {
            chips = 0,
            chip_mod = 30,
            chip_limit = 180
        }
    },
    loc_txt = {
        ['name'] = 'Hold Your Breath',
        ['text'] = {
            [1] = 'Gains {C:chips}+#2#{} Chips each {C:attention}hand played',
            [2] = 'Resets when a {C:red}discard{} is used',
            [3] = '{C:attention}Destroyed{} after {C:chips}+#3#{} Chips',
            [4] = '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        }
    },
    pos = {
        x = 8,
        y = 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.chip_limit}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and card.ability.extra.chips > 0 then
            return{
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips
            }

        elseif context.before and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return{
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }

        elseif context.after and not context.blueprint and card.ability.extra.chips > card.ability.extra.chip_limit then
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
                message = localize('k_extinct_ex'),
                colour = G.C.CHIPS
            }

        elseif context.discard and not context.blueprint and card.ability.extra.chips > 0 then
            card.ability.extra.chips = 0
            return{
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker{ --Ouppy Bog
    name = "Toby the Corgi",
    key = "corgi",
    config = {
        extra = {
            mult = 0,
            mult_mod = 4
        }
    },
    loc_txt = {
        ['name'] = 'Toby the Corgi',
        ['text'] = {
            [1] = '{C:attention}Destroys{} a random {C:attention}consumable',
            [2] = 'then gains {C:mult}+#2#{} Mult',
            [3] = 'when {C:attention}Blind{} is selected',
            [4] = '{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult)'
        }
    },
    pos = {
        x = 0,
        y = 2
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and card.ability.extra.mult > 1 then
            return{
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }

        elseif context.setting_blind and not card.getting_sliced and not context.blueprint and G.consumeables.cards[1] then
            
            local snack = pseudorandom_element(G.consumeables.cards, pseudoseed('toby'))
            if snack ~= nil then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        snack.T.r = -0.2
                        snack:juice_up(0.3, 0.4)
                        snack.states.drag.is = true
                        snack.children.center.pinch.x = true
                        snack:start_dissolve()
                        snack = nil
                        delay(0.3)
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},colour = G.C.MULT})
            end
        end
    end
}



SMODS.Joker{ --Werewolf
    name = "Werewolf",
    key = "werewolf",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Werewolf',
        ['text'] = {
            [1] = 'Played cards that are',
            [2] = '{C:attention}enhanced{} become {C:attention}Wild Cards'
        }
    },
    pos = {
        x = 1,
        y = 2
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {vars = {}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local thunk = 0
            for k, v in ipairs(context.full_hand) do
                if contains(SMODS.get_enhancements(v), true) and v.config.center.key ~= "m_wild" then
                    thunk = thunk + 1
                    v:set_ability(G.P_CENTERS.m_wild, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                end
            end
            if thunk > 0 then
                return{
                    message = 'Awooo!',
                    colour = G.C.PURPLE
                }
            end
        end
    end
}

SMODS.Joker{ --Permanent Marker
    name = "Permanent Marker",
    key = "permanentmarker",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Permanent Marker',
        ['text'] = {
            [1] = '{C:attention}Enhanced{} cards',
            [2] = 'can\'t be debuffed'
        }
    },
    pos = {
        x = 2,
        y = 2
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end
}

SMODS.Joker{ --Prideful Joker
    name = "Prideful Joker",
    key = "pridefuljoker",
    config = {
        extra = 18
    },
    loc_txt = {
        ['name'] = 'Prideful Joker',
        ['text'] = {
            [1] = 'Played {C:attention}Wild Cards{} give',
            [2] = '{C:mult}+#1#{} Mult when scored'
        }
    },
    pos = {
        x = 3,
        y = 2
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    enhancement_gate = 'm_wild',
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and SMODS.get_enhancements(context.other_card)["m_wild"] == true then
            return{
                mult = card.ability.extra,
                card = card
            }
        end
    end
}

SMODS.Joker{ --Tuxedo
    name = "Tuxedo",
    key = "tuxedo",
    config = {
        extra = {
            reps = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Tuxedo',
        ['text'] = {
            [1] = '{C:attention}Retrigger{} all cards',
            [2] = 'with {V:1}#1#{} suit',
            [3] = "{s:0.8}suit changes at end of round"
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        local current_suit = G.GAME.current_round.tuxedo_card and G.GAME.current_round.tuxedo_card.suit or "Spades"
        return {vars = {localize(current_suit, 'suits_singular'), colours = {G.C.SUITS[current_suit]}}}
    end,

    calculate = function(self, card, context)


        if context.cardarea == G.play and context.repetition and context.other_card:is_suit(G.GAME.current_round.tuxedo_card.suit) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.reps,
                card = card
            }

        elseif context.repetition and context.cardarea == G.hand and context.other_card:is_suit(G.GAME.current_round.tuxedo_card.suit) then
            if (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.reps,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker{ --Farmer
    name = "Farmer",
    key = "farmer",
    config = {
        extra = {
            dollars = 2
        }
    },
    loc_txt = {
        ['name'] = 'Farmer',
        ['text'] = {
            [1] = 'Cards with {V:1}#2#{} suit',
            [2] = 'held in hand give {C:money}$#1#',
            [3] = 'at end of round',
            [4] = "{s:0.8}suit changes at end of round"
        }
    },
    pos = {
        x = 9,
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
        local current_suit = G.GAME.current_round.farmer_card and G.GAME.current_round.farmer_card.suit or "Spades"
        return {vars = {card.ability.extra.dollars, localize(current_suit, 'suits_singular'), colours = {G.C.SUITS[current_suit]}}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.end_of_round and context.individual and not context.repetition and context.other_card:is_suit(G.GAME.current_round.farmer_card.suit) then
            delay(0.15)
            return {
                dollars = 2,
                card = context.other_card
            }
        end        
    end
}



SMODS.Joker{ --Ambrosia
    name = "Ambrosia",
    key = "ambrosia",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Ambrosia',
        ['text'] = {
            [1] = '{C:attention}Fill{} consumable slots with',
            [2] = '{C:spectral}Spectral Cards{} whenever a',
            [3] = '{C:attention}blind{} is {C:attention}skipped{}, destroyed',
            [4] = 'when any {C:spectral}Spectral Card{} is {C:attention}sold',
            [5] = '{C:inactive}(Must have room)'
        }
    },
    pos = {
        x = 5,
        y = 2
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,

    calculate = function(self, card, context)
        if context.skip_blind then
            for i=1, (G.consumeables.config.card_limit) do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'ambro')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                            card:juice_up(0.5, 0.5)
                            return true
                        end)}))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                end
            end
            
        elseif context.selling_card then
            if context.card.ability.set == 'Spectral' then
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
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_drank_ex'), colour = G.C.SECONDARY_SET.Spectral})
            end                
        end
    end
}

SMODS.Joker{ --Clown Car
    name = "Clown Car",
    key = "clowncar",
    config = {
        extra = {
            mult = 44,
            money = 3
        }
    },
    loc_txt = {
        ['name'] = 'Clown Car',
        ['text'] = {
            [1] = '{C:mult}+#1#{} Mult and {C:money}-$#2#',
            [2] = '{C:attention}before{} cards are scored'
        }
    },
    pos = {
        x = 6,
        y = 2
    },
    cost = 7,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.money}}
    end,

    calculate = function(self, card, context)
        if context.before_but_not_as_much then
            ease_dollars(-card.ability.extra.money)
            card_eval_status_text(card, 'jokers', nil, percent, nil, {message = "-$"..tostring(card.ability.extra.money), colour = G.C.MONEY})
            --Manually give +44 Mult
            mult = mod_mult(mult + card.ability.extra.mult)
            update_hand_text({delay = 0}, {mult = mult})
            card_eval_status_text(card, 'jokers', nil, percent, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}, mult_mod = card.ability.extra.mult})
        end
    end
}

SMODS.Joker{ --Ship of Theseus
    name = "Ship of Theseus",
    key = "shipoftheseus",
    config = {
        extra = {
            Xmult = 1,
            Xmult_mod = 0.4,
            tick = false
        }
    },
    loc_txt = {
        ['name'] = 'Ship of Theseus',
        ['text'] = {
            [1] = 'Whenever a {C:attention}Playing Card{} is {C:attention}destroyed',
            [2] = 'add a {C:attention}copy{} of it to your {C:attention}deck',
            [3] = 'and this joker gains {X:mult,C:white}X#2#{} Mult',
            [4] = '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)'
        }
    },
    pos = {
        x = 7,
        y = 2
    },
    cost = 9,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod}}
    end,

    calculate = function(self, card, context)
        if context.cards_destroyed then
            card.ability.extra.tick = false
            for k, val in ipairs(context.glass_shattered) do
                if not context.blueprint then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                    card.ability.extra.tick = true
                end
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(val, nil, nil, G.playing_card)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    G.deck:emplace(_card)
                    table.insert(G.playing_cards, _card)
                    playing_card_joker_effects({true})
                
                G.E_MANAGER:add_event(Event({
                func = function() 
                    _card:start_materialize()
                    
                    return true
                end}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.FILTER})
            end
                

            
            if not context.blueprint and card.ability.extra.tick then
                delay(0.3)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}}, colour = G.C.FILTER})
            end


        elseif context.remove_playing_cards then
            card.ability.extra.tick = false
            for k, val in ipairs(context.removed) do
                if not context.blueprint then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                    card.ability.extra.tick = true
                end                
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(val, nil, nil, G.playing_card)
                    card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    G.deck:emplace(_card)
                    table.insert(G.playing_cards, _card)
                    playing_card_joker_effects({true})
                
                G.E_MANAGER:add_event(Event({
                func = function() 
                    _card:start_materialize()
                    
                    return true
                end}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.FILTER})
            end
                

            
            if not context.blueprint and card.ability.extra.tick then
                delay(0.3)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}}, colour = G.C.FILTER})
            end

        elseif context.cardarea == G.jokers and context.joker_main and card.ability.extra.Xmult > 1 then
            return{
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker{ --Accretion Disk
    name = "Accretion Disk",
    key = "accretiondisk",
    config = {
        extra = {
            used = 0,
            needs = 3
        }
    },
    loc_txt = {
        ['name'] = 'Accretion Disk',
        ['text'] = {
            [1] = 'Your {C:attention}most played hand',
            [2] = 'gains one level',
            [3] = 'every {C:attention}#2#{} {C:planet}planets{} used',
            [4] = '{C:inactive}(Currently {C:attention}#1#{C:inactive}/#2#)'
        }
    },
    pos = {
        x = 8,
        y = 2
    },
    cost = 7,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.used, card.ability.extra.needs}}
    end,

    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable.ability.set == 'Planet' then
                if not context.blueprint then
                    card.ability.extra.used = card.ability.extra.used + 1
                end
                if card.ability.extra.used >= 3 then
                    if not context.blueprint then
                        card.ability.extra.used = 0
                    end
                    local _hand, _tally = nil, 0
                    for k, v in ipairs(G.handlist) do
                        if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                            _hand = v
                            _tally = G.GAME.hands[v].played
                        end
                    end
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex')})
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
                    level_up_hand(context.blueprint_card or card, _hand, nil, 1)
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                end
            end
        end
    end
}

SMODS.Joker{ --Go Fish
    name = "Go Fish",
    key = "gofish",
    config = {
        extra = {
            fished = false
        }
    },
    loc_txt = {
        ['name'] = 'Go Fish',
        ['text'] = {
            [1] = 'The {C:attention}first time{} that a',
            [2] = '{C:attention}played hand{} contains any',
            [3] = 'scoring {C:attention}#1#s{}, destroy them',
            [4] = '{s:0.8}rank changes at end of round'
        }
    },
    pos = {
        x = 9,
        y = 2
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        local current_rank = G.GAME.current_round.fish_rank and G.GAME.current_round.fish_rank.rank or "Ace"
        return {vars = {current_rank}}
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            card.ability.extra.fished = false
            local eval = function() return not card.ability.extra.fished end
            juice_card_until(card, eval, true)

        elseif context.before and not context.blueprint then
            card.ability.extra.fish = {}
            if not card.ability.extra.fished then
                for i=1, #context.scoring_hand do
                    if context.scoring_hand[i].base.value == G.GAME.current_round.fish_rank.rank and not context.scoring_hand[i].debuff then
                        card.ability.extra.fish[#card.ability.extra.fish + 1] = context.scoring_hand[i]
                        card.ability.extra.fished = true
                    end
                end
            end

        elseif context.destroying_card and not context.blueprint then
            return contains(card.ability.extra.fish, context.destroying_card)        

        elseif context.after and not context.blueprint then
            card.ability.extra.fish = nil

        elseif context.end_of_round then
            card.ability.extra.fished = true
        end
    end
}
end

-- Page 3 Jokers
if ECconfig.wave3 then
SMODS.Joker{ --Plushie
    name = "Plushie",
    key = "plushie",
    config = {
        extra = {
            chips = 16
        }
    },
    loc_txt = {
        ['name'] = 'Plushie',
        ['text'] = {
            [1] = "{C:chips}+#1#{} Chips for",
            [2] = "each {C:attention}Joker{} card",
            [3] = "{C:inactive}(Currently {C:blue}+#2#{C:inactive} Chips)",
        }
    },
    pos = {
        x = 6,
        y = 3
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, (G.jokers and G.jokers.cards and #G.jokers.cards or 0)*card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return{
                message = localize{type='variable',key='a_chips',vars={(G.jokers and G.jokers.cards and #G.jokers.cards or 0)*card.ability.extra.chips}},
                chip_mod = (G.jokers and G.jokers.cards and #G.jokers.cards or 0)*card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker{ --Pyromancer
    name = "Pyromancer",
    key = "pyromancer",
    config = {
        extra = {
            mult = 20
        }
    },
    loc_txt = {
        ['name'] = 'Pyromancer',
        ['text'] = {
            [1] = "{C:mult}+#1#{} Mult if",
            [2] = "remaining {C:attention}Hands{} are less",
            [3] = "than or equal to {C:attention}Discards",
        }
    },
    pos = {
        x = 1,
        y = 3
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and G.GAME.current_round.hands_left <= G.GAME.current_round.discards_left then
            return{
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker{ --Bobby
    name = "Bobby",
    key = "bobby",
    config = {
        extra = {
            hands = 2,
            discards = 4
        }
    },
    loc_txt = {
        ['name'] = 'Bobby',
        ['text'] = {
            [1] = "When {C:attention}Blind{} is selected,",
            [2] = "lose {C:attention}#1#{} Hands and gain",
            [3] = "{C:red}+#1#{} Discards for each Hand lost"
            
        }
    },
    pos = {
        x = 0,
        y = 3
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hands, card.ability.extra.discards}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced then

            G.E_MANAGER:add_event(Event({func = function()

                if G.GAME.current_round.hands_left < 2 then

                elseif G.GAME.current_round.hands_left == 2 then
                    
                    ease_hands_played(-(card.ability.extra.hands / 2), true)
                    ease_discard((card.ability.extra.discards / 2), true, true)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(card.ability.extra.discards / 2).." "..localize('k_hud_discards'), colour = G.C.RED})
    
                elseif G.GAME.current_round.hands_left > 2 then

                    ease_hands_played(-card.ability.extra.hands, true)
                    ease_discard(card.ability.extra.discards, true, true)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(card.ability.extra.discards).." "..localize('k_hud_discards'), colour = G.C.RED})
                end
            return true end })) 

        end
    end
    
}

SMODS.Joker{ --Yin Yang
    name = "Yin-Yang",
    key = "yinyang",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Yin-Yang',
        ['text'] = {
            [1] = "Create a {C:purple}Tarot{} and {C:planet}Planet",
            [2] = "card at end of round if",
            [3] = "remaining {C:attention}Hands{} are {C:attention}equal",
            [4] = "to remaining {C:attention}Discards"
        }
    },
    pos = {
        x = 4,
        y = 3
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            if G.GAME.current_round.hands_left == G.GAME.current_round.discards_left then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.E_MANAGER:add_event(Event({
                                func = function() 
                                    local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'yin')
                                    card:add_to_deck()
                                    G.consumeables:emplace(card)
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end}))   
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                            return true
                        end)}))
                end
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.E_MANAGER:add_event(Event({
                                func = function() 
                                    local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, 'yang')
                                    card:add_to_deck()
                                    G.consumeables:emplace(card)
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end}))   
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})                       
                            return true
                        end)}))
                end
            end
        end
    end
}

SMODS.Joker{ --Blackjack
    name = "Blackjack",
    key = "blackjack",
    config = {
        extra = {
            mult = 21
        }
    },
    loc_txt = {
        ['name'] = 'Blackjack',
        ['text'] = {
            [1] = "{C:mult}+#1#{} Mult if played hand",
            [2] = "contains a scoring {C:attention}face ",
            [3] = "{C:attention}card{} and nonscoring {C:attention}Ace{}",
        }
    },
    pos = {
        x = 1,
        y = 4
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local _ace, _face = false, false
            for i = 1, #context.scoring_hand do
                if not SMODS.has_no_rank(context.scoring_hand[i]) then
                    if context.scoring_hand[i]:is_face() then
                        _face = true break
                    end
                end
            end

            for i = 1, #context.full_hand do
                if context.full_hand[i]:get_id() == 14 and not SMODS.has_no_rank(context.full_hand[i]) then
                    if not contains(context.scoring_hand, context.full_hand[i]) then
                        _ace = true
                    end
                end
            end

            if _ace and _face then
                return{
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult
                }
            end
        end
    end
}



SMODS.Joker{ --JotY
    name = "Joker of the Year",
    key = "joty",
    config = {
        extra = {
            reps = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Joker of the Year',
        ['text'] = {
            [1] = 'If played hand has',
            [2] = '{C:attention}5{} scoring cards,',
            [3] = "{C:attention}retrigger{} played cards"
        }
    },
    pos = {
        x = 5,
        y = 3
    },
    cost = 9,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and #context.scoring_hand == 5 then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.reps,
                card = card
            }
        end
    end
}

SMODS.Joker{ --Average Alice
    name = "Average Alice",
    key = "averagealice",
    config = {
        extra = {
            Xmult = 2.5
        }
    },
    loc_txt = {
        ['name'] = 'Average Alice',
        ['text'] = {
            [1] = "{C:white,X:mult}X#1#{} Mult if played",
            [2] = "hand contains a scoring",
            [3] = "{C:attention}Odd{} and {C:attention}Even{} card",
        }
    },
    pos = {
        x = 2,
        y = 4
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local _odd, _even = false, false
            for i = 1, #context.scoring_hand do
                if not SMODS.has_no_rank(context.scoring_hand[i]) then
                    if contains({14,3,5,7,9}, context.scoring_hand[i]:get_id()) then
                        _odd = true
                    end
                    if contains({2,4,6,8,10}, context.scoring_hand[i]:get_id()) then
                        _even = true
                    end
                end
            end

            if _odd and _even then
                return{
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

SMODS.Joker{ --Coupon Sheet
    name = "Coupon Sheet",
    key = "couponsheet",
    config = {
        extra = {
            }
        },
    loc_txt = {
        ['name'] = 'Coupon Sheet',
        ['text'] = {
            [1] = "Create a {C:attention}Coupon Tag",
            [2] = "and a {C:attention}Voucher Tag",
            [3] = "after {C:attention}Boss Blind{} is defeated"
        }
    },
    pos = {
        x = 8,
        y = 3
    },
    cost = 7,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'tag_coupon', set = 'Tag'}
        info_queue[#info_queue+1] = {key = 'tag_voucher', set = 'Tag'}
        return{vars = {}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss and not context.blueprint then
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+1 Coupon Tag!", colour = G.C.FILTER})
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_coupon'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
            delay(0.3)
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+1 Voucher Tag!", colour = G.C.FILTER})
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_voucher'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end
}

SMODS.Joker{ --Hoarder
    name = "Hoarder",
    key = "hoarder",
    config = {
        extra = 1
    },
    loc_txt = {
        ['name'] = 'Hoarder',
        ['text'] = {
            [1] = "This Joker gains {C:money}$#1#{} of sell value",
            [2] = "whenever {C:money}money{} is earned"
        }
    },
    pos = {
        x = 9,
        y = 3
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.EC_ease_dollars and not context.blueprint then
            if context.EC_ease_dollars > to_big(0) then
                card.ability.extra_value = card.ability.extra_value + card.ability.extra
                card:set_cost()
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_val_up'),
                        colour = G.C.MONEY,
                    card = card
                }) 
            end
            
        end
    end
}

SMODS.Joker{ --Chain Lightning
    name = "Chain Lightning",
    key = "chainlightning",
    config = {
        extra = {
            Xmult = 1,
            Xmult_mod = 0.1,
            total = 0,
            so_far = 0
        }
    },
    loc_txt = {
        ['name'] = 'Chain Lightning',
        ['text'] = {
            [1] = 'Played {C:attention}Mult Cards{} give',
            [2] = '{X:mult,C:white}X#1#{} Mult when scored,',
            [3] = 'then increase this by {X:mult,C:white}X#2#',
            [4] = '{C:inactive}(Resets each hand)'
        }
    },
    pos = {
        x = 2,
        y = 3
    },
    cost = 9,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    enhancement_gate = 'm_mult',
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod}}
    end,

    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.Xmult = 1
            card.ability.extra.total = card.ability.extra.total + 1
            card.ability.extra.so_far = 0
        elseif context.cardarea == G.play and context.individual and context.other_card.config.center.key == "m_mult" then
            local thunk = card.ability.extra.Xmult
            card.ability.extra.so_far = card.ability.extra.so_far + 1

            if card.ability.extra.so_far == card.ability.extra.total then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                card.ability.extra.so_far = 0
            end

            if thunk > 1 then
                return{
                    x_mult = thunk,
                    card = card
                }
            end

        elseif context.after then 
            card.ability.extra.total = 0
            card.ability.extra.Xmult = 1
        end
    end
}



SMODS.Joker{ --Joka Lisa
    name = "Joka Lisa",
    key = "jokalisa",
    config = {
        extra = {
            Xmult = 1,
            Xmult_mod = 0.1
        }
    },
    loc_txt = {
        ['name'] = 'Joka Lisa',
        ['text'] = {
            [1] = 'Gains {X:mult,C:white}X#2#{} Mult for',
            [2] = 'each {C:attention}unique enhancement',
            [3] = 'in scoring hand',
            [4] = '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})'
        }
    },
    pos = {
        x = 3,
        y = 3
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local enhanced = {}
            for i=1, #context.scoring_hand do
                for k, v in pairs(SMODS.get_enhancements(context.scoring_hand[i])) do
                    if v then
                        if not contains(enhanced, k) then
                            enhanced[#enhanced+1] = k
                        end
                    end
                end
            end
            if #enhanced > 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + (card.ability.extra.Xmult_mod*#enhanced)
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    card = card,
                    colour = G.C.RED
                }
            end

        elseif context.cardarea == G.jokers and context.joker_main and card.ability.extra.Xmult > 1 then
            return{
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker{ --Bad Apple
    name = "Bad Apple",
    key = "badapple",
    config = {
        extra = {
            chips = 125,
            odds = 4
        }
    },
    loc_txt = {
        ['name'] = 'Bad Apple',
        ['text'] = {
            [1] = "{C:chips}+#1#{} Chips",
            [2] = "{C:green}#3# in #2#{} chance this card ",
            [3] = "or an {C:attention}adjacent{} card is",
            [4] = "destroyed at end of round"
        }
    },
    pos = {
        x = 0,
        y = 4
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.odds, G.GAME.probabilities.normal}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return{
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips
            }

        elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            if pseudorandom('apple') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local destructable_jokers = {}
                local index = 0
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        index = i break
                    end
                end
                for i = 1, #G.jokers.cards do
                    if i == index - 1 or i == index or i == index + 1 then
                        if not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
                    end
                end
                local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('apple')) or nil

                if joker_to_destroy then 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_extinct_ex'),
                            colour = G.C.FILTER,
                        card = joker_to_destroy
                    }) 
                    joker_to_destroy.getting_sliced = true
                    G.E_MANAGER:add_event(Event({func = function()
                        card:juice_up(0.8, 0.8)
                        joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                    return true end }))
                end
            
            else
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_safe_ex'),
                        colour = G.C.FILTER,
                    card = card
                }) 
            end
        end
    end
}

SMODS.Joker{ --Passport
    name = "Passport",
    key = "passport",
    config = {
        extra = {
            stamps = 1
            }
        },
    loc_txt = {
        ['name'] = 'Passport',
        ['text'] = {
            [1] = "Once each {C:attention}ante{}, if {C:attention}final",
            [2] = "{C:attention}discard{} of round has only {C:attention}1",
            [3] = "card, it gains a random {C:attention}Seal",
            [4] = "{C:inactive}(Currently {C:attention}#1#{C:inactive} remaining)"
        }
    },
    pos = {
        x = 3,
        y = 4
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',

    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.stamps}}
    end,

    calculate = function(self, card, context)
        if card.ability.extra.stamps > 0 and context.discard and G.GAME.current_round.discards_left == 2 and not context.blueprint then
            local eval =  function() return G.GAME.current_round.discards_left > 0 and card.ability.extra.stamps > 0 end
            juice_card_until(card, eval, true)
        end

        if card.ability.extra.stamps > 0 and context.discard and G.GAME.current_round.discards_left == 1 and not context.blueprint and #context.full_hand == 1 then
            local seal_type = SMODS.poll_seal({guaranteed = true})
            context.other_card:set_seal(seal_type, true)
            context.other_card:juice_up(0.5,0.5)
            card.ability.extra.stamps = 0
            return {
                message = "Sealed!",
                card = card,
                colour = G.C.FILTER
            }

        elseif context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss and not context.blueprint then
            card.ability.extra.stamps = 1
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.FILTER})
        end
    end
}

SMODS.Joker{ --Lucky 7
    name = "Lucky 7",
    key = "lucky7",
    config = {
        extra = {
            lucky = false,
            checked = false
            }
        },
    loc_txt = {
        ['name'] = 'Lucky 7',
        ['text'] = {
            [1] = "If played hand contains",
            [2] = "a scoring {C:attention}7{}, all played",
            [3] = "cards count as {C:attention}Lucky Cards"
        }
    },
    pos = { 
        x = 7,
        y = 3
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_lucky 
        return
    end,
    calculate = function(self, card, context)

        if context.check_enhancement then
            if context.other_card.gambling then
                return{
                    m_lucky = true
                }
            end
        end

        if context.after then
            for i=1, #context.scoring_hand do
                context.scoring_hand[i].gambling = nil
            end
        end
    end

}

SMODS.Joker{ --Alloy
    name = "Alloy",
    key = "alloy",
    loc_txt = {
        ['name'] = 'Alloy',
        ['text'] = {
            [1] = "{C:attention}Gold Cards{} are also ",
            [2] = "considered {C:attention}Steel Cards{}",
            [3] = "{C:attention}Steel Cards{} are also ",
            [4] = "considered {C:attention}Gold Cards{}"
        }
    },
    pos = { 
        x = 4,
        y = 4
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ECjokers',
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
end





SMODS.Back{ --Bazaar Deck
    name = "Bazaar Deck",
	key = "bazaardeck",  
  loc_txt = {      
    name = 'Bazaar Deck',      
    text = {
        "Start run with",
        "{C:money,T:v_clearance_sale}#1#{},",
        "{C:attention,T:v_magic_trick}#2#{},",
        "and {C:dark_edition,T:v_hone}#3#",
    } 
  }, 
	order = 16,
  unlocked = true,
  discovered = true,
	config = {vouchers = {"v_clearance_sale","v_magic_trick","v_hone"}},
  loc_vars = function(self, info_queue, center)
    return {vars = {localize{type = 'name_text', key = 'v_clearance_sale', set = 'Voucher'}, localize{type = 'name_text', key = 'v_magic_trick', set = 'Voucher'}, localize{type = 'name_text', key = 'v_hone', set = 'Voucher'}}}
  end,
	pos = { x = 0, y = 0 },
	atlas = "ECother"
}

SMODS.Back{ --Archeology Deck
    name = "Archeology Deck",
	key = "archeologydeck",  
  loc_txt = {      
    name = 'Archeology Deck',      
    text = {
      "Start in {C:attention}Ante 0",
      "{C:attention}-1{} hand size"
    } 
  }, 
	order = 17,
  unlocked = true,
  discovered = true,
	config = {},
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end,
	pos = { x = 1, y = 0 },
	atlas = "ECother",
  apply = function(self, back)
    ease_ante(-1)
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - 1
    G.GAME.starting_params.hand_size = G.GAME.starting_params.hand_size - 1
  end
}

SMODS.Back{ --Echo Deck
    name = "Echo Deck",
	key = "echodeck",  
  loc_txt = {      
    name = 'Echo Deck',      
    text = {
      "{C:attention}Retrigger{} all playing cards",
      "{C:red}X1.2{} base Blind size",
      "Increases by {C:red}X0.2{} each Ante"
    } 
  }, 
    order = 18,
  unlocked = true,
  discovered = true,
	config = {},
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end,
	pos = { x = 2, y = 0 },
	atlas = "ECother",
  apply = function(self, back)
    G.GAME.starting_params.ante_scaling = 1.2
  end,

  calculate = function(self, back, context)
    if context.cardarea == G.play and context.repetition then
        return {
            message = localize('k_again_ex'),
            repetitions = 1,
            card = card
        }

    elseif context.repetition and context.cardarea == G.hand then
        if (next(context.card_effects[1]) or #context.card_effects > 1) then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card
            }
        end
    end
    
    if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss then
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling + 0.2
    end
  end
}


-- Resets

local function reset_tuxedo_card()
	local tuxedo_suits = {}
    G.GAME.current_round.tuxedo_card = G.GAME.current_round.tuxedo_card or {}
	for k, suit in pairs(SMODS.Suits) do
		if
			k ~= G.GAME.current_round.tuxedo_card.suit
			and (type(suit.in_pool) ~= "function" or suit:in_pool({ rank = "" }))
		then
			tuxedo_suits[#tuxedo_suits + 1] = k
		end
	end
	local tuxedo_card = pseudorandom_element(tuxedo_suits, pseudoseed("tux" .. G.GAME.round_resets.ante))
	G.GAME.current_round.tuxedo_card.suit = tuxedo_card
end

local function reset_farmer_card()
	local farmer_suits = {}
    G.GAME.current_round.farmer_card = G.GAME.current_round.farmer_card or {}
	for k, suit in pairs(SMODS.Suits) do
		if
			k ~= G.GAME.current_round.farmer_card.suit
			and (type(suit.in_pool) ~= "function" or suit:in_pool({ rank = "" }))
		then
			farmer_suits[#farmer_suits + 1] = k
		end
	end
	local farmer_card = pseudorandom_element(farmer_suits, pseudoseed("farm" .. G.GAME.round_resets.ante))
	G.GAME.current_round.farmer_card.suit = farmer_card
end

local function reset_fish_rank()
	local valid_fish_ranks = {}
    G.GAME.current_round.fish_rank = G.GAME.current_round.fish_rank or {}
	for k, rank in pairs(SMODS.Ranks) do
		if
			k ~= G.GAME.current_round.fish_rank.rank
			and (type(rank.in_pool) ~= "function" or rank:in_pool({ suit = "" }))
		then
			valid_fish_ranks[#valid_fish_ranks + 1] = k
		end
	end
	local fish_pick = pseudorandom_element(valid_fish_ranks, pseudoseed("fish" .. G.GAME.round_resets.ante))
	G.GAME.current_round.fish_rank.rank = fish_pick
end

mod.reset_game_globals = function(run_start)
	reset_tuxedo_card()
	reset_farmer_card()
	reset_fish_rank()
end