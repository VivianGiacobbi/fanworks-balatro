--- Creates a UI box appended as a child to the card, self.children.predict_ui
--- @param cardarea CardArea A Balatro cardarea table containing cards to display
--- @param align string Shorthand alignment string ('bm' for bottom middle)
function UIElement:show_artist_tooltip(cardarea, align)
    if self.children.art_tooltip then 
        self.children.art_tooltip:remove()     
    end

    self.children.art_tooltip = UIBox{
        definition = G.UIDEF.artist_card_ui(cardarea),
        config = { align = align or 'bm', offset = { x=0, y=0 }, parent = self}
    }
    self.children.art_tooltip:set_role{
        major = self,
        role_type = 'Minor',
        xy_bond = 'Weak',
        r_bond = 'Weak',
    }
end

--- Removes the predict_card_ui as a child from this card
function UIElement:remove_artist_tooltip()
    if not self.children.art_tooltip then 
        return
    end

    self.children.art_tooltip:remove()     
    self.children.art_tooltip = nil
end