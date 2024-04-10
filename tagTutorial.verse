#You will need
# 3 button devices
# 1 Billboard device
# 1 Verse device
# And Devices alreay in a blank project when you open UEFN

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.
ButtonTag1:=class(tag){}
ButtonTag2:=class(tag){}
ButtonTag3:=class(tag){}
BillboardTag1:=class(tag){}

#Gameplay Tags Documenation
#https://dev.epicgames.com/documentation/en-us/uefn/gameplay-tags-in-verse

ButtonDevice := class(creative_device):

    TheBillboardText<localizes>(thetext : string) : message = "{thetext}"

    TheBillboardText2<localizes>(theNumber: int): message = "You pressed button {theNumber}"


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        
        Button1Init()
        Button2Init()
        Button3Init()
       


    Button1Init():void=
        buttonOne:=GetCreativeObjectsWithTag(ButtonTag1{})
        for(Obj : buttonOne):
            if(b :=button_device[Obj]):
                b.InteractedWithEvent.SubscribeAgent(buttonNPressed,1)

    Button2Init():void=
        buttonOne:=GetCreativeObjectsWithTag(ButtonTag2{})
        for(Obj : buttonOne):
            if(b :=button_device[Obj]):
                b.InteractedWithEvent.SubscribeAgent(buttonNPressed,2)

    Button3Init():void=
        buttonOne:=GetCreativeObjectsWithTag(ButtonTag3{})
        for(Obj : buttonOne):
            if(b :=button_device[Obj]):
                b.InteractedWithEvent.SubscribeAgent(buttonNPressed,3)
        


    buttonNPressed(Agent: agent, Text: int): void=
        billOne:=GetCreativeObjectsWithTag(BillboardTag1{})
        for(Obj : billOne):
            if(billboard1:=billboard_device[Obj]):
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
