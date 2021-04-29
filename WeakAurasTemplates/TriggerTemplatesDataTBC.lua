local WeakAuras = WeakAuras
if not WeakAuras.IsBC() then return end
local L = WeakAuras.L
local GetSpellInfo, tinsert, GetItemInfo, GetSpellDescription, C_Timer, Spell = GetSpellInfo, tinsert, GetItemInfo, GetSpellDescription, C_Timer, Spell

-- The templates tables are created on demand
local templates =
  {
    class = { },
    race = {
      Human = {},
      NightElf = {},
      Dwarf = {},
      Gnome = {},
      Draenei = {},
      Orc = {},
      Scourge = {},
      Tauren = {},
      Troll = {},
      BloodElf = {},
    },
    general = {
      title = L["General"],
      icon = 136116,
      args = {}
    },
  }

local manaIcon = "Interface\\Icons\\spell_frost_manarecharge.blp"
local rageIcon = "Interface\\Icons\\ability_racial_bloodrage.blp"
local comboPointsIcon = "Interface\\Icons\\ability_backstab"

local powerTypes =
  {
    [0] = { name = POWER_TYPE_MANA, icon = manaIcon },
    [1] = { name = POWER_TYPE_RED_POWER, icon = rageIcon},
    [2] = { name = POWER_TYPE_FOCUS, icon = "Interface\\Icons\\ability_hunter_focusfire"},
    [3] = { name = POWER_TYPE_ENERGY, icon = "Interface\\Icons\\spell_shadow_shadowworddominate"},
    [4] = { name = COMBO_POINTS, icon = comboPointsIcon},
  }

-- Collected by WeakAurasTemplateCollector:
--------------------------------------------------------------------------------

templates.class.WARRIOR = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 2565, type = "buff", unit = "player"}, -- Shield Block
        { spell = 6673, type = "buff", unit = "player"}, -- Battle Shout
        { spell = 18499, type = "buff", unit = "player"}, -- Berserker Rage
        { spell = 12292, type = "buff", unit = "player"}, -- Sweeping Strikes
        { spell = 12328, type = "buff", unit = "player"}, -- Death Wish
        { spell = 12317, type = "buff", unit = "player"}, -- Enrage
        { spell = 12319, type = "buff", unit = "player"}, -- Flurry
        { spell = 12975, type = "buff", unit = "player"}, -- Last Stand
      },
      icon = 132333
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 355, type = "debuff", unit = "target"}, -- Taunt
        { spell = 676, type = "debuff", unit = "target"}, -- Disarm
        { spell = 694, type = "debuff", unit = "target"}, -- Mocking Blow
        { spell = 772, type = "debuff", unit = "target"}, -- Rend
        { spell = 1160, type = "debuff", unit = "target"}, -- Demoralizing Shout
        { spell = 1715, type = "debuff", unit = "target"}, -- Hamstring
        { spell = 5246, type = "debuff", unit = "target"}, -- Intimidating Shout
        { spell = 6343, type = "debuff", unit = "target"}, -- Thunder Clap
        { spell = 7384, type = "debuff", unit = "target"}, -- Sunder Armor
        { spell = 12289, type = "debuff", unit = "target"}, -- Improved Hamstring
        { spell = 12294, type = "debuff", unit = "target"}, -- Mortal Strike
        { spell = 12797, type = "debuff", unit = "target"}, -- Improved Revenge
        { spell = 12809, type = "debuff", unit = "target"}, -- Concussion Blow
      },
      icon = 132366
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 72, type = "ability", debuff = true, requiresTarget = true, form = 2}, -- Shield Bash
        { spell = 100, type = "ability", requiresTarget = true, form = 1}, -- Charge
        { spell = 355, type = "ability", debuff = true, requiresTarget = true, form = 2}, -- Taunt
        { spell = 676, type = "ability", debuff = true, requiresTarget = true, form = 2}, -- Disarm
        { spell = 694, type = "ability", debuff = true, requiresTarget = true, form = 1}, -- Mocking Blow
        { spell = 772, type = "ability", debuff = true, requiresTarget = true}, -- Rend
        { spell = 845, type = "ability"}, -- Cleave
        { spell = 871, type = "ability", buff = true, form = 2}, -- Shield Wall
        { spell = 1160, type = "ability", debuff = true}, -- Demoralizing Shout
        { spell = 1161, type = "ability", debuff = true}, -- Challenging Shout
        { spell = 1464, type = "ability", requiresTarget = true}, -- Slam
        { spell = 1680, type = "ability", form = 3}, -- Whirlwind
        { spell = 1715, type = "ability", requiresTarget = true, form = {1, 2}}, -- Hamstring
        { spell = 1719, type = "ability", buff = true, form = 3}, -- Recklessness
        { spell = 2565, type = "ability", buff = true, form = 2}, -- Shield Block
        { spell = 2687, type = "ability", buff = true}, -- Bloodrage
        { spell = 5246, type = "ability", debuff = true, requiresTarget = true}, -- Intimidating Shout
        { spell = 5308, type = "ability", requiresTarget = true, form = {1, 3}}, -- Execute
        { spell = 6343, type = "ability", debuff = true, form = 1}, -- Thunder Clap
        { spell = 6552, type = "ability", requiresTarget = true, form = 3}, -- Pummel
        { spell = 6572, type = "ability", requiresTarget = true, usable = true, form = 2}, -- Revenge
        { spell = 6673, type = "ability", buff = true}, -- Battle Shout
        { spell = 7384, type = "ability", requiresTarget = true, form = 1}, -- Overpower
        { spell = 7386, type = "ability", requiresTarget = true, debuff = true}, -- Sunder Armor
        { spell = 12323, type = "ability", debuff = true, talent = 26}, -- Piercing Howl
        { spell = 12292, type = "ability", buff = true, talent = 13}, -- Sweeping Strikes
        { spell = 12294, type = "ability", requiresTarget = true, talent = 18}, -- Mortal Strike
        { spell = 12809, type = "ability", requiresTarget = true, debuff = true, talent = 54}, -- Concussion Blow
        { spell = 12975, type = "ability", buff = true, talent = 46}, -- Last Stand
        { spell = 12328, type = "ability", buff = true, talent = 33}, -- Death Wish
        { spell = 18499, type = "ability", buff = true, form = 3}, -- Berserker Rage
        { spell = 20230, type = "ability", buff = true, form = 1}, -- Retaliation
        { spell = 20252, type = "ability", requiresTarget = true, form = 3}, -- Intercept
        { spell = 23881, type = "ability", requiresTarget = true, talent = 37}, -- Bloodthirst
        { spell = 23922, type = "ability", requiresTarget = true, talent = 57}, -- Shield Slam
      },
      icon = 132355
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = rageIcon,
    }
  }
}

