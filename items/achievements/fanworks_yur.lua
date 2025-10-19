local achInfo = {
    rarity = 1,
    config = {rank = 'Queen', num = 2},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {self.config.num, self.config.rank}}
end

function achInfo.unlock_condition(self, args)
    if args.type == 'hand_contents' then
        if G.GAME.current_round.hands_left == 0 and #args.cards == self.config.num then
            for _, v in ipairs(args.cards) do
                if v.base.value ~= self.config.rank then return false end
            end
            G.GAME.fnwk_yur_flag = true
        else
            G.GAME.fnwk_yur_flag = nil
        end
    elseif args.type == 'fnwk_run_loss' and G.GAME.fnwk_yur_flag then
        G.GAME.fnwk_yur_flag = nil
        return true
    end
end

return achInfo