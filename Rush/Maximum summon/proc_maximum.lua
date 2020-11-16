SUMMON_TYPE_MAXIMUM = 0x4e000000 --to check if it is correct
if not aux.MaximumProcedure then
	aux.MaximumProcedure = {}
	Maximum = aux.MaximumProcedure
end
if not Maximum then
	Maximum = aux.MaximumProcedure
end
--Maximum Summon
Maximum.AddProcedure = aux.FunctionWithNamedArgs(
function(c,desc,...)
	c:GetMetatable().MaximumSet={...}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1074) --to update, it is the pendulum value
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(Maximum.Condition())
	e1:SetOperation(Maximum.Operation())
	e1:SetValue(SUMMON_TYPE_MAXIMUM)
	c:RegisterEffect(e1)
	--cannot be changed to def
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POS)
	e1:SetCondition(Maximum.centerCon)
	c:RegisterEffect(e1)
	
	
end,"handler","desc","filter1","filter2","filter3","filter4")
--that function check if you can maximum summon the monster and its other part(s)
function Maximum.Condition()
	return  function(e,c,og)
		if c==nil then return true end
		local filters=c.MaximumSet
		local ct=#filters
		if (ct+1)>Duel.GetLocationCount(tp,LOCATION_MZONE) then return false end
		local tp=c:GetControler()
		local g=nil
		if og then
			g=og:Filter(Card.IsLocation,nil,LOCATION_HAND)
		else
			g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		end
		return aux.SelectUnselectGroup(g,e,tp,ct,ct,Maximum.spcheck(table.unpack(filters)),0)
	end
end
function Maximum.spcheck(...)
	local filters={...}
	return function(sg,e,tp,mg)
		local ct=#filters
		for i=1,ct do
			if not sg:IsExists(filters[i],1,nil) then return false end
		end
		return #sg==ct
	end
end
--operation that do the maximum summon
function Maximum.Operation(...)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		if c==nil then return true end
		local filters=c.MaximumSet
		local ct=#filters
		if (ct+1)>Duel.GetLocationCount(tp,LOCATION_MZONE) then return false end
		local tp=c:GetControler()
		local g=nil
		if og then
			g=og:Filter(Card.IsLocation,nil,LOCATION_HAND)
		else
			g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		end
		local tg=aux.SelectUnselectGroup(g,e,tp,ct,ct,Maximum.spcheck(table.unpack(filters)),1,tp,HINTMSG_SPSUMMON)+c
		--adding the flag
		e:GetHandler():RegisterFlagEffect(FLAG_MAXIMUM_CENTER,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
		local tc=tg:GetFirst()
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(FLAG_MAXIMUM_SIDE,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
		end
		sg:Merge(tg)
	end
end
function Maximum.centerCon(e)
	return e:GetHandler():IsMaximumModeCenter()
end
FLAG_MAXIMUM_CENTER=170000000 --flag for center card maximum mode
FLAG_MAXIMUM_SIDE=170000001 --flag for Left/right maximum card
--function that return if the card is in Maximum Mode or not, atm it just return true as we are lacking info on how Maximum mode work
function Card.IsMaximumMode(c)
	return c:IsMaximumModeCenter() or c:IsMaximumModeSide()
end
function Card.IsMaximumModeCenter(c)
	return c:GetFlagEffect(FLAG_MAXIMUM_CENTER)>0
end
function Card.IsMaximumModeSide(c)
	return c:GetFlagEffect(FLAG_MAXIMUM_SIDE)>0
end
--I used Gemini as a reference for that function, while waiting for more information
function Auxiliary.IsMaximumMode(effect)
	local c=effect:GetHandler()
	return not c:IsDisabled() and c:IsMaximumMode()
end
--that function add the effect that change the Original atk of the Maximum monster
function Card.AddMaximumAtkHandler(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.IsMaximumMode)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c:GetMaximumAttack())
	c:RegisterEffect(e1)
end
--function that return the value of the "maximum atk" of the monster
function Card.GetMaximumAttack(c)
	local m=c:GetMetatable(true)
	if not m then return false end
	return m.MaximumAttack
end
--function that provide effects of the center piece to the side (mainly used for protection effects)
function Card.AddCenterToSideEffectHandler(c,eff)
	--grant effect to center
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(Maximum.centerCon)
	e1:SetTarget(Maximum.eftg)
	e1:SetLabelObject(eff)
	c:RegisterEffect(e1)
end
function Maximum.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsMaximumModeSide()
end
function Maximum.centerCon(e)
	return e:GetHandler():IsMaximumModeCenter()
end
--function to add everything related to Left/Right Maximum Monster behaviour
--c=card to register
--tc=center maximum card
function Card.AddSideMaximumHandler(c,eff)
	local tc=Duel.GetMatchingGroup(Card.IsMaximumModeCenter,c:GetControler(),LOCATION_MZONE,0,nil):GetFirst()
	--change atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Maximum.sideCon)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetMaximumAttack())
	c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(Maximum.sideCon)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(tc:GetLevel())
	c:RegisterEffect(e2)
	--change name
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Maximum.sideCon)
	e3:SetValue(tc:GetCode())
	c:RegisterEffect(e3)
	--change Race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(Maximum.sideCon)
	e4:SetValue(tc:GetRace())
	c:RegisterEffect(e4)
	--change attribute
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(Maximum.sideCon)
	e5:SetValue(tc:GetAttribute())
	c:RegisterEffect(e5)
	--grant effect to center
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(Maximum.sideCon)
	e6:SetTarget(Maximum.eftgCenter)
	e6:SetLabelObject(eff)
	c:RegisterEffect(e6)
	
	--cannot be battle target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetCondition(Maximum.sideCon)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	
	--cannot be changed to def
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_CHANGE_POS)
	e8:SetCondition(Maximum.sideCon)
	tc:RegisterEffect(e8)
	
	--tribute 1 = tribute all handler
	
	
end
function Maximum.eftgCenter(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsMaximumModeCenter()
end
function Maximum.sideCon(e)
	return e:GetHandler():IsMaximumModeSide()
end
function Card.HasDefense(c)
	return not (c:IsType(TYPE_LINK) or (c:IsType(TYPE_MAXIMUM) and c:IsMaximumMode()))
end 