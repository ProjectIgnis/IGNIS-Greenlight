--Function to select an option based on the condition on the same place as the option in the first table
--If the third table isn't nil, the corresponding operation will be executed.
--Example Call: local x=aux.EffectCheck(tp,cons,strings,ops)(e,tp,eg,ep,ev,re,r,rp)
function Auxiliary.EffectCheck(tp,cons,strings,ops)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local eff,sel={},{}
		for i,con in ipairs(cons) do
			if con then
				table.insert(eff,strings[i])
				table.insert(sel,i)
			end
		end
		local choice=Duel.SelectOption(tp,table.unpack(eff))
		if ops then ops[sel[choice+1]](e,tp,eg,ep,ev,re,r,rp) end
		return sel[choice+1]
	end
end
--shortcut to detach a specific amount of materials from an Xyz monster (min=<X=<max). min=nil -> detaches all materials.
--label=true -> the amount of detached materials will be saved as a label.
function Auxiliary.doccost(min,max,label)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local ct,eff,set,label=c:GetOverlayCount(),Duel.IsPlayerAffectedByEffect(tp,CARD_NUMERON_NETWORK),c:IsSetCard(0x14b),label or false
		local min=min or ct
		local max=max or min
		if chk==0 then return c:CheckRemoveOverlayCard(tp,min,REASON_COST) or (eff and set) end
		if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
			return true
				else c:RemoveOverlayCard(tp,min,max,REASON_COST)
		end
		if label==true then 
			e:SetLabel(#Duel.GetOperatedGroup())
		end
	end
end