templates.class.PALADIN = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 498, type = "buff", unit = "player"}, -- Divine Protection
        { spell = 642, type = "buff", unit = "player"}, -- Divine Shield
        { spell = 1022, type = "buff", unit = "group"}, -- Blessing of Protection
        { spell = 1044, type = "buff", unit = "group"}, -- Blessing of Freedom
        { spell = 6940, type = "buff", unit = "group"}, -- Blessing of Sacrifice
      },
      icon = 135964
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 853, type = "debuff", unit = "target"}, -- Hammer of Justice
      },
      icon = 135952
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 498, type = "ability", buff = true}, -- Divine Protection
        { spell = 633, type = "ability"}, -- Lay on Hands
        { spell = 642, type = "ability", buff = true}, -- Divine Shield
        { spell = 853, type = "ability", requiresTarget = true, debuff = true}, -- Hammer of Justice
        { spell = 879, type = "ability", requiresTarget = true, usable = true}, -- Exorcism
        { spell = 1022, type = "ability", buff = true}, -- Blessing of Protection
        { spell = 1044, type = "ability", buff = true}, -- Blessing of Freedom
        { spell = 1152, type = "ability"}, -- Purify
        { spell = 2812, type = "ability"}, -- Holy Wrath
        { spell = 4987, type = "ability"}, -- Cleanse
        { spell = 6940, type = "ability"}, -- Blessing of Sacrifice
        { spell = 19876, type = "ability", buff = true}, -- Shadow Resistance Aura
        { spell = 19888, type = "ability", buff = true}, -- Frost Resistance Aura
        { spell = 19891, type = "ability", buff = true}, -- Fire Resistance Aura
        { spell = 20066, type = "ability", requiresTarget = true, debuff = true, talent = 55}, -- Repentance
        { spell = 20165, type = "ability", buff = true}, -- Seal of Justice
        { spell = 20165, type = "ability", buff = true}, -- Seal of Light
        { spell = 20166, type = "ability", buff = true}, -- Seal of Wisdom
        { spell = 20182, type = "ability", buff = true}, -- Seal of the Crusader
        { spell = 20271, type = "ability", buff = true, requiresTarget = true}, -- Judgement
        { spell = 20375, type = "ability", buff = true, talent = 48}, -- Seal of Command
        { spell = 20925, type = "ability", charges = true, buff = true, talent = 35}, -- Holy Shield
        { spell = 21084, type = "ability", buff = true}, -- Seal of Righteousness
        { spell = 24275, type = "ability", requiresTarget = true, usable = true}, -- Hammer of Wrath
        { spell = 26573, type = "ability", talent = 6}, -- Consecration
      },
      icon = 135972
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

templates.class.HUNTER = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 136, type = "buff", unit = "pet"}, -- Mend Pet
        { spell = 3045, type = "buff", unit = "player"}, -- Rapid Fire
        { spell = 5384, type = "buff", unit = "player"}, -- Feign Death
        { spell = 6197, type = "buff", unit = "player"}, -- Eagle Eye
        { spell = 19621, type = "buff", unit = "pet"}, -- Frenzy
        { spell = 24450, type = "buff", unit = "pet"}, -- Prowl
      },
      icon = 132242
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 1130, type = "debuff", unit = "target"}, -- Hunter's Mark
        { spell = 1513, type = "debuff", unit = "target"}, -- Scare Beast
        { spell = 1978, type = "debuff", unit = "target"}, -- Serpent Sting
        { spell = 2649, type = "debuff", unit = "target"}, -- Growl
        { spell = 2974, type = "debuff", unit = "target"}, -- Wing Clip
        { spell = 3034, type = "debuff", unit = "target"}, -- Viper Sting
        { spell = 3043, type = "debuff", unit = "target"}, -- Scorpid Sting
        { spell = 3355, type = "debuff", unit = "multi"}, -- Freezing Trap
        { spell = 5116, type = "debuff", unit = "target"}, -- Concussive Shot
        { spell = 24394, type = "debuff", unit = "target"}, -- Intimidation
      },
      icon = 135860
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 781, type = "ability"}, -- Disengage
        { spell = 1130, type = "ability", requiresTarget = true, debuff = true}, -- Hunter's Mark
        { spell = 1495, type = "ability", requiresTarget = true, usable = true}, -- Mongoose Bite
        { spell = 1499, type = "ability"}, -- Freezing Trap
        { spell = 1510, type = "ability"}, -- Volley
        { spell = 1513, type = "ability", requiresTarget = true, debuff = true}, -- Scare Beast
        { spell = 1543, type = "ability", duration = 30}, -- Flare
        { spell = 1978, type = "ability", requiresTarget = true, debuff = true}, -- Serpent Sting
        { spell = 2643, type = "ability"}, -- Multi-Shot
        { spell = 2649, type = "ability", requiresTarget = true, debuff = true}, -- Growl
        { spell = 2973, type = "ability", requiresTarget = true}, -- Raptor Strike
        { spell = 2974, type = "ability", requiresTarget = true, debuff = true}, -- Wing Clip
        { spell = 3034, type = "ability", requiresTarget = true, debuff = true}, -- Viper Sting
        { spell = 3043, type = "ability", requiresTarget = true, debuff = true}, -- Scorpid Sting
        { spell = 3044, type = "ability", requiresTarget = true}, -- Arcane Shot
        { spell = 3045, type = "ability", buff = true}, -- Rapid Fire
        { spell = 5116, type = "ability", requiresTarget = true, debuff = true}, -- Concussive Shot
        { spell = 5384, type = "ability", buff = true, unit = "player"}, -- Feign Death
        { spell = 13795, type = "ability"}, -- Immolation Trap
        { spell = 13809, type = "ability"}, -- Frost Trap
        { spell = 13813, type = "ability"}, -- Explosive Trap
        { spell = 16827, type = "ability", requiresTarget = true}, -- Claw
        { spell = 19263, type = "ability", buff = true}, -- Deterrence -TODO
        { spell = 19306, type = "ability", requiresTarget = true, usable = true}, -- Counterattack -TODO
        { spell = 19434, type = "ability", requiresTarget = true}, -- Aimed Shot -TODO
        { spell = 19386, type = "ability", requiresTarget = true, debuff = true}, -- Wyvern Sting -TODO
        { spell = 19503, type = "ability", requiresTarget = true, debuff = true}, -- Scatter Shot -TODO
        { spell = 19574, type = "ability", buff = true}, -- Bestial Wrath -TODO
        { spell = 19577, type = "ability", requiresTarget = true, debuff = true}, -- Intimidation -TODO
        { spell = 19801, type = "ability", requiresTarget = true}, -- Tranquilizing Shot
        { spell = 20736, type = "ability", requiresTarget = true}, -- Distracting Shot
      },
      icon = 135130
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

