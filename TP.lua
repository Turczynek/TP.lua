local itemid = nil -- to use with an item change from nil to item id.
local npcid = 909000 -- to use with an npc change from nil to npc id.
local Teleport = {};
local Color = {
	[1] = "|cff0000FF", -- Ally -- blue
	[2] = "|cffFF0000", -- Horde -- red
	[3] = "|cff006600", -- Both -- green
	[4] = "|cff000000", -- GM -- black
		};
-- Menu Title, icon, team, {location name, icon, team, minimum level, map, x, y, z, o}

-- icon 0=bubble::1=bag::2=flight::3=book::4=wheel::5=wheel::6=bag dot::7=bubble dots::8=tabard::9=2swords::10=dot

-- team :: 0 = ally, 1 = horde,  2 = horde/ally, 3 = gm /:T:\ 2 checks for a reason

Teleporter = {
	[1] = {"StormWind", 2, 2,
		{"StormWind", 2, 0, 1, 0, -8842.089844, 626.357971, 94.086632, 0.440620}, -- Ally
			},
	[2] = {"IronForge", 2, 2,
		{"IronForge", 1, 0, 1, 0, -4902.000488, -960.816162, 501.458954, 2.207237}, -- Ally
			},
	[3] = {"Darnassus", 2, 2,
		{"Darnassus", 2, 0, 1, 1, 9870.209961, 2493.469971, 1315.876221, 5.974544}, -- Ally
			},
	[4] = {"Exodar", 2, 2,
		{"Exodar", 2, 0, 1, 530, -3864.919922, -11643.700195, -137.644012, 2.410226}, -- Ally
			},
	[5] = {"Orgrimmar", 2, 2,
		{"Orgrimmar", 1, 1, 1, 1, 1600.981689, -4378.820313, 9.998322, 5.248190}, -- Horde
			},
	[6] = {"Undercity", 2, 2,
		{"Undercity", 2, 1, 1, 0, 1637.209961, 240.132004, -43.103401, 3.131470}, -- Horde
			},
	[7] = {"Thunder Bluff", 2, 2,
		{"Thunder Bluff", 2, 1, 1, 1, -1274.449951, 71.860100, 128.158981, 0.707645}, -- Horde
			},
	[8] = {"Silvermoon City", 2, 2,
		{"Silvermoon City", 2, 1, 1, 530, 9741.669922, -7454.189941, 13.557200, 3.142310}, -- Horde
			},
	[9] = {"Shattrath", 2, 2,
		{"Shattrath", 2, 2, 1, 530, -1822, 5417, 1, 3}, -- Both
			},
	[10] = {"Dalaran", 2, 2,
		{"Dalaran", 2, 2, 1, 571, 5807.060059, 506.243988, 657.575989, 5.544610}, -- Both
			},
	[11] = {"GuruBashi Arena", 2, 2,
		{"GuruBashi Arena", 9, 2, 1, 0, -13232.232422, 220.996262, 32.145123, 1.095633}, -- Both
			},
	[12] = {"Tanaris Desert", 2, 2,
		{"Tanaris Desert", 2, 0, 1, 1, -6940.910156, -3725.699951, 48.938099, 3.111740}, -- Both
			},
		}

local function TeleportStoneOnHello(event, player, unit, sender, intid, code)

	if (player:IsInCombat()~=true)then	-- Show main menu
	    
	    for i, v in ipairs(Teleporter) do

	        if(v[3] == 2)or(v[3] == player:GetTeam())or(player:IsGM() == true)then
	            player:GossipMenuAddItem(v[2], ""..Color[v[3]+1]..""..v[1], i, 0)
	        end
	    end
	    	player:GossipSendMenu(1, unit)
    else
		player:SendNotification("You are in combat.")
	end
end

local function TeleporterOnGossipSelect(event, player, unit, sender, intid, code)

    if (sender == 0) then -- return to main menu
        TeleportStoneOnHello(event, player, unit)
    return
    end

    if (intid == 0) then -- Show teleport sub-menu
    
        for i, v in ipairs(Teleporter[sender]) do

            if (i > 3) then

            	if((Teleporter[sender][i][3] == 2 or Teleporter[sender][i][3] == player:GetTeam())or(player:IsGM() == true))then
                	player:GossipMenuAddItem(v[2], ""..(Color[((Teleporter[sender][i][3])+1)]).."".. v[1].."|r", sender, i)
                end
            end
		end
	        player:GossipMenuAddItem(7, "Back..", 0, 0)
	        player:GossipSendMenu(1, unit)
        return
    else
        -- teleport --
        local name, icon, team, level, map, x, y, z, o = table.unpack(Teleporter[sender][intid])
        player:Teleport(map, x, y, z, o)
    end
	player:GossipComplete()
end

if(itemid ~= nil)then
	RegisterItemGossipEvent(itemid, 1, TeleportStoneOnHello)
	RegisterItemGossipEvent(itemid, 2, TeleporterOnGossipSelect)
	print("+    Item active.     +")
else
	print("+      Item nil.      +")
end
print("+-+-+-+-+-+-+-+-+-+-+-+")

if(npcid ~= nil)then
	RegisterCreatureGossipEvent(npcid, 1, TeleportStoneOnHello)
	RegisterCreatureGossipEvent(npcid, 2, TeleporterOnGossipSelect)
	print("+  Creature active.   +")
else
	print("+    Creature nil.    +")
end
print("+-+-+-+-+-+-+-+-+-+-+-+")
print("+  Teleporter Loaded  +")
print("+-+-+-+-+-+-+-+-+-+-+-+")
