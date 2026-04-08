TooltipBehaviorMixin = {};

function TooltipBehaviorMixin:SetTooltipText(tooltipText)
    if type(tooltipText) == "string" and tooltipText ~= "" then
        self.tooltipText = tooltipText;
    else
        self.tooltipText = nil;
    end
end

function TooltipBehaviorMixin:OnLeave()
    if GameTooltip then
        GameTooltip:Hide();
    end
end

function TooltipBehaviorMixin:OnEnter()
    if not (self and self:IsVisible() and GameTooltip and self.tooltipText) then
        return;
    end
    GameTooltip:ClearLines();
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT", 20, 5);
    GameTooltip:AddLine(self.tooltipText);
    GameTooltip:Show();
end

InstanceIconButtonTemplateMixin = {}
InstanceIconButtonTemplateMixin = CreateFromMixins(TooltipBehaviorMixin)


function InstanceIconButtonTemplateMixin:SetText(text)
    if (type(text) == "string" or type(text) == "number") and text ~= "" then
        self.name:SetText(text)
    else
        return
    end
end

function InstanceIconButtonTemplateMixin:SetTexture(image)
    if type(image) == "string" or type(image) == "number" then
        self.bgImage:SetTexture(image)
    else
        return
    end
end
