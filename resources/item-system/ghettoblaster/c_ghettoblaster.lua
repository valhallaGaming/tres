local sound = false
local made = false

function checkForInterior()
	if ( (getElementDimension(getLocalPlayer()) == 1292 or getPlayerName(getLocalPlayer()) == "Alfonso_Moleneux") and not made ) then
		if ( getPlayerName(getLocalPlayer()) == "Alfonso_Moleneux") then
			local sound = playSound3D("ghettoblaster/right_round_loop.wav", 500.36328125, -74.9267578125, 998.7578125, true)
			setSoundMaxDistance(sound, 50)
		else
			setRadioChannel(7)
		end
		made = true
	elseif ( getElementDimension(getLocalPlayer()) ~= 1292 and made ) then
		if ( getPlayerName(getLocalPlayer()) == "Alfonso_Moleneux" ) then
			stopSound(sound)
			destroyElement(sound)
			sound = nil
		else
			setRadioChannel(0)
		end
		made = false
	end
end
setTimer(checkForInterior, 1000, 0)

blasters = { }

function startGB()
	local itemValue = tonumber( getElementData(source, "itemValue") ) or 0
	if itemValue > 0 then
		local x, y, z = getElementPosition(source)
		local px, py, pz = getElementPosition(getLocalPlayer())
		if (getDistanceBetweenPoints3D(x, y, z, px, py, pz)<300) then
			local sound = playSound3D("ghettoblaster/" .. tracks[itemValue].file, x, y, z, true)
			blasters[source] = sound
			setSoundMaxDistance(sound, 20)
			
			if (isPedInVehicle(getLocalPlayer())) then
				setSoundVolume(sound, 0.5)
			end
		end
	end
end

function stopGB()
	if (blasters[source]~=nil) then
		local sound = blasters[source]
		stopSound(sound)
		blasters[source] = nil
	end
end

function elementStreamIn()
	if (getElementType(source)=="object") then
		local model = getElementModel(source)
		if (model==2226) then
			startGB()
		end
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), elementStreamIn)

addEventHandler("onClientElementStreamOut", getRootElement(), stopGB)
addEventHandler("onClientElementDestroy", getRootElement(), stopGB)

function dampenSound(thePlayer)
	for key, value in pairs(blasters) do
		setSoundVolume(value, 0.5)
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), dampenSound)

function boostSound(thePlayer)
	for key, value in pairs(blasters) do
		setSoundVolume(value, 1.0)
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), boostSound)

function toggleSound(dataname)
	if isElementStreamedIn(source) and getElementModel(source) == 2226 and dataname == "itemValue" then
		local state = getElementData(source, "itemValue")
		if state > 0 then
			stopGB()
			startGB()
		else
			stopGB()
		end
	end
end
addEventHandler("onClientElementDataChange", getResourceRootElement(), toggleSound)