templates.class.ROGUE = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 2983, type = "buff", unit = "player"}, -- Sprint
        { spell = 5171, type = "buff", unit = "player"}, -- Slice and Dice
        { spell = 5277, type = "buff", unit = "player"}, -- Evasion
        { spell = 13750, type = "buff", unit = "player"}, -- Adrenaline Rush
        { spell = 13877, type = "buff", unit = "player"}, -- Blade Fury
        { spell = 14177, type = "buff", unit = "player"}, -- Cold Blood
        { spell = 14149, type = "buff", unit = "player"}, -- Remorseless
        { spell = 14278, type = "buff", unit = "player"}, -- Ghostly Strike
      },
      icon = 132290
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 703, type = "debuff", unit = "target"}, -- Garrote
        { spell = 14251, type = "debuff", unit = "target"}, -- Riposte
        { spell = 11198, type = "debuff", unit = "target"}, -- Expose Armor
        { spell = 18425, type = "debuff", unit = "target"}, -- Kick - Silenced
        { spell = 17348, type = "debuff", unit = "target"}, -- Hemorrhage
        { spell = 14183, type = "debuff", unit = "target"}, -- Premeditation
      },
      icon = 132302
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 53, type = "ability", requiresTarget = true, usable = true}, -- Backstab
        { spell = 703, type = "ability", requiresTarget = true, debuff = true}, -- Garrote
        { spell = 921, type = "ability", requiresTarget = true, usable = true}, -- Pick Pocket
        { spell = 1725, type = "ability", usable = true}, -- Distract
        { spell = 1752, type = "ability", requiresTarget = true}, -- Sinister Strike
        { spell = 1766, type = "ability", requiresTarget = true}, -- Kick
        { spell = 1776, type = "ability", requiresTarget = true, usable = true, debuff = true}, -- Gouge
        { spell = 1784, type = "ability", buff = true}, -- Stealth
        { spell = 1856, type = "ability", buff = true}, -- Vanish
        { spell = 2094, type = "ability", requiresTarget = true}, -- Blind
        { spell = 2098, type = "ability", requiresTarget = true}, -- Eviscerate
        { spell = 2983, type = "ability", buff = true}, -- Sprint
        { spell = 5171, type = "ability", requiresTarget = true, buff = true}, -- Slice and Dice
        { spell = 5277, type = "ability", buff = true}, -- Evasion
        { spell = 6770, type = "ability", requiresTarget = true, usable = true, debuff = true}, -- Sap
        { spell = 8647, type = "ability", requiresTarget = true, debuff = true}, -- Expose Armor
        { spell = 13750, type = "ability", buff = true, talent = 39}, -- Adrenaline Rush
        { spell = 13877, type = "ability", buff = true, talent = 34}, -- Blade Fury
        { spell = 14177, type = "ability", buff = true, talent = 12}, -- Cold Blood
        { spell = 14183, type = "ability", requiresTarget = true, debuff = true, talent = 57}, -- Premeditation
        { spell = 14185, type = "ability"}, -- Preparation
        { spell = 14251, type = "ability", requiresTarget = true, usable = true, debuff = true, talent = 28}, -- Riposte
        { spell = 14271, type = "ability", requiresTarget = true, buff = true, talent = 47}, -- Ghostly Strike
        { spell = 16511, type = "ability", requiresTarget = true, debuff = true, talent = 55}, -- Hemorrhage
      },
      icon = 132350
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = comboPointsIcon,
    },
  }
}

