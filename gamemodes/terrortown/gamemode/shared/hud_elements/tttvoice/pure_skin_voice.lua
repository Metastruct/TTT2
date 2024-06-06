--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local padding = 8

    local colorVoiceBar = Color(255, 255, 255, 35)
    local colorVoiceLine = Color(255, 255, 255, 140)
    local colorVoiceDivider = Color(255, 255, 255, 175)

    local baseDefaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 240, h = 48 },
        minsize = { w = 120, h = 48 },
    }

    function HUDELEMENT:Initialize()
        self.scale = 1.0
        self.padding = padding

        BaseClass.Initialize(self)
    end

    function HUDELEMENT:IsResizable()
        return true, false
    end

    function HUDELEMENT:GetDefaults()
        baseDefaults.basepos = {
            x = 10 * self.scale,
            y = 10 * self.scale,
        }

        return baseDefaults
    end

    function HUDELEMENT:PerformLayout()
        self.scale = appearance.GetGlobalScale()
        self.padding = padding * self.scale

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:DrawVoiceBar(ply, xPos, yPos, w, h)
        local color = VOICE.GetVoiceColor(ply)
        local data = VOICE.GetFakeVoiceSpectrum(ply, 24)

        local widthBar = (w - h) / #data - 1
        local heightBar = h
        local wNick = w - h - self.padding

        draw.Box(xPos + self.padding, yPos, w - self.padding, heightBar, color)
        self:DrawLines(xPos + self.padding, yPos, w - self.padding, heightBar, color.a)

        for i = 1, #data do
            local yValue = math.floor(data[i] * 0.5 * heightBar - 4 * self.scale)

            draw.Box(
                xPos + h + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h - yValue - 1,
                widthBar,
                yValue,
                colorVoiceBar
            )
            if yValue > 1 then
                draw.Box(
                    xPos + h + (i - 1) * (widthBar + 1),
                    yPos + 0.5 * h - yValue - 2,
                    widthBar,
                    self.scale,
                    colorVoiceLine
                )
            end

            draw.Box(
                xPos + h + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h,
                widthBar,
                self.scale,
                colorVoiceDivider
            )

            draw.Box(
                xPos + h + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h + 2,
                widthBar,
                yValue,
                colorVoiceBar
            )
            if yValue > 1 then
                draw.Box(
                    xPos + h + (i - 1) * (widthBar + 1),
                    yPos + 0.5 * h + 2 + yValue,
                    widthBar,
                    self.scale,
                    colorVoiceLine
                )
            end
        end

        draw.FilteredTexture(
            xPos,
            yPos,
            h,
            h,
            draw.GetAvatarMaterial(ply:SteamID64(), "medium"),
            255,
            COLOR_WHITE
        )
        self:DrawLines(xPos, yPos, h, h, 255)

        local textColor = util.GetDefaultColor(color)
        local textBgColor = util.GetDefaultColor(textColor)

        local textBgSpacing = 1
        draw.AdvancedText(
            ply:NickElliptic(wNick, "PureSkinPopupTextBlur", self.scale),
            "PureSkinPopupTextBlur",
            xPos + h + self.padding - textBgSpacing,
            yPos + h * 0.5 - 1 - textBgSpacing,
            textBgColor,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            false,
            self.scale
        )
        draw.AdvancedText(
            ply:NickElliptic(wNick, "PureSkinPopupTextBlur", self.scale),
            "PureSkinPopupTextBlur",
            xPos + h + self.padding + textBgSpacing,
            yPos + h * 0.5 - 1 - textBgSpacing,
            textBgColor,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            false,
            self.scale
        )
        draw.AdvancedText(
            ply:NickElliptic(wNick, "PureSkinPopupTextBlur", self.scale),
            "PureSkinPopupTextBlur",
            xPos + h + self.padding - textBgSpacing,
            yPos + h * 0.5 - 1 + textBgSpacing,
            textBgColor,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            false,
            self.scale
        )
        draw.AdvancedText(
            ply:NickElliptic(wNick, "PureSkinPopupTextBlur", self.scale),
            "PureSkinPopupTextBlur",
            xPos + h + self.padding + textBgSpacing,
            yPos + h * 0.5 - 1 + textBgSpacing,
            textBgColor,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            false,
            self.scale
        )

        draw.AdvancedText(
            ply:NickElliptic(wNick, "PureSkinPopupText", self.scale),
            "PureSkinPopupText",
            xPos + h + self.padding,
            yPos + h * 0.5 - 1,
            textColor,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            false,
            self.scale
        )
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()

        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local w, h = size.w, size.h

        local plys = player.GetAll()
        local plysSorted = {}

        for i = 1, #plys do
            local ply = plys[i]

            if not VOICE.IsSpeaking(ply) then
                continue
            end

            if ply == client then
                table.insert(plysSorted, 1, ply)

                continue
            end

            plysSorted[#plysSorted + 1] = ply
        end

        for i = 1, #plysSorted do
            local ply = plysSorted[i]

            self:DrawVoiceBar(ply, x, y, w, h)

            y = y + h + self.padding
        end
    end
end
