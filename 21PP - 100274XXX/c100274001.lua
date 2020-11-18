--エンジェルＯ１
--Angel O1
--Scripted by Rundas
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Additional Tribute Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(s.con)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,7))
	e2:SetValue(POS_FACEUP_ATTACK)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
--Special Summon
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(function(c) return c:IsLevelAbove(7) and not c:IsPublic() end,tp,LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsLevelAbove(7) and not c:IsPublic() end,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	g:DeleteGroup()
end
--Additional Tribute Summon
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and Duel.GetFlagEffect(tp,id+1)==0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end