templates.class.PRIEST = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 586, type = "buff", unit = "player"}, -- Fade
        { spell = 17, type = "buff", unit = "target"}, -- Power Word: Shield
        { spell = 21562, type = "buff", unit = "player"}, -- Power Word: Fortitude
        { spell = 2096, type = "buff", unit = "player"}, -- Mind Vision
        { spell = 1706, type = "buff", unit = "player"}, -- Levitate
      },
      icon = 135940
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 8122, type = "debuff", unit = "target"}, -- Psychic Scream
        { spell = 2096, type = "debuff", unit = "target"}, -- Mind Vision
        { spell = 589, type = "debuff", unit = "target"}, -- Shadow Word: Pain
        { spell = 9484, type = "debuff", unit = "multi" }, -- Shackle Undead
      },
      icon = 136207
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 17, type = "ability"}, -- Power Word: Shield
        { spell = 527, type = "ability"}, -- Purify
        { spell = 552, type = "ability"}, -- Abolish Disease
        { spell = 585, type = "ability", requireTarget = true}, -- Smite
        { spell = 586, type = "ability", buff = true}, -- Fade
        { spell = 589, type = "ability", debuff = true}, -- Shadow Word: Pain
        { spell = 2060, type = "ability"}, -- Greater Heal
        { spell = 2061, type = "ability"}, -- Flash Heal
        { spell = 6064, type = "ability"}, -- Heal
        { spell = 8092, type = "ability", requireTarget = true}, -- Mind Blast
        { spell = 8122, type = "ability"}, -- Psychic Scream
        { spell = 10060, type = "ability", buff = true, talent = 15}, -- Power Infusion
        { spell = 10876, type = "ability", requireTarget = true}, -- Mana Burn
        { spell = 10947, type = "ability", requireTarget = true}, -- Mind Flay
        { spell = 10951, type = "ability", buff = true}, -- Inner Fire
        { spell = 14751, type = "ability", buff = true, talent = 7}, -- Inner Focus
        { spell = 14914, type = "ability", debuff = true, requireTarget = true}, -- Holy Fire
        { spell = 15487, type = "ability", debuff = true, requireTarget = true, talnet = 52}, -- Silence

      },
      icon = 136224
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

templates.class.SHAMAN = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 546, type = "buff", unit = "player"}, -- Water Walking
        { spell = 16256, type = "buff", unit = "player", talent = 50}, -- Flurry
      },
      icon = 135863
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 3600, type = "debuff", unit = "target"}, -- Earthbind
      },
      icon = 135813
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 131, type = "ability", buff = true, usable = true}, -- Water Breathing
        { spell = 324, type = "ability", buff = true}, -- Lightning Shield
        { spell = 331, type = "ability"}, -- Healing Wave
        { spell = 403, type = "ability", requireTarget = true}, -- Lightning Bolt
        { spell = 421, type = "ability", requireTarget = true}, -- Chain Lightning
        { spell = 546, type = "ability", buff = true, usable = true}, -- Water Walking
        { spell = 556, type = "ability"}, -- Astral Recall
        { spell = 974, type = "ability", buff = true, talent = 100}, -- Earth Shield
        { spell = 1064, type = "ability"}, -- Chain Heal
        { spell = 1535, type = "ability", totem = true}, -- Fire Nova Totem
        { spell = 2008, type = "ability"}, -- Ancestral Spirit
        { spell = 2062, type = "ability", totem = true}, -- Earth Elemental Totem
        { spell = 2484, type = "ability", totem = true}, -- Earthbind Totem
        { spell = 2645, type = "ability", buff = true}, -- Ghost Wolf
        { spell = 2825, type = "ability", buff = true}, -- Bloodlust
        { spell = 2894, type = "ability", totem = true}, -- Fire Elemental Totem
        { spell = 3599, type = "ability", totem = true}, -- Searing Totem
        { spell = 3738, type = "ability", totem = true}, -- Wrath of Air Totem
        { spell = 5394, type = "ability", totem = true}, -- Healing Stream Totem
        { spell = 5675, type = "ability", totem = true}, -- Mana Spring Totem
        { spell = 5730, type = "ability", totem = true}, -- Stoneclaw Totem
        { spell = 6495, type = "ability", totem = true}, -- Sentry Totem
        { spell = 8142, type = "ability", requireTarget = true}, -- Earth Shock
        { spell = 8143, type = "ability", requireTarget = true, debuff = true}, -- Frost Shock
        { spell = 8017, type = "ability", weaponBuff = true}, -- Rockbiter Weapon -- !! weaponBuff is not supported yet
        { spell = 8024, type = "ability", weaponBuff = true}, -- Flametongue Weapon
        { spell = 8033, type = "ability", weaponBuff = true}, -- Frostbrand Weapon
        { spell = 8050, type = "ability", requireTarget = true, debuff = true}, -- Flame Shock
        { spell = 8071, type = "ability", totem = true}, -- Stoneskin Totem
        { spell = 8075, type = "ability", totem = true}, -- Strength of Earth Totem
        { spell = 8143, type = "ability", totem = true}, -- Tremor Totem
        { spell = 8166, type = "ability", totem = true}, -- Poison Cleansing Totem
        { spell = 8170, type = "ability", totem = true}, -- Disease Cleansing Totem
        { spell = 8177, type = "ability", totem = true}, -- Grounding Totem
        { spell = 8181, type = "ability", totem = true}, -- Frost Resistance Totem
        { spell = 8184, type = "ability", totem = true}, -- Fire Resistance Totem
        { spell = 8190, type = "ability", totem = true}, -- Magma Totem
        { spell = 8227, type = "ability", totem = true}, -- Flametongue Totem
        { spell = 8514, type = "ability", totem = true}, -- Windfury Totem
        { spell = 8835, type = "ability", totem = true}, -- Grace of Air Totem
        { spell = 10595, type = "ability", totem = true}, -- Nature Resistance Totem
        { spell = 15107, type = "ability", totem = true}, -- Windwall Totem
        { spell = 16246, type = "ability", buff = true, talent = 6}, -- Clearcasting
        { spell = 16166, type = "ability", buff = true, talent = 17}, -- Elemental Mastery
        { spell = 16188, type = "ability", buff = true, talent = 93}, -- Nature Swiftness
        { spell = 16190, type = "ability", totem = true, talent = 96}, -- Mana Tide Totem
        { spell = 17364, type = "ability", debuff = true, talent = 59}, -- Stormstrike
        { spell = 20608, type = "ability"}, -- Reincarnation
        { spell = 24398, type = "ability", buff = true}, -- Water Shield
        { spell = 25908, type = "ability", totem = true}, -- Tranquil Air Totem
        { spell = 30706, type = "ability", totem = true, talent = 20}, -- Totem of Wrath
        { spell = 30823, type = "buff", talent = 61}, -- Shamanistic Rage
        { spell = 32182, type = "ability", buff = true}, -- Heroism
      },
      icon = 135963
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = 135990,
    },
  }
}

