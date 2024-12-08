B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
#if Documentation
Updates
V1.00
	-Release
V1.01
	-The checkbox is now also toggled when you click on the text
V1.02
	-Add Designer Property CheckBox2TextGap - Gap between checkbox and text
		-Default: 10dip
V1.03
	-BugFixes and Improvements
V1.04 (nicht veröffentlicht)
	-Add get CheckBoxLabel - The checkbox label
#End If

#DesignerProperty: Key: CheckBoxWidthHeight, DisplayName: CheckBoxWidthHeight, FieldType: Int, DefaultValue: 24, MinRange: 0
#DesignerProperty: Key: CheckBox2TextGap, DisplayName: CheckBox2TextGap, FieldType: Int, DefaultValue: 10, MinRange: 0 , Description: Gap between checkbox and text
#DesignerProperty: Key: CornerRadius, DisplayName: Corner Radius, FieldType: Int, DefaultValue: 5, MinRange: 0

#DesignerProperty: Key: CheckedBackgroundColor, DisplayName: Checked Background Color, FieldType: Color, DefaultValue: 0xFF2D8879 
#DesignerProperty: Key: DisabledBackgroundColor, DisplayName: Disabled Background Color, FieldType: Color, DefaultValue: 0xFF3C4043
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0xFFFFFFFF
#DesignerProperty: Key: DisabledIconColor, DisplayName: Disabled Icon Color, FieldType: Color, DefaultValue: 0x98FFFFFF
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 2, MinRange: 1
#DesignerProperty: Key: CheckedAnimated, DisplayName: Checked Animated, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: HapticFeedback, DisplayName: Haptic Feedback, FieldType: Boolean, DefaultValue: True, Description: Whether to make a haptic feedback when the user clicks on the control.
#DesignerProperty: Key: Checked, DisplayName: Checked, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True

#Event: CheckedChange(Checked As Boolean)

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI 'ignore
	Public Tag As Object
	Private xlbl_CheckBox As B4XView
	Private xlbl_Text As B4XView
	Private xpnl_ClickPanel As B4XView
	
	Private m_Icon As String 
	Private m_isFontAswesome As Boolean = False
	Private m_IconColor As Int
	Private m_CheckedBackgroundColor As Int
	Private m_DisabledColor As Int
	Private m_DisabledIconColor As Int
	Private m_isChecked As Boolean = False
	Private m_BorderWidth As Int
	Private m_CornerRadius As Int
	Private m_isCheckedAnimated As Boolean
	Private m_isHaptic As Boolean'Ignore
	Private m_isEvent As Boolean = True
	Private m_isEnabled As Boolean
	
	Private m_CheckBoxWidthHeight As Float
	Private m_CheckBox2TextGap As Float = 10dip
	Private m_CheckBoxGap As Float = 5dip
	
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
    Tag = mBase.Tag
    mBase.Tag = Me 
	ini_props(Props)
	xlbl_CheckBox = CreateLabel("xlbl_CheckBox")
	xlbl_Text = Lbl
	xpnl_ClickPanel = xui.CreatePanel("xpnl_ClickPanel")
	xpnl_ClickPanel.Color = xui.Color_Transparent
	
	mBase.AddView(xlbl_CheckBox,m_CheckBoxGap,0,0,0)
	mBase.AddView(xlbl_Text,m_CheckBoxWidthHeight + m_CheckBox2TextGap + xlbl_CheckBox.Left,0,mBase.Width-m_CheckBoxWidthHeight - m_CheckBox2TextGap - xlbl_CheckBox.Left,mBase.Height)
	mBase.AddView(xpnl_ClickPanel,0,0,mBase.Width,mBase.Height)
	
	
	xlbl_CheckBox.Enabled = m_isEnabled
	
	m_Icon = Chr(0xE5CA)
	
	Base_Resize(mBase.Width,mBase.Height)
	
	Check(m_isChecked,False,False)
End Sub

