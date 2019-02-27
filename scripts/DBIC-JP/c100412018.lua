--ウィッチクラフト・ハイネ
--
--Scripted By-FW空鸽
function c100412018.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100412018.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100412018,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100412018)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c100412018.descost)
	e2:SetTarget(c100412018.destg)
	e2:SetOperation(c100412018.desop)
	c:RegisterEffect(e2)
end
function c100412018.tgtg(e,c)
	return c~=e:GetHandler() and c:IsRace(RACE_SPELLCASTER)
end
function c100412018.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsType(TYPE_SPELL) and c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and (c:IsHasEffect(100412024) or c:IsHasEffect(100412025))
end
function c100412018.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100412018.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c100412018.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_SZONE) then
		Duel.RegisterFlagEffect(tp,tc:GetCode(),RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(tc,REASON_COST)
	else 
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c100412018.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100412018.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