templates.class.MAGE = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 130, type = "buff", unit = "player"}, -- Slow Fall
        { spell = 543, type = "buff", unit = "player"}, -- Fire Ward
        { spell = 604, type = "buff", unit = "player"}, -- Dampen Magic
        { spell = 1008, type = "buff", unit = "player"}, -- Amplify Magic
        { spell = 1459, type = "buff", unit = "player"}, -- Arcane Intellect
        { spell = 1463, type = "buff", unit = "player"}, -- Mana Shield
        { spell = 6143, type = "buff", unit = "player"}, -- Frost Ward
        { spell = 11958, type = "buff", unit = "player"}, -- Ice Block
        { spell = 12042, type = "buff", unit = "player"}, -- Arcane Power
        { spell = 12536, type = "buff", unit = "player"}, -- Clearcasting
      },
      icon = 136096
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 122, type = "debuff", unit = "target"}, -- Frost Nova
        { spell = 118, type = "debuff", unit = "multi" }, -- Polymorph
        { spell = 11071, type = "debuff", unit = "target"}, -- Frostbite
        { spell = 11103, type = "debuff", unit = "target"}, -- Impact
        { spell = 11180, type = "debuff", unit = "target"}, -- Winter's Chill
      },
      icon = 135848
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 118, type = "ability", debuff = true, requireTarget = true}, -- Polymorph
        { spell = 120, type = "ability"}, -- Cone of Cold
        { spell = 122, type = "ability"}, -- Frost Nova
        { spell = 130, type = "ability", buff = true}, -- Slow Fall
        { spell = 475, type = "ability"}, -- Remove Curse
        { spell = 543, type = "ability", buff = true}, -- Fire Ward
        { spell = 1449, type = "ability"}, -- Arcane Explosion
        { spell = 1463, type = "ability", buff = true}, -- Mana Shield
        { spell = 1953, type = "ability"}, -- Blink
        { spell = 2120, type = "ability"}, -- Flamestrike
        { spell = 2136, type = "ability", requiresTarget = true}, -- Fire Blast
        { spell = 2139, type = "ability", requiresTarget = true}, -- Counterspell
        { spell = 2855, type = "ability", debuff = true, requireTarget = true}, -- Detect Magic
        { spell = 2948, type = "ability", requiresTarget = true}, -- Scorch
        { spell = 5143, type = "ability", requiresTarget = true}, -- Arcane Missiles
        { spell = 6143, type = "ability", buff = true}, -- Frost Ward
        { spell = 10187, type = "ability"}, -- Blizzard
        { spell = 11113, type = "ability", debuff = true, talent = 34}, -- Blast Wave
        { spell = 11129, type = "ability", buff = true, talent = 36}, -- Combustion
        { spell = 11426, type = "ability", buff = true, talent = 57}, --ice Barrier
        { spell = 11958, type = "ability", buff = true, talent = 54}, -- Ice Block
        { spell = 12042, type = "ability", buff = true, talent = 16}, -- Arcane Power
        { spell = 12043, type = "ability", buff = true, talent = 13}, -- Presence of Mind
        { spell = 12051, type = "ability"}, -- Evocation
        { spell = 12472, type = "ability", buff = true, talent = 49}, -- Cold Snap
        { spell = 18809, type = "ability", requiresTarget = true}, -- Pyroblast
        { spell = 25304, type = "ability", requiresTarget = true}, -- Frostbolt
      },
      icon = 136075
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

