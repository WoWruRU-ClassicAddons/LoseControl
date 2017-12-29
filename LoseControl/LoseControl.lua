local L = LoseControlLocale
local spellIds = {
	-- Druid
	[L["Hibernate"]] = "CC", -- Hibernate
	[L["Starfire Stun"]] = "CC", -- Starfire
	[L["Entangling Roots"]] = "Root", -- Entangling Roots
	[L["Bash"]] = "CC", -- Bash
	[L["Pounce Bleed"]] = "CC", -- Pounce
	[L["Feral Charge Effect"]] = "Root", -- Feral Charge
	-- Hunter
	[L["Intimidation"]] = "CC", -- Intimidation
	[L["Scare Beast"]] = "CC", -- Scare Beast
	[L["Scatter Shot"]] = "CC", -- Scatter Shot
	[L["Improved Concussive Shot"]] = "CC", -- Improved Concussive Shot
	[L["Concussive Shot"]] = "Snare", -- Concussive Shot
	[L["Freezing Trap Effect"]] = "CC", -- Freezing Trap
	[L["Freezing Trap"]] = "CC", -- Freezing Trap
	[L["Frost Trap Aura"]] = "Root", -- Freezing Trap
	[L["Frost Trap"]] = "Root", -- Frost Trap
	[L["Entrapment"]] = "Root", -- Entrapment
	[L["Wyvern Sting"]] = "CC", -- Wyvern Sting; requires a hack to be removed later
	[L["Counterattack"]] = "Root", -- Counterattack
	[L["Improved Wing Clip"]] = "Root", -- Improved Wing Clip
	[L["Wing Clip"]] = "Snare", -- Wing Clip
	[L["Boar Charge"]] = "Root", -- Boar Charge
	-- Mage
	[L["Polymorph"]] = "CC", -- Polymorph: Sheep
	[L["Polymorph: Turtle"]] = "CC", -- Polymorph: Turtle
	[L["Polymorph: Pig"]] = "CC", -- Polymorph: Pig
	[L["Counterspell - Silenced"]] = "Silence", -- Counterspell
	[L["Impact"]] = "CC", -- Impact
	[L["Blast Wave"]] = "Snare", -- Blast Wave
	[L["Frostbite"]] = "Root", -- Frostbite
	[L["Frost Nova"]] = "Root", -- Frost Nova
	[L["Frostbolt"]] = "Snare", -- Frostbolt
	[L["Cone of Cold"]] = "Snare", -- Cone of Cold
	[L["Chilled"]] = "Snare", -- Improved Blizzard + Ice armor
	-- Paladin
	[L["Hammer of Justice"]] = "CC", -- Hammer of Justice
	[L["Repentance"]] = "CC", -- Repentance
	-- Priest
	[L["Mind Control"]] = "CC", -- Mind Control
	[L["Psychic Scream"]] = "CC", -- Psychic Scream
	[L["Blackout"]] = "CC", -- Blackout
	[L["Silence"]] = "Silence", -- "Silence"
	[L["Mind Flay"]] = "Snare", -- Mind Flay
	-- Rogue
	[L["Blind"]] = "CC", -- Blind
	[L["Cheap Shot"]] = "CC", -- Cheap Shot
	[L["Gouge"]] = "CC", -- Gouge
	[L["Kidney Shot"]] = "CC", -- Kidney shot; the buff is 30621
	[L["Sap"]] = "CC", -- Sap
	[L["Kick - Silenced"]] = "Silence", -- Kick
	[L["Crippling Poison"]] = "Snare", -- Crippling Poison
	-- Warlock
	[L["Death Coil"]] = "CC", -- Death Coil
	[L["Fear"]] = "CC", -- Fear
	[L["Howl of Terror"]] = "CC", -- Howl of Terror
	[L["Curse of Exhaustion"]] = "Snare", -- Curse of Exhaustion
	[L["Pyroclasm"]] = "CC", -- Pyroclasm
	[L["Aftermath"]] = "Snare", -- Aftermath
	[L["Seduction"]] = "CC", -- Seduction
	[L["Spell Lock"]] = "Silence", -- Spell Lock
	[L["Inferno Effect"]] = "CC", -- Inferno Effect
	[L["Inferno"]] = "CC", -- Inferno
	[L["Cripple"]] = "Snare", -- Cripple
	-- Warrior
	[L["Charge Stun"]] = "CC", -- Charge Stun
	[L["Intercept Stun"]] = "CC", -- Intercept Stun
	[L["Intimidating Shout"]] = "CC", -- Intimidating Shout
	[L["Revenge Stun"]] = "CC", -- Revenge Stun
	[L["Concussion Blow"]] = "CC", -- Concussion Blow
	[L["Piercing Howl"]] = "Snare", -- Piercing Howl
	[L["Shield Bash - Silenced"]] = "Silence", -- Shield Bash - Silenced
	--Shaman	
	[L["Frostbrand Weapon"]] = "Snare", -- Frostbrand Weapon
	[L["Frost Shock"]] = "Snare", -- Frost Shock
	[L["Earthbind"]] = "Snare", -- Earthbind
	[L["Earthbind Totem"]] = "Snare", -- Earthbind Totem
	-- other
	[L["War Stomp"]] = "CC", -- War Stomp
	[L["Tidal Charm"]] = "CC", -- Tidal Charm
	[L["Mace Stun Effect"]] = "CC", -- Mace Stun Effect
	[L["Stun"]] = "CC", -- Stun
	[L["Gnomish Mind Control Cap"]] = "CC", -- Gnomish Mind Control Cap
	[L["Reckless Charge"]] = "CC", -- Reckless Charge
	[L["Sleep"]] = "CC", -- Sleep
	[L["Dazed"]] = "Snare", -- Dazed
	[L["Freeze"]] = "Root", -- Freeze
	[L["Chill"]] = "Snare", -- Chill
	[L["Charge"]] = "CC", -- Charge
}

