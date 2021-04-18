--昂光の裁き
-- Judgment of the Rising Light
local s,id=GetID()
function s.initial_effect(c)
	--change pos
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.rtdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rtdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and not c:IsMaximumModeSide()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
	local td=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.HintSelection(td)
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0then
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(tc:GetControler())
		end
		
		local g=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_MZONE,nil)
		if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)==0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			sg=sg:AddMaximumCheck()
			Duel.HintSelection(sg)
			if #sg>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
		
	end
end