templates.class.WARLOCK = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 126, type = "buff", unit = "player"}, -- Eye of Kilrogg
        { spell = 687, type = "buff", unit = "player"}, -- Demon Skin
        { spell = 755, type = "buff", unit = "pet"}, -- Health Funnel
        { spell = 5697, type = "buff", unit = "player"}, -- Unending Breath
        { spell = 6229, type = "buff", unit = "player"}, -- Shadow Ward
        { spell = 7870, type = "buff", unit = "pet"}, -- Lesser Invisibility
        { spell = 18094, type = "buff", unit = "player"}, -- Nightfall
        { spell = 19028, type = "buff", unit = "player"}, -- Soul Link
        { spell = 20707, type = "buff", unit = "group"}, -- Soulstone
      },
      icon = 136210
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 172, type = "debuff", unit = "target"}, -- Corruption
        { spell = 603, type = "debuff", unit = "target"}, -- Curse of Doom
        { spell = 702, type = "debuff", unit = "target"}, -- Curse of Weakness
        { spell = 704, type = "debuff", unit = "target"}, -- Curse of Recklessness
        { spell = 710, type = "debuff", unit = "multi"}, -- Banish
        { spell = 980, type = "debuff", unit = "target"}, -- Curse of Agony
        { spell = 1098, type = "debuff", unit = "multi"}, -- Enslave Demon
        { spell = 1490, type = "debuff", unit = "target"}, -- Curse of the Elements
        { spell = 1714, type = "debuff", unit = "target"}, -- Curse of Tongues
        { spell = 6358, type = "debuff", unit = "target"}, -- Seduction
        { spell = 6789, type = "debuff", unit = "target", talent = 14 }, -- Mortal Coil
        { spell = 6360, type = "debuff", unit = "target"}, -- Whiplash
        { spell = 17862, type = "debuff", unit = "target"}, -- Curse of Shadow
        { spell = 18223, type = "debuff", unit = "target"}, -- Curse of Exhaustion
        { spell = 18265, type = "debuff", unit = "target", talent = 6 }, -- Siphon Life
      },
      icon = 136139
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 172, type = "ability", requiresTarget = true, debuff = true}, -- Corruption
        { spell = 348, type = "ability", requiresTarget = true, debuff = true}, -- Immolate
        { spell = 686, type = "ability", requiresTarget = true}, -- Shadow Bolt
        { spell = 698, type = "ability"}, -- Ritual of Summoning
        { spell = 710, type = "ability", requiresTarget = true, debuff = true}, -- Banish
        { spell = 980, type = "ability", requiresTarget = true, debuff = true}, -- Agony
        { spell = 1120, type = "ability", requiresTarget = true}, -- Drain Soul
        { spell = 3110, type = "ability", requiresTarget = true}, -- Firebolt
        { spell = 3716, type = "ability", requiresTarget = true}, -- Consuming Shadows
        { spell = 5138, type = "ability", requiresTarget = true}, -- Drain Mana
        { spell = 5484, type = "ability"}, -- Howl of Terror
        { spell = 5676, type = "ability", requiresTarget = true}, -- Searing Pain
        { spell = 5740, type = "ability"}, -- Rain of Fire
        { spell = 5782, type = "ability", requiresTarget = true, debuff = true}, -- Fear
        { spell = 6353, type = "ability", requiresTarget = true}, -- Soul Fire
        { spell = 6358, type = "ability", requiresTarget = true}, -- Seduction
        { spell = 6360, type = "ability", requiresTarget = true}, -- Whiplash
        { spell = 6789, type = "ability", requiresTarget = true, talent = 15 }, -- Mortal Coil
        { spell = 7814, type = "ability", requiresTarget = true}, -- Lash of Pain
        { spell = 7870, type = "ability"}, -- Lesser Invisibility
        { spell = 17962, type = "ability", requiresTarget = true, usable = true, talent = 56}, -- Conflagrate
        { spell = 17926, type = "ability", requiresTarget = true}, -- Death Coil
        { spell = 18288, type = "ability", buff = true, talent = 9}, -- Amplify Curse
        { spell = 18708, type = "ability", talent = 28}, -- Fel Domination
        { spell = 18877, type = "ability", requiresTarget = true, debuff = true, talent = 48}, -- Shadowburn
      },
      icon = 135808
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_misc_gem_amethyst_02",
    },
  }
}

templates.class.DRUID = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 774, type = "buff", unit = "player", talent = 9 }, -- Rejuvenation
        { spell = 5487, type = "buff", unit = "player"}, -- Bear Form
        { spell = 8936, type = "buff", unit = "player"}, -- Regrowth
        { spell = 783, type = "buff", unit = "player"}, -- Travel Form
        { spell = 768, type = "buff", unit = "player"}, -- Cat Form
        { spell = 22812, type = "buff", unit = "player"}, -- Barkskin
        { spell = 1850, type = "buff", unit = "player"}, -- Dash
        { spell = 5215, type = "buff", unit = "player"}, -- Prowl
        { spell = 29166, type = "buff", unit = "group"}, -- Innervate
      },
      icon = 136097
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 339, type = "debuff", unit = "multi"}, -- Entangling Roots
        { spell = 5211, type = "debuff", unit = "target", talent = 10 }, -- Mighty Bash
        { spell = 1079, type = "debuff", unit = "target", talent = 7 }, -- Rip
        { spell = 6795, type = "debuff", unit = "target"}, -- Growl
        { spell = 2637, type = "debuff", unit = "multi"}, -- Hibernate
      },
      icon = 132114
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 99, type = "ability", debuff = true}, -- Demoralizing Roar
        { spell = 339, type = "ability", requiresTarget = true, debuff = true}, -- Entangling Roots
        { spell = 740, type = "ability", duration = 10}, -- Tranquility
        { spell = 768, type = "ability"}, -- Cat Form
        { spell = 770, type = "ability", requiresTarget = true, debuff = true}, -- Faerie Fire
        { spell = 779, type = "ability", form = 3}, -- Swipe
        { spell = 783, type = "ability"}, -- Travel Form
        { spell = 1066, type = "ability"}, -- Aquatic Form
        { spell = 1079, type = "ability", requiresTarget = true, form = 3}, -- Rip
        { spell = 1082, type = "ability", requiresTarget = true, form = 3}, -- Claw
        { spell = 1822, type = "ability", requiresTarget = true, debuff = true, form = 3}, -- Rake
        { spell = 1850, type = "ability", buff = true}, -- Dash
        { spell = 2637, type = "ability", requiresTarget = true, debuff = true}, -- Hibernate
        { spell = 2782, type = "ability"}, -- Remove Curse
        { spell = 2893, type = "ability"}, -- Abolish Poison
        { spell = 2908, type = "ability", requiresTarget = true}, -- Soothe
        { spell = 2912, type = "ability", requiresTarget = true}, -- Starfire
        { spell = 5176, type = "ability", requiresTarget = true}, -- Wrath
        { spell = 5209, type = "ability", form = 1}, -- Challenging Roar
        { spell = 5211, type = "ability", requiresTarget = true, talent = 6, form = 1}, -- Mighty Bash
        { spell = 5215, type = "ability", buff = true}, -- Prowl
        { spell = 5217, type = "ability", buff = true, form = 3}, -- Tiger's Fury
        { spell = 5221, type = "ability", requiresTarget = true, form = 3}, -- Shred
        { spell = 5229, type = "ability", buff = true, form = 1}, -- Enrage
        { spell = 5487, type = "ability"}, -- Bear Form
        { spell = 5570, type = "ability", requiresTarget = true, debuff = true, talent = 47}, -- Insect Swarm
        { spell = 6785, type = "ability", requiresTarget = true, form = 1}, -- Ravage
        { spell = 6795, type = "ability", debuff = true, requiresTarget = true, form = 1}, -- Growl
        { spell = 6807, type = "ability", form = 1}, -- Maul
        { spell = 8921, type = "ability", requiresTarget = true, debuff = true}, -- Moonfire
        { spell = 8946, type = "ability"}, -- Cure Poison
        { spell = 9005, type = "ability", requiresTarget = true, debuff = true, form = 3}, -- Pounce
        { spell = 9634, type = "ability"}, -- Dire Bear Form
        { spell = 16689, type = "ability", buff = true, talent = 2}, -- Nature's Grasp
        { spell = 16914, type = "ability"}, -- Hurricane
        { spell = 16979, type = "ability", form = 1, talent = 27}, -- Feral Charge
        { spell = 17116, type = "ability", buff = true, talent = 51}, -- Nature's Swiftness
        { spell = 18562, type = "ability", talent = 55}, -- Swiftmend
        { spell = 22568, type = "ability", form = 3}, -- Ferocious Bite
        { spell = 22812, type = "ability", buff = true}, -- Barkskin
        { spell = 22842, type = "ability", buff = true}, -- Frenzied Regeneration
        { spell = 24858, type = "ability", talent = 16}, -- Moonkin Form
      },
      icon = 132134
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources and Shapeshift Form"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

