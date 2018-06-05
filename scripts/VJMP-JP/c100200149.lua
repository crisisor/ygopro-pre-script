--魔界の警邏課デスポリス
--Police Patrol of the Underworld
--Script by nekrozar
function c100200149.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100200149.regcon)
	e1:SetOperation(c100200149.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c100200149.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100200149,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100200149)
	e3:SetCondition(c100200149.ctcon)
	e3:SetCost(c100200149.ctcost)
	e3:SetTarget(c100200149.cttg)
	e3:SetOperation(c100200149.ctop)
	c:RegisterEffect(e3)
end
function c100200149.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c100200149.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(100200149,RESET_EVENT+RESETS_STANDARD,0,0)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100200149,1))
end
function c100200149.valcheck(e,c)
	local g=c:GetMaterial()
	if g:GetClassCount(Card.GetCode)==g:GetCount() and g:IsExists(Card.IsLinkAttribute(),2,nil,ATTRIBUTE_DARK) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c100200149.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100200149)~=0
end
function c100200149.cfilter(c)
	return Duel.IsExistingTarget(Card.IsCanAddCounter,0,LOCATION_MZONE,LOCATION_MZONE,1,c,0x1049,1)
end
function c100200149.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100200149.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c100200149.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100200149.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1049,1) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x1049,1)
end
function c100200149.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1049,1)
		if tc:GetFlagEffect(100200149)~=0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetTarget(c100200149.reptg)
		e1:SetOperation(c100200149.repop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(100200149,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function c100200149.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) not c:IsReason(REASON_REPLACE)
		and c:IsCanRemoveCounter(tp,0x1049,1,REASON_EFFECT) end
	return true
end
function c100200149.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	e:GetHandler():RemoveCounter(tp,0x1049,1,REASON_EFFECT)
end
