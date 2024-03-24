#You will need
# 3 button devices
# 1 Billboard device
# 1 Verse device
# And Devices alreay in a blank project when you open UEFN



using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
ButtonDevice := class(creative_device):

    @editable button1: button_device = button_device{}
    #https://dev.epicgames.com/documentation/en-us/uefn/verse-api/fortnitedotcom/devices/button_device
    @editable button2: button_device = button_device{}

    @editable button3: button_device = button_device{}

    #@editable button4: button_device = button_device{}

    @editable billboard1 : billboard_device = billboard_device{}
    #https://dev.epicgames.com/documentation/en-us/uefn/verse-api/fortnitedotcom/devices/billboard_device

    TheBillboardText<localizes>(thetext : string) : message = "{thetext}"

    TheBillboardText2<localizes>(theNumber: int): message = "You pressed button {theNumber}"


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        #button1.InteractedWithEvent.Subscribe(button1Pressed)
        #button2.InteractedWithEvent.Subscribe(button2Pressed)
        #button3.InteractedWithEvent.Subscribe(button3Pressed)

        #button1.InteractedWithEvent.SubscribeAgent(buttonXPressed, "You pressed button 1")
        #button2.InteractedWithEvent.SubscribeAgent(buttonXPressed, "You pressed button 2")
        #button3.InteractedWithEvent.SubscribeAgent(buttonXPressed, "You pressed button 3")

        button1.InteractedWithEvent.SubscribeAgent(buttonNPressed, 1)
        button2.InteractedWithEvent.SubscribeAgent(buttonNPressed, 2)
        button3.InteractedWithEvent.SubscribeAgent(buttonNPressed, 3)
        


    button1Pressed(Agent: agent): void=
        billboard1.SetText(TheBillboardText("You pressed button 1"))
        billboard1.UpdateDisplay()
        billboard1.ShowText()

    button2Pressed(Agent: agent): void=
        billboard1.SetText(TheBillboardText("You pressed button 2"))
        billboard1.UpdateDisplay()
        billboard1.ShowText()

    button3Pressed(Agent: agent): void=
        billboard1.SetText(TheBillboardText("You pressed button 3"))
        billboard1.UpdateDisplay()
        billboard1.ShowText()

    buttonXPressed(Agent: agent, Text: string): void=
        billboard1.SetText(TheBillboardText(Text))
        billboard1.UpdateDisplay()
        billboard1.ShowText()

    buttonNPressed(Agent: agent, Text: int): void=
        billboard1.SetText(TheBillboardText("You pressed button {ToString(Text)}"))
        billboard1.UpdateDisplay()
        billboard1.ShowText()

    
    #https://dev.epicgames.com/community/snippets/d8k/fortnite-wrapping-subscribe-to-pass-additional-data-to-listeners


using { /Verse.org/Simulation }

(Listenable : listenable(agent)).SubscribeAgent(OutputFunc : tuple(agent, t)->void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_agent(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)

wrapper_agent(t : type) := class():
    ExtraData : t;
    OutputFunc : tuple(agent, t) -> void
    InputFunc(Agent : agent):void = OutputFunc(Agent, ExtraData)

(Listenable : listenable(tuple())).SubscribeEmpty(OutputFunc : t -> void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_empty(t) {ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)

wrapper_empty(t : type) := class():
    ExtraData : t;
    OutputFunc : t -> void
    InputFunc():void = OutputFunc(ExtraData)