-- General Section
tinsert(templates.general.args, {
  title = L["Health"],
  icon = "Interface\\Icons\\inv_potion_54",
  type = "health"
});
tinsert(templates.general.args, {
  title = L["Cast"],
  icon = 136209,
  type = "cast"
});
tinsert(templates.general.args, {
  title = L["Always Active"],
  icon = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura78",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_alwaystrue = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet alive"],
  icon = "Interface\\Icons\\ability_hunter_pet_raptor",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_HasPet = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet Behavior"],
  icon = "Interface\\Icons\\ability_defend.blp",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Pet Behavior"),
    event = "Pet Behavior",
    use_behavior = true,
    behavior = "assist"}}}
});

tinsert(templates.general.args, {
  spell = 2825, type = "buff", unit = "player",
  forceOwnOnly = true,
  ownOnly = nil,
  overideTitle = L["Bloodlust/Heroism"],
  spellIds = {2825, 32182}}
);

-- Meta template for Power triggers
local function createSimplePowerTemplate(powertype)
  local power = {
    title = powerTypes[powertype].name,
    icon = powerTypes[powertype].icon,
    type = "power",
    powertype = powertype,
  }
  return power;
end

-------------------------------
-- Hardcoded trigger templates
-------------------------------

-- Warrior
tinsert(templates.class.WARRIOR[1][8].args, {
  title = L["Stance"],
  icon = 132349,
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
    event = "Stance/Form/Aura"}}}
})
for j, id in ipairs({2457, 71, 2458}) do
  local title, _, icon = GetSpellInfo(id)
  if title then
    tinsert(templates.class.WARRIOR[1][8].args, {
      title = title,
      icon = icon,
      triggers = {
        [1] = {
          trigger = {
            type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
            event = "Stance/Form/Aura",
            use_form = true,
            form = { single = j }
          }
        }
      }
    });
  end
end

