--煉獄の契約
--Contract with the Void
--Scripted by Rundas
local s,id=GetID()
function s.initial_effect(c)
	--Discard + Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_series={0xb}
function s.filter(c,e,tp)
	return (c:IsSetCard(0xb) or (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(8) and c:IsRace(RACE_DRAGON))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=3
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)==0 or (not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,1,nil,e,tp)) or
	   Duel.IsPlayerAffectedByEffect(tp,CARD_NECROVALLEY) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	end
end
