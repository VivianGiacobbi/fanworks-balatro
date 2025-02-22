SMODS.load_file('includes/LuaNES/libs/serpent.lua')()
SMODS.load_file('includes/LuaNES/utils.lua')()
SMODS.load_file('includes/LuaNES/cpu.lua')()
SMODS.load_file('includes/LuaNES/ppu.lua')()
SMODS.load_file('includes/LuaNES/apu.lua')()
SMODS.load_file('includes/LuaNES/rom.lua')()
SMODS.load_file('includes/LuaNES/palette.lua')()
SMODS.load_file('includes/LuaNES/pads.lua')()

local band, bor, bxor, bnot, lshift, rshift = bit.band, bit.bor, bit.bxor, bit.bnot, bit.lshift, bit.rshift
local map, rotatePositiveIdx, nthBitIsSet, nthBitIsSetInt =
    UTILS.map,
    UTILS.rotatePositiveIdx,
    UTILS.nthBitIsSet,
    UTILS.nthBitIsSetInt

NES = {}
local NES = NES
NES._mt = { __index = NES }

function NES:reset()
    self.audio, self.video, self.input = { spec = {} }, { palette = {} }, {}

    local cpu = self.cpu
    cpu:reset()
    cpu.apu:reset(self.audio.spec)
    cpu.ppu:reset()
    self.rom:reset()
    self.pads:reset()
    cpu:boot()
    self.rom:load_battery()
end

function NES:run_once()
    self.cpu.ppu:setup_frame()
    self.cpu:run()
    self.cpu.ppu:vsync()
    self.cpu.apu:vsync()
    self.cpu:vsync()
    self.rom:vsync()
    self.frame = self.frame + 1
end

jit.off(NES.run_once)

function NES:run(counter)
    self:reset()
    if not counter then
        while true do
            self:run_once()
        end
    end
    local acum = 0
    while acum < counter do
        self:run_once()
        acum = acum + 1
    end
end

function NES:new(opts)
    opts = opts or {}
    local conf = { romfile = opts.file, pc = opts.pc or nil, loglevel = opts.loglevel or 0 }
    local nes = {}
    local palette = opts.palette or PALETTE:defacto_palette()
    setmetatable(nes, NES._mt)
    nes.cpu = CPU:new(conf)
    nes.cpu.apu = APU:new(conf, nes.cpu)
    nes.cpu.ppu = PPU:new(conf, nes.cpu, palette)
    nes.pads = {
        reset = function()
        end
    }
    nes.rom = ROM.load(conf, nes.cpu, nes.cpu.ppu)
    nes.pads = Pads:new(conf, nes.cpu, nes.cpu.apu)

    nes.frame = 0
    nes.frame_target = nil
    return nes
end