Private Sub ini_props(Props As Map)
	m_isEnabled = Props.GetDefault("Enabled",True)
	
	m_CheckedBackgroundColor = xui.PaintOrColorToColor(Props.Get("CheckedBackgroundColor"))
	m_IconColor = xui.PaintOrColorToColor(Props.Get("IconColor"))
	m_DisabledColor = xui.PaintOrColorToColor(Props.Get("DisabledBackgroundColor"))
	m_DisabledIconColor = xui.PaintOrColorToColor(Props.Get("DisabledIconColor"))
	m_BorderWidth = Props.Get("BorderWidth")
	m_CornerRadius = Props.Get("CornerRadius")
	m_isCheckedAnimated = Props.Get("CheckedAnimated")
	m_isHaptic = Props.Get("HapticFeedback")
	m_isChecked = Props.GetDefault("Checked",False)
	
	m_CheckBoxWidthHeight = DipToCurrent(Props.Get("CheckBoxWidthHeight"))
	m_CheckBox2TextGap = DipToCurrent(Props.GetDefault("CheckBox2TextGap",10dip))
	
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
	xlbl_CheckBox.SetLayoutAnimated(0,m_CheckBoxGap,Height/2 - m_CheckBoxWidthHeight/2,m_CheckBoxWidthHeight,m_CheckBoxWidthHeight)
	xlbl_Text.SetLayoutAnimated(0,m_CheckBoxWidthHeight + m_CheckBox2TextGap + xlbl_CheckBox.Left,0,mBase.Width-m_CheckBoxWidthHeight - m_CheckBox2TextGap - xlbl_CheckBox.Left,mBase.Height)
	xpnl_ClickPanel.SetLayoutAnimated(0,0,0,Width,Height)
	#If B4J
	Dim jo As JavaObject = xlbl_CheckBox
	jo.RunMethod("setMinSize", Array(xlbl_CheckBox.Width/2, xlbl_CheckBox.Height/2))
	jo.RunMethod("setMaxSize", Array(xlbl_CheckBox.Width, xlbl_CheckBox.Height))
	#End If
	UpdateStyle
End Sub

Private Sub UpdateStyle
	Dim clr_background As Int = m_CheckedBackgroundColor	
	If m_isEnabled = False Then clr_background = m_DisabledColor
	
	Dim clr_icon As Int = m_IconColor
	If m_isEnabled = False Then clr_icon = m_DisabledIconColor
	
	If m_isChecked = False Then
		xlbl_CheckBox.SetColorAndBorder(xui.Color_Transparent,m_BorderWidth,clr_background,m_CornerRadius)
	Else
		xlbl_CheckBox.SetColorAndBorder(clr_background,m_BorderWidth,clr_background,m_CornerRadius)
		xlbl_CheckBox.TextColor = clr_icon
	End If
End Sub


Public Sub setChecked(b_checked As Boolean)
	m_isChecked = b_checked
	Check(b_checked,m_isCheckedAnimated,True)
End Sub

Public Sub getChecked As Boolean
	Return m_isChecked
End Sub

Public Sub Refresh
	Base_Resize(mBase.Width,mBase.Height)
End Sub

Private Sub Check(b_checked As Boolean,animated As Boolean,WithEvent As Boolean)
	
	If b_checked Then
		'xlbl_CheckBox.Color = m_CheckedBackgroundColor
		'xlbl_CheckBox.TextColor = m_IconColor
		UpdateStyle
		xlbl_CheckBox.SetTextAlignment("CENTER","CENTER")
		xlbl_CheckBox.Text = m_Icon
		xlbl_CheckBox.Font = IIf(m_isFontAswesome = False,xui.CreateMaterialIcons(1),xui.CreateFontAwesome(1))
		Dim size As Float = 2
		For size = 2 To 500
			If CheckSize(size) Then Exit
		Next
		If size > 10 Then size = size - 5
		
		If m_isCheckedAnimated = True And animated = True Then
			xlbl_CheckBox.Font = IIf(m_isFontAswesome = False,xui.CreateMaterialIcons(1),xui.CreateFontAwesome(1))
		
			Jump
			If (m_CornerRadius <> 0 And xui.IsB4i = False) Or m_CornerRadius = 0 Then
				Sleep(250)
			End If
			
			
			xlbl_CheckBox.SetTextSizeAnimated(250,size)
		Else
			xlbl_CheckBox.Font = IIf(m_isFontAswesome = False,xui.CreateMaterialIcons(size),xui.CreateFontAwesome(size))
		End If
	
	Else
		xlbl_CheckBox.Color = xui.Color_Transparent
		xlbl_CheckBox.Text = ""
		Sleep(0)
		If m_isCheckedAnimated = True And animated = True Then Jump
	End If
	If WithEvent = True And m_isEvent = True Then
		CheckedChange
	End If
