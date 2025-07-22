SMODS.Gradient({key = 'bluebolt', colours = {HEX('3BC2EF'), HEX('3BACD1')}, cycle = 2 })
SMODS.Gradient({key = 'rebels', colours = {HEX('FF77E1'), HEX('38A2E1')}, cycle = 2 })
SMODS.Gradient({key = 'closer', colours = {HEX('FFCC00'), HEX('D4AF37'), HEX('B8860B')}, cycle = 2})
SMODS.Gradient({key = 'redrising', colours = {HEX('7F1010'), HEX('812F93')}, cycle = 2})
SMODS.Gradient({
    key = 'rainbow',
    colours = {
        HEX('FF0000DC'),
        HEX('FF7300DC'),
        HEX('FFD000DC'),
        HEX('33FF00DC'),
        HEX('00FFBCDC'),
        HEX('00F7FFDC'),
        HEX('00B7FFDC'),
        HEX('0044FFDC'),
        HEX('5100FFDC'),
        HEX('AE00FFDC'),
        HEX('D300BEDC'),
    },
    cycle = 2
})

SMODS.Gradient({key = 'moe_light', colours = {HEX('4E77E0'), HEX('FD5F55'), HEX('B482E0')}, cycle = 4})
SMODS.Gradient({key = 'moe_dark', colours = {HEX('344266'), HEX('663535'), HEX('4D3566')}, cycle = 4})
SMODS.Gradient({key = 'moe_dim', colours = {HEX('4C5366'), HEX('664C4C'), HEX('584C66')}, cycle = 4})

SMODS.Gradient({
    key = 'blind_rainbow_light',
    colours = {
        HEX('E34141'),
        HEX('EE954C'),
        HEX('F6D854'),
        HEX('70F150'),
        HEX('50F2C7'),
        HEX('50DFF1'),
        HEX('4BBFEC'),
        HEX('416BE2'),
        HEX('713DDF'),
        HEX('B042E3'),
        HEX('C843BB'),
    },
    cycle = 12
})

SMODS.Gradient({
    key = 'blind_rainbow_dark',
    colours = {
        HEX('6B3434'),
        HEX('876142'),
        HEX('9B9066'),
        HEX('638E58'),
        HEX('47917D'),
        HEX('48878E'),
        HEX('427184'),
        HEX('394668'),
        HEX('3F3160'),
        HEX('5B376D'),
        HEX('60315C'),
    },
    cycle = 12
})

SMODS.Gradient({
    key = 'blind_rainbow_dim',
    colours = {
        HEX('473939'),
        HEX('473F39'),
        HEX('474239'),
        HEX('3C4739'),
        HEX('394742'),
        HEX('394647'),
        HEX('394347'),
        HEX('393C47'),
        HEX('3C3947'),
        HEX('413947'),
        HEX('473946'),
    },
    cycle = 12
})

local function grad_update_func(self, dt)
    self[1] = 0.6 + 0.2 * math.sin(self.config.offset + G.TIMERS.REAL * 1.3)
    self[3] = 0.6 + 0.2 * (1 - math.sin(self.config.offset + G.TIMERS.REAL * 1.3))
    self[2] = math.min(self[3], self[1])
    self[4] = 1
end

SMODS.Gradient({
    key = 'dark_edition_1',
    colours = {HEX('99CC99'), HEX('CC9999'), HEX('66FF66')},
    config = { offset = 0 },
    cycle = 3,
    update = grad_update_func
})

SMODS.Gradient({
    key = 'dark_edition_2',
    colours = { HEX('CC9999'), HEX('66FF66'), HEX('99CC99')},
    config = { offset = math.pi },
    cycle = 3,
    update = grad_update_func
})

SMODS.Gradient({
    key = 'dark_edition_3',
    colours = { HEX('66FF66'), HEX('99CC99'), HEX('CC9999')},
    config = { offset = (2 * math.pi) },
    cycle = 3,
    update = grad_update_func
})