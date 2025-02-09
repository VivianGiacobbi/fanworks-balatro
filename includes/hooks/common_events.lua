function reset_funkadelic()
    G.GAME.current_funky_suits = {'Spades', 'Hearts'}
    local suits = {'Spades','Hearts','Clubs','Diamonds'}
    local firstIdx = math.floor(pseudorandom('funk'..G.GAME.round_resets.ante) * 4) + 1
    G.GAME.current_funky_suits[1] = suits[firstIdx]
    table.remove(suits, firstIdx)
    G.GAME.current_funky_suits[2] = pseudorandom_element(suits, pseudoseed('funk'..G.GAME.round_resets.ante))
end