local LoseControl = CreateFrame("Frame", "LoseControlPlayer", ActionButtonTemplate)

LoseControl.texture = LoseControl:CreateTexture(LoseControl, "BACKGROUND")
LoseControl.texture:SetAllPoints(LoseControl)
LoseControl.cooldown = CreateFrame("Model", "Cooldown", LoseControl, "CooldownFrameTemplate")
LoseControl.cooldown:SetAllPoints(LoseControl) 
LoseControl.maxExpirationTime = 0

LoseControl:SetHeight(50)
LoseControl:SetWidth(50)
LoseControl:SetPoint("CENTER", 0,0)
LoseControl:Hide()
LoseControl:RegisterEvent("UNIT_AURA")
LoseControl:RegisterEvent("PLAYER_AURAS_CHANGED")

LoseControl:SetScript("OnEvent", function()
	for i=1, 16 do -- 16 is enough due to HARMFUL filter
		local texture = UnitDebuff("player", i)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
		GameTooltip:SetUnitDebuff("player", i)
		local buffName = GameTooltipTextLeft1:GetText()
		GameTooltip:Hide()
		for k,v in pairs(spellIds) do
			if k == buffName then
				for j=0, 31 do
					local buffTexture = GetPlayerBuffTexture(j)
					if texture == buffTexture then
						local expirationTime = GetPlayerBuffTimeLeft(j)
						LoseControl:Show()
						LoseControl.texture:SetTexture(buffTexture)
						LoseControl.cooldown:SetModelScale(1)
						if LoseControl.maxExpirationTime <= expirationTime then
							CooldownFrame_SetTimer(LoseControl.cooldown, GetTime(), expirationTime, 1)
							LoseControl.maxExpirationTime = expirationTime
						end
						return
					end
				end
			else
				LoseControl.maxExpirationTime = 0
				LoseControl:Hide()
			end
		end
	end
end)