End Sub
'https://www.b4x.com/android/forum/threads/iamir_viewanimator.100194/#content
Private Sub Jump	
	#If B4I
'	Dim tmp_lbl As Label = xlbl_CheckBox	
'	tmp_lbl.SetLayoutAnimated(250,1,m_CheckBoxWidthHeight/4,mBase.Height/2 - m_CheckBoxWidthHeight/4,m_CheckBoxWidthHeight/2,m_CheckBoxWidthHeight/2)
'	Sleep(250)
'	tmp_lbl.SetLayoutAnimated(250,1,mBase.Height/2 - m_CheckBoxWidthHeight/2,0,m_CheckBoxWidthHeight,m_CheckBoxWidthHeight)
	#Else
	xlbl_CheckBox.SetLayoutAnimated(250,m_CheckBoxGap + m_CheckBoxWidthHeight/4,mBase.Height/2 - m_CheckBoxWidthHeight/4,m_CheckBoxWidthHeight/2,m_CheckBoxWidthHeight/2)
	Sleep(250)
	xlbl_CheckBox.SetLayoutAnimated(250,m_CheckBoxGap,mBase.Height/2 - m_CheckBoxWidthHeight/2,m_CheckBoxWidthHeight,m_CheckBoxWidthHeight)
	#End If
End Sub

'Call Refresh if you change this value
Public Sub getCheckBoxWidthHeight As Float
	Return m_CheckBoxWidthHeight
End Sub

Public Sub setCheckBoxWidthHeight(WidthHeight As Float)
	m_CheckBoxWidthHeight = WidthHeight
End Sub

Public Sub getText As String
	Return xlbl_Text.Text
End Sub

Public Sub setText(Text As String)
	xlbl_Text.Text = Text
End Sub

Public Sub getTextLabel As B4XView
	Return xlbl_Text
End Sub

Public Sub getCheckBoxLabel As B4XView
	Return xlbl_CheckBox
End Sub

Public Sub SetIcon(icon As String,isfontawesome As Boolean)
	m_Icon = icon
	m_isFontAswesome = isfontawesome
	If m_isChecked = True Then Check(m_isChecked,False,False)
End Sub

Public Sub setBorderCornerRadius(radius As Int)
	m_CornerRadius = radius
	UpdateStyle
End Sub

Public Sub setBorderWidth(width As Int)
	m_BorderWidth = width
	UpdateStyle
End Sub

Public Sub getIconColor As Int
	Return m_IconColor
End Sub

Public Sub setIconColor(Color As Int)
	m_IconColor = Color
	UpdateStyle
End Sub

Public Sub setCheckedBackgroundColor(crl As Int)
	m_CheckedBackgroundColor = crl
	UpdateStyle
End Sub

Public Sub setCheckedAnimated(animated As Boolean)
	m_isCheckedAnimated = animated
End Sub

Public Sub setEnabled(enable As Boolean)
	m_isEnabled = enable
	mBase.Enabled = enable
	xlbl_CheckBox.Enabled = enable
	UpdateStyle
End Sub

Public Sub getEnabled As Boolean
	Return m_isEnabled
End Sub

Public Sub getDisabledBackgroundColor As Int
	Return  m_DisabledColor
End Sub

Public Sub setDisabledBackgroundColor(crl As Int)
	m_DisabledColor = crl
	UpdateStyle
End Sub

Public Sub getDisabledIconColor As Int
	Return  m_DisabledIconColor
End Sub

Public Sub setDisabledIconColor(crl As Int)
	m_DisabledIconColor = crl
	UpdateStyle
End Sub

Public Sub getisHaptic As Boolean
	Return m_isHaptic
End Sub

Public Sub setisHaptic(Enabled As Boolean)
	m_isHaptic = Enabled
End Sub

Public Sub getisEvent As Boolean
	Return m_isEvent
End Sub

Public Sub setisEvent(Enabled As Boolean)
	m_isEvent = Enabled
End Sub

Public Sub getisFontAswesome As Boolean
	Return m_isFontAswesome
