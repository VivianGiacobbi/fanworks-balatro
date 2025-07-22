---------------------------
--------------------------- Hook for extra blinds
---------------------------

local ref_cardarea_highlighted = CardArea.parse_highlighted
function CardArea:parse_highlighted()
    for k, v in pairs(G.GAME.fnwk_extra_blinds) do
        v.fnwk_extra_boss_throw_hand = nil
    end

    return ref_cardarea_highlighted(self)
end





---------------------------
--------------------------- Hook for extra blinds
---------------------------

local ref_cardarea_sort = CardArea.sort
function CardArea:sort(method)
    local sort = method or self.config.sort
    if not G.GAME.modifiers.fnwk_obscure_suits or (sort ~= 'suit desc' and sort ~= 'suit asc' ) then
        return ref_cardarea_sort(self, method)
    end

    return FnwkRandomSuitOrderCall(ref_cardarea_sort, self, method)
end





---------------------------
--------------------------- Exclusions for Disturbia Jokers
---------------------------

local function remove_disturbia_cards(cards_list)
    local disturbia_cards = {}
    if cards_list and #cards_list > 0 and next(SMODS.find_card('c_fnwk_streetlight_disturbia')) then
        for i=#cards_list, 1, -1 do
            if cards_list[i].fnwk_disturbia_joker then
                table.insert(disturbia_cards, 1, table.remove(cards_list, i))
            end
        end
    end

    return disturbia_cards
end

local function add_disturbia_cards(disturbia_cards, cards_list)
    if cards_list and #disturbia_cards > 0 then
        for _, v in ipairs(disturbia_cards) do
            table.insert(cards_list, v)
        end
    end
end

local ref_cardarea_init = CardArea.init
function CardArea:init(X, Y, W, H, config)
    local ret = ref_cardarea_init(self, X, Y, W, H, config)
    self.config.visible_card_limit = self.config.card_limit
    self.config.visible_card_count = 0
    self.config.disturbia_count = 0
    return ret
end

local ref_cardarea_emplace = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    if card.fnwk_disturbia_joker then
        self.config.disturbia_count = self.config.disturbia_count + 1
        self.config.real_card_limit = (self.config.real_card_limit or self.config.card_limit) + 1
        self.config.card_limit = math.max(0, self.config.real_card_limit)
    end

    ret = ref_cardarea_emplace(self, card, location, stay_flipped)
    return ret
end

local ref_remove_card = CardArea.remove_card
function CardArea:remove_card(card, discarded_only)
    if card and card.fnwk_disturbia_joker then
        self.config.disturbia_count = self.config.disturbia_count - 1
        self.config.real_card_limit = (self.config.real_card_limit or self.config.card_limit) - 1
        self.config.card_limit = math.max(0, self.config.real_card_limit)
    end

    local ret = ref_remove_card(self, card, discarded_only)   
    return ret
end

local ref_cardarea_update = CardArea.update
function CardArea:update(dt)
    local ret = ref_cardarea_update(self, dt)
    self.config.visible_card_count = self.config.card_count - self.config.disturbia_count
    self.config.visible_card_limit = self.config.card_limit - self.config.disturbia_count
    return ret
end

local ref_cardarea_draw = CardArea.draw
function CardArea:draw()
    if self ~= G.jokers then
        return ref_cardarea_draw(self)
    end

    if not self.states.visible then return end

    if not self.children.area_uibox then 
        local card_count = self ~= G.shop_vouchers and {n=G.UIT.R, config={align = self == G.jokers and 'cl' or self == G.hand and 'cm' or 'cr', padding = 0.03, no_fill = true}, nodes={
            {n=G.UIT.B, config={w = 0.1,h=0.1}},
            {n=G.UIT.T, config={ref_table = self.config, ref_value = 'visible_card_count', scale = 0.3, colour = G.C.WHITE}},
            {n=G.UIT.T, config={text = '/', scale = 0.3, colour = G.C.WHITE}},
            {n=G.UIT.T, config={ref_table = self.config, ref_value = 'visible_card_limit', scale = 0.3, colour = G.C.WHITE}},
            {n=G.UIT.B, config={w = 0.1,h=0.1}}
        }} or nil

        self.children.area_uibox = UIBox{
            definition =
                {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
                    {n=G.UIT.R, config={minw = self.T.w,minh = self.T.h,align = "cm", padding = 0.1, colour = {0,0,0,0.1}, mid = true, r = 0.1, ref_table = self}, nodes={
                    }},
                    card_count
                }},
            config = { align = 'cm', offset = {x=0,y=0}, major = self, parent = self}
        }
    end

    local disturbia_jokers = remove_disturbia_cards(self.cards)
    local ret = ref_cardarea_draw(self)
    add_disturbia_cards(disturbia_jokers, self.cards)

    return ret
end

local ref_cardarea_align = CardArea.align_cards
function CardArea:align_cards()
    if self ~= G.jokers then
        return ref_cardarea_align(self)
    end

    local disturbia_jokers = remove_disturbia_cards(self.cards)
    local ret = ref_cardarea_align(self)
    add_disturbia_cards(disturbia_jokers, self.cards)

    return ret
end