tinsert(templates.class.WARRIOR[1][8].args, createSimplePowerTemplate(1));
tinsert(templates.class.PALADIN[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.HUNTER[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.ROGUE[1][8].args, createSimplePowerTemplate(3));
tinsert(templates.class.ROGUE[1][8].args, createSimplePowerTemplate(4));
tinsert(templates.class.PRIEST[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.SHAMAN[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.MAGE[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.WARLOCK[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(1));
tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(3));
tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(4));

-- Shapeshift Form
tinsert(templates.class.DRUID[1][8].args, {
  title = L["Shapeshift Form"],
  icon = 132276,
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
    event = "Stance/Form/Aura"}}}
});
for j, id in ipairs({5487, 768, 783, 114282, 1394966}) do
  local title, _, icon = GetSpellInfo(id)
  if title then
    tinsert(templates.class.DRUID[1][8].args, {
      title = title,
      icon = icon,
      triggers = {
        [1] = {
          trigger = {
            type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
            event = "Stance/Form/Aura",
            use_form = true,
            form = { single = j }
          }
        }
      }
    });
  end
end


------------------------------
-- Hardcoded race templates
-------------------------------

-- Every Man for Himself
tinsert(templates.race.Human, { spell = 20600, type = "ability" });
-- Stoneform
tinsert(templates.race.Dwarf, { spell = 20594, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Dwarf, { spell = 20594, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Shadow Meld
tinsert(templates.race.NightElf, { spell = 20580, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.NightElf, { spell = 20580, type = "buff", titleSuffix = L["buff"]});
-- Escape Artist
tinsert(templates.race.Gnome, { spell = 20589, type = "ability" });

-- Blood Fury
tinsert(templates.race.Orc, { spell = 20572, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Orc, { spell = 20572, type = "buff", unit = "player", titleSuffix = L["buff"]});
--Cannibalize
tinsert(templates.race.Scourge, { spell = 20577, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Scourge, { spell = 20578, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Will of the Forsaken
tinsert(templates.race.Scourge, { spell = 7744, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Scourge, { spell = 7744, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- War Stomp
tinsert(templates.race.Tauren, { spell = 20549, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Tauren, { spell = 20549, type = "debuff", titleSuffix = L["debuff"]});
--Beserking
tinsert(templates.race.Troll, { spell = 26297, type = "ability", titleSuffix = L["Rogue cooldown"]});
tinsert(templates.race.Troll, { spell = 26296, type = "ability", titleSuffix = L["Warrior cooldown"]});
tinsert(templates.race.Troll, { spell = 20554, type = "ability", titleSuffix = L["Other cooldown"]});
tinsert(templates.race.Troll, { spell = 26635, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Arcane Torrent
tinsert(templates.race.BloodElf, { spell = 69179, type = "ability", titleSuffix = L["cooldown"]}); -- TODO check this for TBC
-- Gift of the Naaru
tinsert(templates.race.Draenei, { spell = 28880, type = "ability", titleSuffix = L["cooldown"]}); -- TODO check this for TBC
tinsert(templates.race.Draenei, { spell = 28880, type = "buff", unit = "player", titleSuffix = L["buff"]}); -- TODO check this for TBC

------------------------------
-- Helper code for options
-------------------------------

-- Enrich items from spell, set title
local function handleItem(item)
  local waitingForItemInfo = false;
  if (item.spell) then
    local name, icon, _;
    if (item.type == "item") then
      name, _, _, _, _, _, _, _, _, icon = GetItemInfo(item.spell);
      if (name == nil) then
        name = L["Unknown Item"] .. " " .. tostring(item.spell);
        waitingForItemInfo = true;
      end
    else
      name, _, icon = GetSpellInfo(item.spell);
      if (name == nil) then
        name = L["Unknown Spell"] .. " " .. tostring(item.spell);
      end
    end
    if (icon and not item.icon) then
      item.icon = icon;
    end

    item.title = item.overideTitle or name or "";
    if (item.titleSuffix) then
      item.title = item.title .. " " .. item.titleSuffix;
    end
    if (item.titlePrefix) then
      item.title = item.titlePrefix .. item.title;
    end
    if (item.titleItemPrefix) then
      local prefix = GetItemInfo(item.titleItemPrefix);
      if (prefix) then
        item.title = prefix .. "-" .. item.title;
      else
        waitingForItemInfo = true;
      end
    end
    if (item.type ~= "item") then
      local spell = Spell:CreateFromSpellID(item.spell);
      if (not spell:IsSpellEmpty()) then
        spell:ContinueOnSpellLoad(function()
          item.description = GetSpellDescription(spell:GetSpellID());
        end);
      end
      item.description = GetSpellDescription(item.spell);
    end
  end
  if (item.talent) then
    item.load = item.load or {};
    if type(item.talent) == "table" then
      item.load.talent = { multi = {} };
      for _,v in pairs(item.talent) do
        item.load.talent.multi[v] = true;
      end
      item.load.use_talent = false;
    else
      item.load.talent = {
        single = item.talent,
        multi = {};
      };
      item.load.use_talent = true;
    end
  end
  if (item.pvptalent) then
    item.load = item.load or {};
    item.load.use_pvptalent = true;
    item.load.pvptalent = {
      single = item.pvptalent,
      multi = {};
    }
  end
  if (item.covenant) then
    item.load = item.load or {}
    item.load.use_covenant = true
    item.load.covenant = {
      single = item.covenant,
      multi = {}
    }
  end
  if (item.bonusItemId) then
    item.load = item.load or {}
    item.load.use_item_bonusid_equipped = true
    item.load.item_bonusid_equipped = tostring(item.bonusItemId)
  end
  -- form field is lazy handled by a usable condition
  if item.form then
    item.usable = true
  end
  return waitingForItemInfo;
end

local function addLoadCondition(item, loadCondition)
  -- No need to deep copy here, templates are read-only
  item.load = item.load or {};
  for k, v in pairs(loadCondition) do
    item.load[k] = v;
  end
end

local delayedEnrichDatabase = false;
local itemInfoReceived = CreateFrame("frame")

local enrichTries = 0;
local function enrichDatabase()
  if (enrichTries > 3) then
    return;
  end
  enrichTries = enrichTries + 1;

  local waitingForItemInfo = false;
  for className, class in pairs(templates.class) do
    for specIndex, spec in pairs(class) do
      for _, section in pairs(spec) do
        local loadCondition = {
          use_class = true, class = { single = className, multi = {} },
        };
        for itemIndex, item in pairs(section.args or {}) do
          local handle = handleItem(item)
          if(handle) then
            waitingForItemInfo = true;
          end
          addLoadCondition(item, loadCondition);
        end
      end
    end
  end

  for raceName, race in pairs(templates.race) do
    local loadCondition = {
      use_race = true, race = { single = raceName, multi = {} }
    };
    for _, item in pairs(race) do
      local handle = handleItem(item)
      if handle then
        waitingForItemInfo = true;
      end
      if handle ~= nil then
        addLoadCondition(item, loadCondition);
      end
    end
  end

  for _, item in pairs(templates.general.args) do
    if (handleItem(item)) then
      waitingForItemInfo = true;
    end
  end

  if (waitingForItemInfo) then
    itemInfoReceived:RegisterEvent("GET_ITEM_INFO_RECEIVED");
  else
    itemInfoReceived:UnregisterEvent("GET_ITEM_INFO_RECEIVED");
  end
end


enrichDatabase();

itemInfoReceived:SetScript("OnEvent", function()
  if (not delayedEnrichDatabase) then
    delayedEnrichDatabase = true;
    C_Timer.After(2, function()
      enrichDatabase();
      delayedEnrichDatabase = false;
    end)
  end
end);


-- Enrich Display templates with default values
for regionType, regionData in pairs(WeakAuras.regionOptions) do
  if (regionData.templates) then
    for _, item in ipairs(regionData.templates) do
      for k, v in pairs(WeakAuras.regionTypes[regionType].default) do
        if (item.data[k] == nil) then
          item.data[k] = v;
        end
      end
    end
  end
end


WeakAuras.triggerTemplates = templates;