End Sub

Public Sub setisFontAswesome(FontAwesome As Boolean)
	m_isFontAswesome = FontAwesome
End Sub

#If B4J
Private Sub xpnl_ClickPanel_MouseClicked (EventData As MouseEvent)
	If m_isEnabled = False Then Return
	xlbl_CheckBox_MouseClicked(EventData)
End Sub
#Else
Private Sub xpnl_ClickPanel_Click
	If m_isEnabled = False Then Return
	xlbl_CheckBox_Click
End Sub
#End If

#If B4J
Private Sub xlbl_CheckBox_MouseClicked (EventData As MouseEvent)
	If m_isEnabled = False Then Return
	If m_isChecked = True Then
		setChecked(False)
		Else
		setChecked(True)
	End If
End Sub
#Else
Private Sub xlbl_CheckBox_Click
	If m_isEnabled = False Then Return
	If m_isHaptic Then XUIViewsUtils.PerformHapticFeedback(mBase)
	If m_isChecked = True Then
		m_isChecked = False
		Check(m_isChecked,m_isCheckedAnimated,True)
	Else
		m_isChecked = True
		Check(m_isChecked,m_isCheckedAnimated,True)
	End If
End Sub
#End If

Private Sub CreateLabel(EventName As String) As B4XView
	Dim tmp_lbl As Label : tmp_lbl.Initialize(EventName)
	Return tmp_lbl
End Sub

'returns true if the size is too large
Private Sub CheckSize(size As Float) As Boolean
	xlbl_CheckBox.TextSize = size
	
		#if b4A
		Dim stuti As StringUtils
		Return MeasureTextWidth(xlbl_CheckBox.Text,xlbl_CheckBox.Font) > xlbl_CheckBox.Width Or stuti.MeasureMultilineTextHeight(xlbl_CheckBox,xlbl_CheckBox.Text) > xlbl_CheckBox.Height		
		#Else		
	Return MeasureTextWidth(xlbl_CheckBox.Text,xlbl_CheckBox.Font) > xlbl_CheckBox.Width Or MeasureTextHeight(xlbl_CheckBox.Text,xlbl_CheckBox.Font) > xlbl_CheckBox.Height
		#End If
		
End Sub

'https://www.b4x.com/android/forum/threads/b4x-xui-add-measuretextwidth-and-measuretextheight-to-b4xcanvas.91865/#content
Private Sub MeasureTextWidth(Text As String, Font1 As B4XFont) As Int
#If B4A
	Private bmp As Bitmap
	bmp.InitializeMutable(1, 1)'ignore
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringWidth(Text, Font1.ToNativeFont, Font1.Size)
#Else If B4i
    Return Text.MeasureWidth(Font1.ToNativeFont)
#Else If B4J
	Dim jo As JavaObject
	jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
	jo.RunMethod("setFont",Array(Font1.ToNativeFont))
	jo.RunMethod("setLineSpacing",Array(0.0))
	jo.RunMethod("setWrappingWidth",Array(0.0))
	Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
	Return Bounds.RunMethod("getWidth",Null)
#End If
End Sub

'https://www.b4x.com/android/forum/threads/b4x-xui-add-measuretextwidth-and-measuretextheight-to-b4xcanvas.91865/#content
Private Sub MeasureTextHeight(Text As String, Font1 As B4XFont) As Int'Ignore
#If B4A     
	Private bmp As Bitmap
	bmp.InitializeMutable(1, 1)'ignore
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringHeight(Text, Font1.ToNativeFont, Font1.Size)
	
#Else If B4i
    Return Text.MeasureHeight(Font1.ToNativeFont)
#Else If B4J
	Dim jo As JavaObject
	jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
	jo.RunMethod("setFont",Array(Font1.ToNativeFont))
	jo.RunMethod("setLineSpacing",Array(0.0))
	jo.RunMethod("setWrappingWidth",Array(0.0))
	Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
	Return Bounds.RunMethod("getHeight",Null)
#End If
End Sub

#Region Events

Private Sub CheckedChange
	If xui.SubExists(mCallBack,mEventName & "_CheckedChange",1) Then
		CallSub2(mCallBack,mEventName & "_CheckedChange",m_isChecked)
	End If
End Sub

#End Region