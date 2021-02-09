--冥界のルーフロギ

--scripted by Xylen5967
local s,id=GetID()
function s.initial_effect(c)
	--inverse
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.invcon)
	e1:SetTarget(s.invtg)
	e1:SetOperation(s.invop)
	c:RegisterEffect(e1)
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.subcon)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+100)
	e3:SetCost(s.thcost)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_series={CARD_ABHYSS}
function s.invcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.subcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_GRAVE
end
function s.tcfilter(c,e,tp)
	local atk=c:GetAttack()
	return c:IsFaceup() and Duel.IsExistingTarget(s.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,atk)
end
function s.spfilter(c,e,tp,atk)
	return c:IsAttackAbove(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function s.invtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.tcfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,s.tcfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,s.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,g1:GetFirst():GetAttack()) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,#g2,0,0)
end
function s.invop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc1=g2:GetFirst()
	if tc1:IsRelateToEffect(e) and Duel.SpecialSummon(tc1,0,1-tp,1-tp,false,false,POS_FACEUP)~=0 then
		local tc2=g1:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoGrave(tc2,REASON_EFFECT)
	end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
